import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/insert_data/deposit_form.dart';
import 'package:rent_management/models/building_model.dart';
import 'package:rent_management/models/deposit_model.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/models/floor_model.dart';
import 'package:rent_management/models/rent_model.dart';
import 'package:rent_management/models/tenant_model.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/screens/printing_device_page.dart';
import 'package:rent_management/services/deposite_service.dart';
import 'package:rent_management/services/flat_service.dart';
import 'package:rent_management/services/rent_service.dart';
import 'package:rent_management/services/tenant_service.dart';
import 'package:rent_management/shared_data/building_provider.dart';
import 'package:rent_management/shared_data/flat_data.dart';
import 'package:rent_management/shared_data/floor_data.dart';
import 'package:rent_management/shared_data/tenent_data.dart';

class CurrentMonthRent extends StatefulWidget {
  const CurrentMonthRent({super.key});

  @override
  State<CurrentMonthRent> createState() => _CurrentMonthRentState();
}

class _CurrentMonthRentState extends State<CurrentMonthRent> {
  late Stream<List<RentModel>> rentStream = const Stream.empty();
  List<TenantModel> finalTenantList = [];

  List<FlatModel> finalFlatList = [];

  final _totalAmountController = TextEditingController();

  final format = DateFormat("yyyy-MM-dd");

  DateTime? date;

  bool isPaid = false;
  DateTime now = DateTime.now();
  int? currentYear;
  int? currentMonth;

  int? tenantId;
  int? flatId;
  String? tenantName;
  String? flatName;

  DateTime dateofPayment = DateTime.now();

  final TextEditingController confirmTextEditingController =
      TextEditingController();

  bool isRentCurrentMonth(RentModel rent, int currentYear, int currentMonth) {
    try {
      DateTime date = rent.rentMonth!;
      int year = date.year;
      int month = date.month;
      return year == currentYear && month == currentMonth;
    } catch (_) {
      return false;
    }
  }

  RentApiService rentApiService = RentApiService();
  TenantApiService tenantApiService = TenantApiService();
  FlatApiService flatApiService = FlatApiService();
  DepositeApiService depositeApiService = DepositeApiService();
  UserModel user = UserModel();
  AuthStateManager authStateManager = AuthStateManager();
  UserModel? loggedInUser = UserModel();
  bool isLoading = false;
  int? buildingId;
  int? userId;
  String? buildingAddress;
  @override
  void initState() {
    _fetchRentData();
    getUser();
    getBuildingId();
    super.initState();
  }

