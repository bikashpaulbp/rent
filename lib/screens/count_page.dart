import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/screens/deposit_page.dart';
import 'package:rent_management/services/rent_service.dart';
import 'package:rent_management/shared_data/rent_data.dart';

import '../shared_data/flat_data.dart';
import '../shared_data/floor_data.dart';
import '../shared_data/tenent_data.dart';

class CountPage extends StatefulWidget {
  const CountPage({super.key});

  @override
  State<CountPage> createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  RentApiService rentApiService = RentApiService();
  // Future<List<RentModel>> fetchDueRentData() async {
  //   List<RentModel> rentList = await rentApiService.getAllRents();
  //   List<RentModel> isPaidList =
  //       rentList.where((rent) => rent.isPaid == false).toList();

  //   return isPaidList.isNotEmpty
  //       ? isPaidList.map((e) => RentModel.fromJson(e)).toList()
  //       : [];
  // }

  @override
  void initState() {
    // fetchDueRentData();

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
                                  color:
                                      const Color.fromARGB(255, 19, 255, 212),
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
                                      .where((rent) => rent.isPaid == false)
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
                                  color:
                                      const Color.fromARGB(255, 255, 202, 56),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              child: IconButton(
                                iconSize: 40,
                                onPressed: () {
                                  Get.to(DepositPage());
                                },
                                icon: Icon(Icons.history),
                              ),
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: Text(
                                'Deposit History',
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 114, 114, 114),
                                    fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 255, 205, 55),
                              radius: 30,
                              child: IconButton(
                                iconSize: 40,
                                onPressed: () {},
                                icon: Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: Text(
                                'Not Decided',
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 114, 114, 114),
                                    fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 204, 236, 22),
                              radius: 30,
                              child: IconButton(
                                iconSize: 40,
                                onPressed: () {},
                                icon: Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: Text(
                                'Not Decided',
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 114, 114, 114),
                                    fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 22, 200, 236),
                              radius: 30,
                              child: IconButton(
                                iconSize: 40,
                                onPressed: () {},
                                icon: Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: Text(
                                'Not Decided',
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 114, 114, 114),
                                    fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 204, 35, 255),
                              radius: 30,
                              child: IconButton(
                                iconSize: 40,
                                onPressed: () {},
                                icon: Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: Text(
                                'Not Decided',
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 114, 114, 114),
                                    fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 255, 34, 141),
                              radius: 30,
                              child: IconButton(
                                iconSize: 40,
                                onPressed: () {},
                                icon: Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: Text(
                                'Not Decided',
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 114, 114, 114),
                                    fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
