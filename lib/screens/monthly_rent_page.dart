import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rent_management/classes/rent_info.dart';

import 'package:rent_management/classes/tenent_info.dart';
import 'package:rent_management/db_helper.dart';
import 'package:rent_management/insert_data/rent.dart';


class MonthlyRent extends StatefulWidget {
  const MonthlyRent({super.key});

  @override
  State<MonthlyRent> createState() => _MonthlyRentState();
}

class _MonthlyRentState extends State<MonthlyRent> {
  late Stream<List<RentInfo>> rentStream = const Stream.empty();
  TenentInfo? tenentInfo;
  List<TenentInfo> tenentList = [];

  final _totalAmountController = TextEditingController();

  final format = DateFormat("yyyy-MM-dd");

  String? date;

  int isPaid = 0;

  @override
  void initState() {
    setState(() {
      _fetchData();
    });

    super.initState();
  }

  Future<void> _fetchData() async {
    rentStream = DBHelper.readRentData().asStream();

    tenentList = await DBHelper.readTenentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 226, 204, 2),
          title: const Center(child: Text('Monthly Rent List'))),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Get.offAll(RentDataPage());
                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          'ADD MONTHLY RENT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      width: 500,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 63, 56, 200),
                            Color(0xFF985EFF),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                    height: 500,
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  'ID: ${rent.id}',
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
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
                                                  'Tenent Name: ${rent.tenentName}',
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
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
                                                  'Floor Name: ${rent.floorName}',
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
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
                                                  'Flat Name: ${rent.flatName}',
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
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
                                                  'Total Amount: ${rent.totalAmount.toString()}',
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
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
                                                  'Month: ${rent.month.toString()}',
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
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
                                                  rent.isPaid == 0
                                                      ? "Status: Unpaid"
                                                      : "Status: Paid",
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor: rent.isPaid == 1
                                              ? Color.fromARGB(255, 8, 240, 8)
                                              : Color.fromARGB(
                                                  255, 246, 59, 59),
                                          child: IconButton(
                                              iconSize: 16,
                                              color: rent.isPaid == 1
                                                  ? Color.fromARGB(
                                                      255, 255, 255, 255)
                                                  : Colors.white,
                                              onPressed: () async {
                                                isPaid = 1;
                                                RentInfo updatedRent = RentInfo(
                                                    id: rent.id,
                                                    tenentName: rent.tenentName,
                                                    tenentID: rent.tenentID,
                                                    floorID: rent.floorID,
                                                    floorName: rent.floorName,
                                                    flatID: rent.flatID,
                                                    flatName: rent.flatName,
                                                    month: rent.month,
                                                    totalAmount:
                                                        rent.totalAmount,
                                                    isPaid: isPaid);
                                                await DBHelper.updateRent(
                                                    updatedRent);
                                                Get.snackbar("", "",
                                                    messageText: Center(
                                                        child: Text(
                                                      "status has been changed to paid  \n",
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0),
                                                          fontSize: 20),
                                                    )),
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    duration:
                                                        Duration(seconds: 2));

                                                setState(() {
                                                  _fetchData();
                                                  isPaid = 0;
                                                });
                                              },
                                              icon: Icon(Icons.paid)),
                                        ),
                                        SizedBox(width: 10),
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundColor: const Color.fromARGB(
                                              255, 145, 145, 145),
                                          child: IconButton(
                                              iconSize: 15,
                                              color: Colors.white,
                                              onPressed: () {
                                                _totalAmountController.text =
                                                    rent.totalAmount.toString();

                                                showModalBottomSheet<void>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return SingleChildScrollView(
                                                      child: Container(
                                                        height: 400,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 255, 255, 255),
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            // mainAxisSize:
                                                            //     MainAxisSize.min,
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        20.0),
                                                                child: const Text(
                                                                    'Update Your Information'),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        14.0),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        const SizedBox(
                                                                          child:
                                                                              Text(
                                                                            'Total Amount',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 16,
                                                                              color: Color.fromARGB(255, 78, 78, 78),
                                                                              fontStyle: FontStyle.normal,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              250,
                                                                          height:
                                                                              50,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                TextFormField(
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
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    ElevatedButton(
                                                                      child: const Text(
                                                                          'update'),
                                                                      onPressed:
                                                                          () async {
                                                                        RentInfo updatedRent = RentInfo(
                                                                            id: rent
                                                                                .id,
                                                                            tenentName:
                                                                                rent.tenentName,
                                                                            tenentID: rent.tenentID,
                                                                            floorID: rent.floorID,
                                                                            floorName: rent.floorName,
                                                                            flatID: rent.flatID,
                                                                            flatName: rent.flatName,
                                                                            month: rent.month,
                                                                            totalAmount: double.parse(_totalAmountController.text),
                                                                            isPaid: rent.isPaid);
                                                                        await DBHelper.updateRent(
                                                                            updatedRent);
                                                                        Get.snackbar(
                                                                            "",
                                                                            "",
                                                                            messageText: Center(
                                                                                child: Text(
                                                                              "updated successfully  \n",
                                                                              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                                                                            )),
                                                                            snackPosition: SnackPosition.BOTTOM,
                                                                            duration: Duration(seconds: 2));

                                                                        setState(
                                                                            () {
                                                                          _fetchData();

                                                                          Navigator.pop(
                                                                              context);
                                                                        });
                                                                      },
                                                                    ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    ElevatedButton(
                                                                      child: const Text(
                                                                          'Cancel'),
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
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
                                              icon: Icon(Icons.edit)),
                                        ),
                                        SizedBox(width: 10),
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundColor: const Color.fromARGB(
                                              255, 145, 145, 145),
                                          child: IconButton(
                                              iconSize: 15,
                                              color: Colors.white,
                                              onPressed: () async {
                                                int? id = rent.id;
                                                await DBHelper.deleteRent(id);
                                                Get.snackbar("", "",
                                                    messageText: Center(
                                                        child: Text(
                                                      "deleted successfully  \n",
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0),
                                                          fontSize: 20),
                                                    )),
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    duration:
                                                        Duration(seconds: 1));
                                                setState(() {
                                                  _fetchData();
                                                });
                                              },
                                              icon: Icon(Icons.delete)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(
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
