import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/classes/deposit.dart';
import 'package:rent_management/insert_data/deposit_form.dart';
import 'package:rent_management/models/deposit_model.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/models/rent_model.dart';
import 'package:rent_management/models/tenant_model.dart';
import 'package:rent_management/services/deposite_service.dart';
import 'package:rent_management/services/flat_service.dart';
import 'package:rent_management/services/rent_service.dart';
import 'package:rent_management/services/tenant_service.dart';

import '../classes/rent_info.dart';
import '../classes/tenent_info.dart';
import '../db_helper.dart';
import '../shared_data/rent_data.dart';

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
    DateTime date = rent.rentMonth!;
    int year = date.year;
    int month = date.month;
    return year == currentYear && month == currentMonth;
  }

  RentApiService rentApiService = RentApiService();
  TenantApiService tenantApiService = TenantApiService();
  FlatApiService flatApiService = FlatApiService();
  DepositeApiService depositeApiService = DepositeApiService();

  @override
  void initState() {
    super.initState();
    _fetchRentData();
  }

  void refresh() {
    _fetchRentData();
  }

  Future<void> _fetchRentData() async {
    List<RentModel> rentList = await rentApiService.getAllRents();
    List<TenantModel> tenantList = await tenantApiService.getAllTenants();
    List<FlatModel> flatList = await flatApiService.getAllFlats();
    finalTenantList = tenantList;
    finalFlatList = flatList;
    rentStream = rentApiService.getAllRents().asStream();
    setState(() {
      Provider.of<RentData>(context, listen: false).updateRentList(rentList);
    });
  }

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
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data!.isNotEmpty) {
                          List<RentModel> rentList = snapshot.data!
                              .where((rent) => isRentCurrentMonth(
                                  rent,
                                  currentYear = now.year,
                                  currentMonth = now.month))
                              .toList();
                          return ListView.builder(
                            itemCount: rentList.length,
                            itemBuilder: (BuildContext context, int index) {
                              RentModel rent = rentList[index];
                              // flatId = finalFlatList
                              //     .firstWhere(
                              //         (flat) => flat.id == rent.flatId)
                              //     .id;
                              // int? finalFlatId = flatId;
                              flatName = finalFlatList
                                  .firstWhere((flat) => flat.id == rent.flatId)
                                  .name;
                              String? finalFlatName = flatName;
                              // tenantId = finalTenantList
                              //     .firstWhere(
                              //         (tenant) => tenant.id == rent.flatId)
                              //     .id;
                              // int? finalTenantId = tenantId;
                              tenantName = finalTenantList
                                  .firstWhere(
                                      (tenant) => tenant.id == rent.tenantId)
                                  .name;
                              String? finalTenantName = tenantName;

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
                                                  'Tenent Name: $finalTenantName',
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
                                                  'Flat Name: $finalFlatName',
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
                                                  'Month: ${rent.rentMonth != null ? DateFormat('dd MMM yy').format(rent.rentMonth!) : "N/A"}',
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
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Center(child: Text('If You Sure Then Click Confirm')),
                                                                                  ),
                                                                                  SizedBox(height: 15),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                    children: [
                                                                                      ElevatedButton(
                                                                                          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                                                                                          onPressed: () async {
                                                                                            isPaid = true;
                                                                                            RentModel updatedRent = RentModel(id: rent.id, rentMonth: rent.rentMonth, totalAmount: rent.totalAmount, isPaid: isPaid, flatId: rent.flatId, tenantId: rent.tenantId);
                                                                                            DepositeModel deposit = DepositeModel(rentId: rent.id!, totalAmount: rent.totalAmount, depositeAmount: rent.totalAmount, dueAmount: 0.0, depositeDate: dateofPayment);
                                                                                            Navigator.of(context).pop();

                                                                                            await rentApiService.updateRent(rent: updatedRent, id: rent.id!);
                                                                                            // await depositeApiService.createDeposite(deposit);
                                                                                            Get.snackbar("", "",
                                                                                                messageText: Center(
                                                                                                    child: const Text(
                                                                                                  "status has been changed to paid  \n",
                                                                                                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                                                                                                )),
                                                                                                snackPosition: SnackPosition.BOTTOM,
                                                                                                duration: const Duration(seconds: 2));

                                                                                            setState(() {
                                                                                              _fetchRentData();
                                                                                            });
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
                                                                      Container(
                                                                    height: 400,
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
                                                                            padding:
                                                                                EdgeInsets.all(20.0),
                                                                            child:
                                                                                Text('Update Your Information'),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(14.0),
                                                                            child:
                                                                                Column(
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
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                ElevatedButton(
                                                                                  child: const Text('update'),
                                                                                  onPressed: () async {
                                                                                    RentModel updatedRent = RentModel(id: rent.id, tenantId: rent.tenantId, flatId: rent.flatId, rentMonth: rent.rentMonth, totalAmount: double.parse(_totalAmountController.text), isPaid: rent.isPaid);
                                                                                    await rentApiService.updateRent(id: rent.id!, rent: updatedRent);
                                                                                    Get.snackbar("", "",
                                                                                        messageText: const Center(
                                                                                            child: Text(
                                                                                          "updated successfully  \n",
                                                                                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                                                                                        )),
                                                                                        snackPosition: SnackPosition.BOTTOM,
                                                                                        duration: const Duration(seconds: 2));

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
                                                          Color.fromARGB(
                                                              255, 240, 46, 46),
                                                      child: IconButton(
                                                          iconSize: 15,
                                                          color: Colors.white,
                                                          onPressed: () async {
                                                            int? id = rent.id;
                                                            await rentApiService
                                                                .deleteRent(
                                                                    id!);
                                                            Get.snackbar("", "",
                                                                messageText:
                                                                    const Center(
                                                                        child:
                                                                            Text(
                                                                  "deleted successfully  \n",
                                                                  style: TextStyle(
                                                                      color: Color
                                                                          .fromARGB(
                                                                              255,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      fontSize:
                                                                          20),
                                                                )),
                                                                snackPosition:
                                                                    SnackPosition
                                                                        .BOTTOM,
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            1));
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
    );
  }
}