  void refresh() {
    setState(() {
      _fetchRentData();
    });
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

  // Future<void> _fetchData() async {
  //   List<TenantModel> allTenantList = await tenantApiService.getAllTenants();
  //   List<FlatModel> allFlatList = await flatApiService.getAllFlats();
  //   tenantList = allTenantList;
  //   flatList = allFlatList;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Rent',
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
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
                                  currentYear = now.year,
                                  currentMonth = now.month))
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
                                        .firstWhere((element) =>
                                            element.id == buildingId)
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
                                        .firstWhere(
                                            (e) => e.id == rent.tenantId)
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  'Tenant Name:  ${values[2]}',
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
                                                  'Total Amount: ${rent.totalAmount}',
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
                                                  'Due Amount: ${rent.dueAmount == 0 || rent.dueAmount == null ? rent.totalAmount : rent.dueAmount}',
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
                                                  'Month: ${rent.rentMonth != null ? DateFormat('MMM yy').format(rent.rentMonth!) : "N/A"}',
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
                                                  rent.isPaid == false
                                                      ? "Status: Unpaid"
                                                      : "Status: Paid",
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
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 16,
                                                      backgroundColor: rent
                                                                  .isPaid ==
                                                              true
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 8, 240, 8)
                                                          : const Color
                                                              .fromARGB(
                                                              255, 246, 59, 59),
                                                      child: IconButton(
                                                          iconSize: 16,
                                                          color: rent.isPaid ==
                                                                  true
                                                              ? const Color
                                                                  .fromARGB(255,
                                                                  255, 255, 255)
                                                              : Colors.white,
                                                          onPressed:
                                                              rent.isPaid ==
                                                                      false
                                                                  ? () async {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext context) =>
                                                                                AlertDialog(
                                                                          actions: <Widget>[
                                                                            Center(
                                                                              child: Container(
                                                                                width: 250,
                                                                                height: 100,
                                                                                color: Colors.white,
                                                                                child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                  const Padding(
                                                                                    padding: EdgeInsets.all(8.0),
                                                                                    child: Center(child: Text('If You Sure Then Click Confirm')),
                                                                                  ),
                                                                                  const SizedBox(height: 15),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                    children: [
                                                                                      ElevatedButton(
                                                                                          style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                                                                                          onPressed: () async {
                                                                                            isPaid = true;
                                                                                            RentModel updatedRent = RentModel(id: rent.id, buildingId: buildingId, dueAmount: 0, gasBill: rent.gasBill, isPrinted: false, rentAmount: rent.rentAmount, serviceCharge: rent.serviceCharge, waterBill: rent.waterBill, userId: rent.userId, rentMonth: rent.rentMonth, totalAmount: rent.totalAmount, isPaid: isPaid, flatId: rent.flatId, tenantId: rent.tenantId);
                                                                                            DepositeModel deposit = DepositeModel(rentId: rent.id, totalAmount: rent.totalAmount, depositeAmount: rent.totalAmount, dueAmount: 0, tranDate: dateofPayment, buildingId: buildingId, flatId: rent.flatId, tenantId: rent.tenantId, userId: userId);
                                                                                            Navigator.of(context).pop();

                                                                                            await rentApiService.updateRent(rent: updatedRent, id: rent.id!);
                                                                                            await depositeApiService.createDeposite(deposit);
                                                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("status has been changed to paid")));

                                                                                            setState(() {
                                                                                              _fetchRentData();
                                                                                            });
                                                                                          },
                                                                                          child: const Text('confirm')),
                                                                                      ElevatedButton(
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                          child: const Text('cancel')),
                                                                                    ],
                                                                                  )
                                                                                ]),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }
                                                                  : null,
                                                          icon: const Icon(
                                                              Icons.paid)),
                                                    ),
                                                    const SizedBox(width: 2),
                                                    CircleAvatar(
                                                      radius: 15,
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 34, 85, 251),
                                                      child: IconButton(
                                                          iconSize: 15,
                                                          color: Colors.white,
                                                          onPressed: () {
                                                            _totalAmountController
                                                                    .text =
                                                                rent.totalAmount
                                                                    .toString();

                                                            showModalBottomSheet<
                                                                void>(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return SingleChildScrollView(
                                                                  child:
                                                                      StatefulBuilder(
                                                                    builder: (context,
                                                                            setState) =>
                                                                        Container(
                                                                      height:
                                                                          400,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: <Widget>[
                                                                            const Padding(
                                                                              padding: EdgeInsets.all(20.0),
                                                                              child: Text('Update Your Information'),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(14.0),
                                                                              child: Column(
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      const SizedBox(
                                                                                        child: Text(
                                                                                          'Total Amount',
                                                                                          style: TextStyle(
                                                                                            fontSize: 16,
                                                                                            color: Color.fromARGB(255, 78, 78, 78),
                                                                                            fontStyle: FontStyle.normal,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 250,
                                                                                        height: 50,
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: TextFormField(
                                                                                            keyboardType: TextInputType.number,
                                                                                            controller: _totalAmountController,
                                                                                            decoration: InputDecoration(
                                                                                              border: OutlineInputBorder(
                                                                                                borderRadius: BorderRadius.circular(10),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  isLoading == false
                                                                                      ? ElevatedButton(
                                                                                          child: const Text('update'),
                                                                                          onPressed: () async {
                                                                                            setState(() {
                                                                                              isLoading = true;
                                                                                            });
                                                                                            RentModel updatedRent = RentModel(id: rent.id, tenantId: rent.tenantId, flatId: rent.flatId, rentMonth: rent.rentMonth, totalAmount: int.parse(_totalAmountController.text), isPaid: rent.isPaid, buildingId: rent.buildingId, dueAmount: rent.dueAmount, gasBill: rent.gasBill, isPrinted: false, rentAmount: rent.rentAmount, serviceCharge: rent.serviceCharge, waterBill: rent.waterBill, userId: rent.userId);
                                                                                            await rentApiService.updateRent(id: rent.id!, rent: updatedRent);
                                                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("updated successfully")));

                                                                                            setState(() {
                                                                                              refresh();
                                                                                              isLoading = false;
                                                                                              Navigator.pop(context);
                                                                                            });
                                                                                          },
                                                                                        )
                                                                                      : const CircularProgressIndicator(),
                                                                                  const SizedBox(
                                                                                    width: 20,
                                                                                  ),
                                                                                  ElevatedButton(
                                                                                    child: const Text('Cancel'),
                                                                                    onPressed: () => Navigator.pop(context),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          icon: const Icon(
                                                              Icons.edit)),
                                                    ),
                                                    const SizedBox(width: 2),
                                                    CircleAvatar(
                                                      radius: 15,
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 240, 46, 46),
                                                      child: IconButton(
                                                          iconSize: 15,
                                                          color: Colors.white,
                                                          onPressed: () async {
                                                            int? id = rent.id;
                                                            await rentApiService
                                                                .deleteRent(
                                                                    id!);
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text("deleted successfully")));
                                                            setState(() {
                                                              _fetchRentData();
                                                            });
                                                          },
                                                          icon: const Icon(
                                                              Icons.delete)),
                                                    ),
                                                  ]),
                                              SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          .09),
                                              ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  171,
                                                                  12,
                                                                  219))),
                                                  onPressed:
                                                      rent.isPaid == false
                                                          ? () {
                                                              Get.to(DepositDataPage(
                                                                  refresh:
                                                                      refresh,
                                                                  rentID:
                                                                      rent.id ??
                                                                          0));
                                                            }
                                                          : null,
                                                  child: const Text('Deposit')),
                                              ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  12,
                                                                  91,
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
                                                      ? const Text('   Print  ')
                                                      : const Text('Re-print'))
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
      ),
    );
  }
}
