import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/classes/rent_info.dart';

import 'package:rent_management/classes/tenent_info.dart';
import 'package:rent_management/db_helper.dart';
import 'package:rent_management/insert_data/rent.dart';
import 'package:rent_management/insert_data/rent_manual.dart';
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
          floatingActionButton: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 66, 129, 247),
              child: IconButton(
                onPressed: () {
                  Get.offAll(const RentDataPage());
                },
                icon: const Icon(Icons.add),
                color: const Color.fromARGB(255, 255, 255, 255),
              )),
          appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 226, 155, 2),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Center(child: Text('Monthly Rent List')),
                  SizedBox(
                    height: 30,
                    width: 120,
                    child: ElevatedButton.icon(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.amber)),
                        onPressed: () {
                          Get.offAll(const RentManual());
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("manually")),
                  )
                ],
              ),
              bottom: const TabBar(tabs: [
                Tab(text: "All Rent"),
                Tab(
                  text: "Current Month Rent",
                )
              ])),
          body: const TabBarView(children: [AllRent(), CurrentMonthRent()]),
        ));
  }
}
