import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_management/classes/rent_info.dart';

import 'package:rent_management/classes/tenent_info.dart';
import 'package:rent_management/db_helper.dart';

import 'dashboard_page.dart';

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
        backgroundColor: const Color.fromARGB(255, 125, 125, 125),
        leading: IconButton(
          icon: const Icon(Icons.arrow_circle_left_outlined, size: 35),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            );
          },
        ),
        title: const Center(child: Text('Monthly Rent Process')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    width: 500,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 180, 180, 180)
                              .withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 134, 134, 134),
                                    width: 1.0,
                                  ),
                                ),
                                padding: const EdgeInsets.only(
                                  left: 105,
                                  right: 105,
                                ),
                                child: const Text(
                                  'Monthly Rent',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 134, 134, 134),
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(
                                        child: Text(
                                          'Month of Rent',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 78, 78, 78),
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 250,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(children: <Widget>[
                                            DateTimeField(
                                              decoration: InputDecoration(
                                                  hintText: 'select month',
                                                  icon: Icon(
                                                      Icons.calendar_month)),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  date = newValue.toString();
                                                  print(date);
                                                });
                                              },
                                              format: format,
                                              onShowPicker:
                                                  (context, currentValue) {
                                                return showDatePicker(
                                                  context: context,
                                                  firstDate: DateTime(1900),
                                                  initialDate: currentValue ??
                                                      DateTime.now(),
                                                  lastDate: DateTime(2100),
                                                );
                                              },
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Spacer(),
                                    InkWell(
                                      onTap: () =>  {
                                        if (date == "")
                                          {}
                                        else
                                          {
                                            for (var i in tenentList)
                                              {
                                                tenentInfo = TenentInfo(
                                                    floorID: i.floorID,
                                                    floorName: i.floorName,
                                                    flatID: i.flatID,
                                                    flatName: i.flatName,
                                                    tenentName: i.tenentName,
                                                    nidNo: i.nidNo,
                                                    birthCertificateNo:
                                                        i.birthCertificateNo,
                                                    mobileNo: i.mobileNo,
                                                    emgMobileNo: i.emgMobileNo,
                                                    noOfFamilyMem:
                                                        i.noOfFamilyMem,
                                                    rentAmount: i.rentAmount,
                                                    gasBill: i.gasBill,
                                                    waterBill: i.waterBill,
                                                    serviceCharge:
                                                        i.serviceCharge,
                                                    totalAmount: i.totalAmount,
                                                    dateOfIn: i.dateOfIn),
                                                DBHelper.insertRentData(RentInfo(
                                                        floorID:
                                                            tenentInfo!.floorID,
                                                        floorName: tenentInfo!
                                                            .floorName,
                                                        flatID:
                                                            tenentInfo!.flatID,
                                                        flatName: tenentInfo!
                                                            .flatName,
                                                        tenentID:
                                                            tenentInfo?.id ?? 0,
                                                        tenentName: tenentInfo!
                                                            .tenentName,
                                                        totalAmount: tenentInfo!
                                                            .totalAmount,
                                                        month: date.toString(),
                                                        isPaid: isPaid))
                                                    .then((_) => {
                                                          setState(() {
                                                            _fetchData();
                                                          }),
                                                        }),
                                              },
                                          }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 100,
                                          height: 45,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              bottomLeft: Radius.circular(25),
                                              topRight: Radius.circular(1),
                                              bottomRight: Radius.circular(1),
                                            ),
                                            color: Color.fromARGB(
                                                255, 138, 138, 138),
                                          ),
                                          child: Container(
                                            width: 110,
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                bottomLeft: Radius.circular(25),
                                                topRight: Radius.circular(1),
                                                bottomRight:
                                                    Radius.circular(65),
                                              ),
                                              color: Color.fromARGB(
                                                  255, 101, 99, 99),
                                            ),
                                            child: const Stack(
                                              children: [
                                                Positioned(
                                                  bottom: -1,
                                                  right: -1,
                                                  child: Icon(
                                                    Icons.save,
                                                    size: 17,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 35,
                                                  top: 15,
                                                  child: Text(
                                                    'Save',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 45,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            bottomLeft: Radius.circular(25),
                                            topRight: Radius.circular(1),
                                            bottomRight: Radius.circular(1),
                                          ),
                                          color: Color.fromARGB(
                                              255, 138, 138, 138),
                                        ),
                                        child: Container(
                                          width: 110,
                                          height: 50,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              bottomLeft: Radius.circular(25),
                                              topRight: Radius.circular(1),
                                              bottomRight: Radius.circular(65),
                                            ),
                                            color: Color.fromARGB(
                                                255, 101, 99, 99),
                                          ),
                                          child: const Stack(
                                            children: [
                                              Positioned(
                                                bottom: -1,
                                                right: -1,
                                                child: Icon(
                                                  Icons.cancel,
                                                  size: 17,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Positioned(
                                                left: 25,
                                                top: 15,
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                    height: 400,
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
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('ID: ${rent.id}'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                'Tenent Name: ${rent.tenentName}'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                'Floor Name: ${rent.floorName}'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                'Flat Name: ${rent.flatName}'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                'Total Amount: ${rent.totalAmount.toString()}'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                'Month: ${rent.month.toString()}'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(rent.isPaid == 0
                                                ? "Status: Unpaid"
                                                : "Status: Paid"),
                                          ),
                                        ],
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: rent.isPaid == 1
                                          ? Color.fromARGB(255, 8, 240, 8)
                                          : Color.fromARGB(255, 246, 59, 59),
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
                                                totalAmount: rent.totalAmount,
                                                isPaid: isPaid);
                                            await DBHelper.updateRent(
                                                updatedRent);

                                            // ignore: use_build_context_synchronously

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
                                              builder: (BuildContext context) {
                                                return SingleChildScrollView(
                                                  child: Container(
                                                    height: 400,
                                                    color: const Color.fromARGB(
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
                                                                    .all(20.0),
                                                            child: const Text(
                                                                'Update Your Information'),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(14.0),
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
                                                                          fontSize:
                                                                              16,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              78,
                                                                              78,
                                                                              78),
                                                                          fontStyle:
                                                                              FontStyle.normal,
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
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          controller:
                                                                              _totalAmountController,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(
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
                                                                    .all(8.0),
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
                                                                        tenentName: rent
                                                                            .tenentName,
                                                                        tenentID: rent
                                                                            .tenentID,
                                                                        floorID:
                                                                            rent
                                                                                .floorID,
                                                                        floorName:
                                                                            rent
                                                                                .floorName,
                                                                        flatID: rent
                                                                            .flatID,
                                                                        flatName:
                                                                            rent
                                                                                .flatName,
                                                                        month: rent
                                                                            .month,
                                                                        totalAmount:
                                                                            double.parse(_totalAmountController
                                                                                .text),
                                                                        isPaid:
                                                                            rent.isPaid);
                                                                    await DBHelper
                                                                        .updateRent(
                                                                            updatedRent);

                                                                    // ignore: use_build_context_synchronously

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
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
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
                                            setState(() {
                                              _fetchData();
                                            });
                                          },
                                          icon: Icon(Icons.delete)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return const Text('No rents available.');
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
