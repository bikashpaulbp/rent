import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:rent_management/insert_data/deposit_form.dart';
import 'package:rent_management/models/deposit_model.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/models/rent_model.dart';
import 'package:rent_management/models/tenant_model.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/services/deposite_service.dart';
import 'package:rent_management/services/flat_service.dart';
import 'package:rent_management/services/rent_service.dart';
import 'package:rent_management/services/tenant_service.dart';
import 'package:rent_management/shared_data/flat_data.dart';
import 'package:rent_management/shared_data/tenent_data.dart';

import '../shared_data/rent_data.dart';

class AllRent extends StatefulWidget {
  const AllRent({super.key});

  @override
  State<AllRent> createState() => _AllRentState();
}

class _AllRentState extends State<AllRent> {
  Stream<List<RentModel>> rentStream = const Stream.empty();

  List<TenantModel> tenantList = [];

  List<FlatModel> flatList = [];

  final _totalAmountController = TextEditingController();

  final format = DateFormat("yyyy-MM-dd");

  DateTime? date;

  bool isPaid = false;
  DateTime dateofPayment = DateTime.now();

  final TextEditingController confirmTextEditingController =
      TextEditingController();

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
  int? tenantId;
  int? flatId;
  String? tenantName;
  String? flatName;

  @override
  void initState() {
    _fetchRentData();
    getUser();
    getBuildingId();
    super.initState();
  }

  void refresh() {
    _fetchRentData();
    // _fetchData();
    getUser();
    getBuildingId();
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
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
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
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: StreamBuilder<List<RentModel>>(
                        stream: rentStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<RentModel>> snapshot) {
                          getBuildingId();
                          // _fetchData();
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data!.isNotEmpty) {
                            List<RentModel> rentList = snapshot.data!
                                .where((element) =>
                                    element.buildingId == buildingId)
                                .toList();

                            return ListView.builder(
                              itemCount: rentList.length,
                              itemBuilder: (BuildContext context, int index) {
                                RentModel rent = rentList[index];
                                List<TenantModel> tenants =
                                    context.watch<TenantData>().tenantList;
                                List<FlatModel> flats =
                                    context.watch<FlatData>().flatList;
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
                                                    'Tenant Name: $tenantName',
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Flat Name: $flatName',
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Month: ${rent.rentMonth != null ? DateFormat('dd MMM yy').format(rent.rentMonth!) : "N/A"}',
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                        backgroundColor:
                                                            rent.isPaid == true
                                                                ? const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    8,
                                                                    240,
                                                                    8)
                                                                : const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    246,
                                                                    59,
                                                                    59),
                                                        child: IconButton(
                                                            iconSize: 16,
                                                            color: rent.isPaid ==
                                                                    true
                                                                ? const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255)
                                                                : Colors.white,
                                                            onPressed:
                                                                rent.isPaid ==
                                                                        false
                                                                    ? () async {
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder: (BuildContext context) =>
                                                                              AlertDialog(
                                                                            actions: <Widget>[
                                                                              Center(
                                                                                child: Container(
                                                                                  width: 250,
                                                                                  height: 100,
                                                                                  color: Colors.white,
                                                                                  child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Center(child: Text('click confirm')),
                                                                                    ),
                                                                                    SizedBox(height: 15),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                      children: [
                                                                                        ElevatedButton(
                                                                                            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                                                                                            onPressed: () async {
                                                                                              getBuildingId();
                                                                                              getUser();
                                                                                              isPaid = true;
                                                                                              RentModel updatedRent = RentModel(id: rent.id, buildingId: buildingId, dueAmount: 0, gasBill: rent.gasBill, reciptNo: rent.reciptNo, isPrinted: false, rentAmount: rent.rentAmount, serviceCharge: rent.serviceCharge, waterBill: rent.waterBill, userId: rent.userId, rentMonth: rent.rentMonth, totalAmount: rent.totalAmount, isPaid: isPaid, flatId: rent.flatId, tenantId: rent.tenantId);
                                                                                              DepositeModel deposit = DepositeModel(rentId: rent.id, totalAmount: rent.totalAmount, depositeAmount: rent.totalAmount, dueAmount: 0, tranDate: dateofPayment, buildingId: buildingId, flatId: rent.flatId, tenantId: rent.tenantId, userId: userId);

                                                                                              await rentApiService.updateRent(id: rent.id!, rent: updatedRent);
                                                                                              await depositeApiService.createDeposite(deposit);

                                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("status has been changed to paid")));

                                                                                              setState(() {
                                                                                                _fetchRentData();
                                                                                              });
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                            child: Text('confirm')),
                                                                                        ElevatedButton(
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                            child: Text('cancel')),
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
                                                            const Color
                                                                .fromARGB(255,
                                                                34, 85, 251),
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
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return SingleChildScrollView(
                                                                    child:
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
                                                                                  ElevatedButton(
                                                                                    child: const Text('update'),
                                                                                    onPressed: () async {
                                                                                      RentModel updatedRent = RentModel(id: rent.id, tenantId: rent.tenantId, flatId: rent.flatId, rentMonth: rent.rentMonth, totalAmount: int.parse(_totalAmountController.text), isPaid: rent.isPaid, buildingId: rent.buildingId, dueAmount: rent.dueAmount, gasBill: rent.gasBill, isPrinted: false, reciptNo: rent.reciptNo, rentAmount: rent.rentAmount, serviceCharge: rent.serviceCharge, waterBill: rent.waterBill, userId: rent.userId);
                                                                                      await rentApiService.updateRent(id: rent.id!, rent: updatedRent);
                                                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("updated successfully")));

                                                                                      setState(() {
                                                                                        _fetchRentData();

                                                                                        Navigator.pop(context);
                                                                                      });
                                                                                    },
                                                                                  ),
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
                                                            Color.fromARGB(255,
                                                                240, 46, 46),
                                                        child: IconButton(
                                                            iconSize: 15,
                                                            color: Colors.white,
                                                            onPressed:
                                                                () async {
                                                              int? id = rent.id;
                                                              await rentApiService
                                                                  .deleteRent(
                                                                      id!);
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      SnackBar(
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
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height *
                                                        .09),
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Color
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
                                                    child: Text('Deposit'))
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
      ),
    );
  }
}
