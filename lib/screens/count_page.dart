import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/shared_data/rent_data.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/rent_info.dart';
import '../db_helper.dart';
import '../shared_data/flat_data.dart';
import '../shared_data/floor_data.dart';
import '../shared_data/tenent_data.dart';

class CountPage extends StatefulWidget {
  const CountPage({super.key});

  @override
  State<CountPage> createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  Future<List<RentInfo>> fetchDueRentData() async {
    Database db = await DBHelper.initDB();
    var rent = await db.query('rent', where: 'isPaid = 0');
    return rent.isNotEmpty
        ? rent.map((e) => RentInfo.fromJson(e)).toList()
        : [];
  }

  @override
  void initState() {
    fetchDueRentData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 94, 91, 255),
        title: const Center(child: Text('Dashboard')),
      ),
      body: Container(
          child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 10,
                          child: Container(
                            child: Center(
                              child: Consumer<FloorData>(
                                  builder: (context, floorData, _) {
                                return Text(
                                  "Total Floor \n${floorData.floorListNew()}",
                                  style: const TextStyle(
                                      fontSize: 24, color: Colors.white),
                                  textAlign: TextAlign.center,
                                );
                              }),
                            ),
                            height: 150,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 19, 255, 212),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 10,
                          child: Container(
                            child: Center(
                              child: Consumer<FlatData>(
                                  builder: (context, flatData, _) {
                                return Text(
                                  "Total Flat \n${flatData.flatListNew()}",
                                  style: const TextStyle(
                                      fontSize: 24, color: Colors.white),
                                  textAlign: TextAlign.center,
                                );
                              }),
                            ),
                            height: 150,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 81, 245, 86),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 10,
                          child: Container(
                            child: Center(
                              child: Consumer<TenantData>(
                                  builder: (context, tenantData, _) {
                                return Text(
                                  "Total Tenant \n${tenantData.tenantListNew()}",
                                  style: const TextStyle(
                                      fontSize: 24, color: Colors.white),
                                  textAlign: TextAlign.center,
                                );
                              }),
                            ),
                            height: 150,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 10,
                          child: Container(
                            child: Center(
                              child: Consumer<RentData>(
                                  builder: (context, rentData, _) {
                                int unpaidCount = rentData.rentList
                                    .where((rent) => rent.isPaid == 0)
                                    .length;

                                return Text(
                                  "Total Unpaid \n${unpaidCount}",
                                  style: const TextStyle(
                                      fontSize: 24, color: Colors.white),
                                  textAlign: TextAlign.center,
                                );
                              }),
                            ),
                            height: 150,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 202, 56),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
