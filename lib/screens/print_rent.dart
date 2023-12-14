import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'dart:async';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/models/building_model.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/models/floor_model.dart';
import 'package:rent_management/models/rent_model.dart';
import 'package:rent_management/models/tenant_model.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/screens/printing_device_page.dart';
import 'package:rent_management/services/deposite_service.dart';
import 'package:rent_management/services/flat_service.dart';
import 'package:rent_management/services/floor_service.dart';
import 'package:rent_management/services/rent_service.dart';
import 'package:rent_management/services/tenant_service.dart';
import 'package:rent_management/shared_data/building_provider.dart';
import 'package:rent_management/shared_data/flat_data.dart';
import 'package:rent_management/shared_data/floor_data.dart';
import 'package:rent_management/shared_data/tenent_data.dart';

class PrintRent extends StatefulWidget {
  const PrintRent({super.key});

  @override
  State<PrintRent> createState() => _PrintRentState();
}

class _PrintRentState extends State<PrintRent> {
  DateTime selectedDate = DateTime.now();
  late Stream<List<RentModel>> rentStream = const Stream.empty();
  List<TenantModel> finalTenantList = [];
  List<FlatModel> finalFlatList = [];
  final format = DateFormat("yyyy-MM-dd");
  DateTime? date;

  bool isPaid = false;
  DateTime now = DateTime.now();
  int? year;
  int? month;

  int? tenantId;
  int? flatId;
  // String? tenantName;
  // String? flatName;
  // String? floorName;

  DateTime dateofPayment = DateTime.now();

  final TextEditingController confirmTextEditingController =
      TextEditingController();

  bool isRentCurrentMonth(RentModel rent, int currentYear, int currentMonth) {
    DateTime date = rent.rentMonth!;
    int year = date.year;
    int month = date.month;
    return year == currentYear && month == currentMonth;
  }

  RentApiService rentApiService = RentApiService();
  TenantApiService tenantApiService = TenantApiService();
  FlatApiService flatApiService = FlatApiService();
  DepositeApiService depositeApiService = DepositeApiService();
  FloorApiService floorApiService = FloorApiService();
  UserModel user = UserModel();
  AuthStateManager authStateManager = AuthStateManager();
  UserModel? loggedInUser = UserModel();
  bool isLoading = false;
  int? buildingId;
  int? userId;
  String? buildingAddress;
  void refresh() async {
    await _fetchRentData();
  }

  Future<void> getUser() async {
    user = (await authStateManager.getLoggedInUser())!;
    userId = user.id;
  }

  Future<void> getBuildingId() async {
    buildingId = await authStateManager.getBuildingId();
  }

  Future<void> _fetchRentData() async {
    rentStream = rentApiService.getAllRents().asStream();
  }

  // BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  // List<BluetoothDevice> _devices = [];
  // String _deviceMsg = "";

  @override
  void initState() {
    _fetchRentData();
    getUser();
    getBuildingId();

    super.initState();
  }

