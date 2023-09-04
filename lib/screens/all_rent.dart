import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/classes/deposit.dart';
import 'package:rent_management/classes/rent_info.dart';

import 'package:rent_management/classes/tenent_info.dart';
import 'package:rent_management/db_helper.dart';
import 'package:rent_management/insert_data/deposit_form.dart';

import '../shared_data/rent_data.dart';

class AllRent extends StatefulWidget {
  const AllRent({super.key});

  @override
  State<AllRent> createState() => _AllRentState();
}

class _AllRentState extends State<AllRent> {
  late Stream<List<RentInfo>> rentStream = const Stream.empty();
  TenentInfo? tenentInfo;
  List<TenentInfo> tenentList = [];

  final _totalAmountController = TextEditingController();

  final format = DateFormat("yyyy-MM-dd");

  String? date;

  int isPaid = 0;
  String dateofPayment = DateFormat('dd MMM y').format(DateTime.now());

  final TextEditingController confirmTextEditingController =
      TextEditingController();

  @override
  void initState() {
    _fetchData();

    super.initState();
  }

  Future<void> _fetchData() async {
    List<RentInfo> rentList = await DBHelper.readRentData();
    tenentList = await DBHelper.readTenentData();
    rentStream = DBHelper.readRentData().asStream();
    setState(() {
      Provider.of<RentData>(context, listen: false).updateRentList(rentList);
    });
  }

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
                      child: StreamBuilder<List<RentInfo>>(
                        stream: rentStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<RentInfo>> snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data!.isNotEmpty) {
                            List<RentInfo> rentList = snapshot.data!;

                            return ListView.builder(
                              itemCount: rentList.length,
                              itemBuilder: (BuildContext context, int index) {
                                RentInfo rent = rentList[index];

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
                                                // Padding(
                                                //   padding:
                                                //       const EdgeInsets.all(5.0),
                                                //   child: Text(
                                                //     'ID: ${rent.id}',
                                                //     style: TextStyle(
                                                //       color: const Color.fromARGB(
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
                                                    'Tenent Name: ${rent.tenentName}',
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                // Padding(
                                                //   padding:
                                                //       const EdgeInsets.all(5.0),
                                                //   child: Text(
                                                //     'Floor Name: ${rent.floorName}',
                                                //     style: TextStyle(
                                                //       color: const Color.fromARGB(
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
                                                    'Flat Name: ${rent.flatName}',
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
                                                    'Total Amount: ${rent.totalAmount.toString()}',
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
                                                    'Month: ${rent.month.toString()}',
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
                                                    rent.isPaid == 0
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
                                                            rent.isPaid == 1
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
                                                                    1
                                                                ? const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255)
                                                                : Colors.white,
                                                            onPressed:
                                                                rent.isPaid == 0
                                                                    ? () async {
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder: (BuildContext context) =>
                                                                              AlertDialog(
                                                                            actions: <Widget>[
                                                                              Center(
                                                                                child: Container(
                                                                                  width: 300,
                                                                                  height: 200,
                                                                                  color: Colors.white,
                                                                                  child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Center(child: Text('please type CONFIRM')),
                                                                                    ),
                                                                                    SizedBox(height: 20),
                                                                                    TextFormField(
                                                                                      controller: confirmTextEditingController,
                                                                                      keyboardType: TextInputType.name,
                                                                                      decoration: InputDecoration(
                                                                                        labelText: 'CONFIRM',
                                                                                        border: OutlineInputBorder(
                                                                                          borderRadius: BorderRadius.circular(10),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(height: 30),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      children: [
                                                                                        ElevatedButton(
                                                                                            onPressed: () async {
                                                                                              if (confirmTextEditingController.text == "CONFIRM") {
                                                                                                isPaid = 1;
                                                                                                RentInfo updatedRent = RentInfo(
                                                                                                    id: rent.id,
                                                                                                    tenentName: rent.tenentName,
                                                                                                    tenentID: rent.tenentID,
                                                                                                    // floorID: rent.floorID,
                                                                                                    // floorName: rent.floorName,
                                                                                                    flatID: rent.flatID,
                                                                                                    flatName: rent.flatName,
                                                                                                    month: rent.month,
                                                                                                    totalAmount: rent.totalAmount,
                                                                                                    isPaid: 1);
                                                                                                Deposit deposit = Deposit(rentID: rent.id!, rentMonth: rent.month, tenantID: rent.tenentID, tenantName: rent.tenentName, flatID: rent.flatID, flatName: rent.flatName, totalAmount: rent.totalAmount, depositAmount: rent.totalAmount, dueAmount: 0.0, date: dateofPayment);
                                                                                                Navigator.of(context).pop();

                                                                                                await DBHelper.updateRent(updatedRent);
                                                                                                await DBHelper.insertDepositData(deposit);
                                                                                                Get.snackbar("", "",
                                                                                                    messageText: Center(
                                                                                                        child: const Text(
                                                                                                      "status has been changed to paid  \n",
                                                                                                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                                                                                                    )),
                                                                                                    snackPosition: SnackPosition.BOTTOM,
                                                                                                    duration: const Duration(seconds: 2));

                                                                                                setState(() {
                                                                                                  _fetchData();
                                                                                                });
                                                                                              } else {
                                                                                                Get.snackbar("", "",
                                                                                                    messageText: Center(
                                                                                                        child: const Text(
                                                                                                      "please type CONFIRM  \n",
                                                                                                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                                                                                                    )),
                                                                                                    snackPosition: SnackPosition.BOTTOM,
                                                                                                    duration: const Duration(seconds: 2));
                                                                                              }
                                                                                            },
                                                                                            child: Text('confirm')),
                                                                                        SizedBox(
                                                                                          width: 50,
                                                                                        ),
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
                                                                145, 145, 145),
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
                                                                          // mainAxisSize:
                                                                          //     MainAxisSize.min,
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
                                                                                      RentInfo updatedRent = RentInfo(
                                                                                          id: rent.id,
                                                                                          tenentName: rent.tenentName,
                                                                                          tenentID: rent.tenentID,
                                                                                          // floorID: rent.floorID,
                                                                                          // floorName: rent.floorName,
                                                                                          flatID: rent.flatID,
                                                                                          flatName: rent.flatName,
                                                                                          month: rent.month,
                                                                                          totalAmount: double.parse(_totalAmountController.text),
                                                                                          isPaid: rent.isPaid);
                                                                                      await DBHelper.updateRent(updatedRent);
                                                                                      Get.snackbar("", "",
                                                                                          messageText: const Center(
                                                                                              child: Text(
                                                                                            "updated successfully  \n",
                                                                                            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                                                                                          )),
                                                                                          snackPosition: SnackPosition.BOTTOM,
                                                                                          duration: const Duration(seconds: 2));

                                                                                      setState(() {
                                                                                        _fetchData();

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
                                                            const Color
                                                                .fromARGB(255,
                                                                145, 145, 145),
                                                        child: IconButton(
                                                            iconSize: 15,
                                                            color: Colors.white,
                                                            onPressed:
                                                                () async {
                                                              int? id = rent.id;
                                                              await DBHelper
                                                                  .deleteRent(
                                                                      id);
                                                              Get.snackbar(
                                                                  "", "",
                                                                  messageText:
                                                                      const Center(
                                                                          child:
                                                                              Text(
                                                                    "deleted successfully  \n",
                                                                    style: TextStyle(
                                                                        color: Color.fromARGB(
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
                                                                _fetchData();
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
                                                                .all(Colors
                                                                    .yellow)),
                                                    onPressed: () {
                                                      Get.to(DepositDataPage(
                                                          rentID:
                                                              rent.id ?? 0));
                                                    },
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
