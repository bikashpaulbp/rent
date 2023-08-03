import 'dart:ffi';

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
              backgroundColor: Color.fromARGB(255, 226, 155, 2),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(child: Text('Monthly Rent List')),
                  SizedBox(
                    height: 30,
                    width: 120,
                    child: ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.amber)),
                        onPressed: () {
                          Get.offAll(RentDataPage());
                        },
                        icon: Icon(Icons.add),
                        label: Text("add rent")),
                  )
                ],
              ),
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