  // Future<void> initPrinter() async {
  //   bluetoothPrint.startScan(timeout: Duration(seconds: 2));
  //   if (!mounted) return;
  //   bluetoothPrint.scanResults.listen((event) {
  //     if (!mounted) return;
  //     setState(() {
  //       _devices = event;
  //     });
  //     if (_devices.isEmpty) {
  //       setState(() {
  //         _deviceMsg = "No Devices";
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose Rent to Print")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Selected Month and Year:',
              ),
            ),
            Text(
              DateFormat('MMM yyyy').format(selectedDate),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: Colors.blue,
                        hintColor: Colors.blue,
                        colorScheme: ColorScheme.light(primary: Colors.blue),
                        buttonTheme:
                            ButtonThemeData(textTheme: ButtonTextTheme.primary),
                      ),
                      child: child!,
                    );
                  },
                );

                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = DateTime(picked.year, picked.month);
                  });
                }
              },
              child: Text('Select Month and Year'),
            ),
            Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Rents',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 78, 78, 78),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 510,
                  child: StreamBuilder<List<RentModel>>(
                    stream: rentStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<RentModel>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data!.isNotEmpty) {
                        getBuildingId();
                        getUser();

                        List<RentModel> allRentList = snapshot.data!
                            .where(
                                (element) => element.buildingId == buildingId)
                            .toList();
                        List<RentModel> rentList = allRentList
                            .where((rent) => isRentCurrentMonth(
                                rent,
                                year = selectedDate.year,
                                month = selectedDate.month))
                            .toList();
                        return ListView.builder(
                          itemCount: rentList.length,
                          itemBuilder: (BuildContext context, int index) {
                            RentModel rent = rentList[index];
                            List<String> getRentItemValues() {
                              String? tenantName;
                              String? flatName;
                              String? floorName;

                              List<TenantModel> tenants =
                                  context.watch<TenantData>().tenantList;
                              List<FlatModel> flats =
                                  context.watch<FlatData>().flatList;
                              List<FloorModel> floors =
                                  context.watch<FloorData>().floorList;
                              List<BuildingModel> buildings = context
                                  .watch<BuildingProvider>()
                                  .buildingList;

                              if (floors.isNotEmpty) {
                                try {
                                  int? flatId = flats
                                      .firstWhere((e) => e.id == rent.flatId)
                                      .id;
                                  int? floorId = flats
                                      .firstWhere((e) => e.id == flatId)
                                      .floorId;
                                  floorName = floors
                                      .firstWhere((e) => e.id == floorId)
                                      .name;
                                  buildingAddress = buildings
                                      .firstWhere(
                                          (element) => element.id == buildingId)
                                      .address;
                                } catch (_) {}
                              } else {
                                flatName = "floor not found";
                              }
                              if (flats.isNotEmpty) {
                                try {
                                  flatName = flats
                                      .firstWhere((e) => e.id == rent.flatId)
                                      .name;
                                } catch (_) {}
                              } else {
                                flatName = "flat not found";
                              }
                              if (tenants.isNotEmpty) {
                                try {
                                  tenantName = tenants
                                      .firstWhere((e) => e.id == rent.tenantId)
                                      .name;
                                } catch (_) {}
                              } else {
                                tenantName = "tenant not found";
                              }

                              return [
                                floorName ?? 'Unknown Floor',
                                flatName ?? 'Unknown Flat',
                                tenantName ?? 'Unknown Tenant',
                              ];
                            }

                            var values = getRentItemValues();

                            return ListTile(
                              title: Card(
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                'Receipt No:',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                '${rent.reciptNo}',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                'Tenant Name: ${values[2]}',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                'Floor Name: ${values[0]}',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                'Flat Name: ${values[1]}',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                'Rent Amount: ${rent.rentAmount}',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                'Water Bill: ${rent.waterBill}',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                'Gas Bill: ${rent.gasBill}',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                'Service Charge: ${rent.serviceCharge}',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                'Total Amount: ${rent.totalAmount}',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            // Padding(
                                            //   padding:
                                            //       const EdgeInsets.all(5.0),
                                            //   child: Text(
                                            //     'Due Amount: ${rent.dueAmount == 0 || rent.dueAmount == null ? rent.totalAmount : rent.dueAmount}',
                                            //     style: const TextStyle(
                                            //       color: Color.fromARGB(
                                            //           255, 0, 0, 0),
                                            //       fontSize: 16,
                                            //       fontWeight: FontWeight.bold,
                                            //     ),
                                            //   ),
                                            // ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                'Rent Month: ${rent.rentMonth != null ? DateFormat(' MMM yyy').format(rent.rentMonth!) : "N/A"}',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 50),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        .09),
                                            ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Color.fromARGB(
                                                                255,
                                                                12,
                                                                188,
                                                                219))),
                                                onPressed: () async {
                                                  Get.to(PrintingPage(
                                                    rent: rent,
                                                    floorName: values[0],
                                                    tenantName: values[2],
                                                    flatName: values[1],
                                                    buildingAddress:
                                                        buildingAddress,
                                                    refresh: refresh,
                                                  ));
                                                },
                                                child: rent.isPrinted == false
                                                    ? Text('Print')
                                                    : Text('Re-print'))
                                          ]),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                            child: Text('no  monthly rents available.'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
