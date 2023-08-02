import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/classes/rent_info.dart';

import 'package:rent_management/classes/tenent_info.dart';
import 'package:rent_management/db_helper.dart';
import 'package:rent_management/insert_data/rent.dart';
import 'package:rent_management/screens/current_date_rent.dart';

import '../shared_data/rent_data.dart';
import 'all_rent.dart';

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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 226, 204, 2),
              title: Center(
                  child: Column(
                children: [
                  Text('Monthly Rent List'),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: InkWell(
                      onTap: () {
                        Get.offAll(RentDataPage());
                      },
                      child: Container(
                        child: Center(
                          child: Text(
                            'ADD MONTHLY RENT',
                            style: TextStyle(
                              color: Color.fromARGB(255, 230, 229, 222),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        width: 150,
                        height: 25,
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
                              color: Color.fromARGB(255, 241, 225, 99)
                                  .withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
              bottom: TabBar(tabs: [
                Tab(text: "All Rent"),
                Tab(
                  text: "Current Month Rent",
                )
              ])),
          body: TabBarView(children: [AllRent(), CurrentMonthRent()]),
        ));
  }
}
