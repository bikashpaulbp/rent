import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/models/building_model.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/models/floor_model.dart';
import 'package:rent_management/models/tenant_model.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/deposit_page.dart';
import 'package:rent_management/screens/flat_page.dart';
import 'package:rent_management/screens/floor_page.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/screens/monthly_rent_page.dart';
import 'package:rent_management/screens/tenent_page.dart';
import 'package:rent_management/services/building_service.dart';
import 'package:rent_management/services/rent_service.dart';
import 'package:rent_management/shared_data/building_provider.dart';
import 'package:rent_management/shared_data/local_info_provider.dart';
import 'package:rent_management/shared_data/rent_data.dart';

import '../shared_data/flat_data.dart';
import '../shared_data/floor_data.dart';
import '../shared_data/tenent_data.dart';

class CountPage extends StatefulWidget {
  CountPage({
    super.key,
  });

  @override
  State<CountPage> createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  RentApiService rentApiService = RentApiService();
  BuildingApiService buildingApiService = BuildingApiService();
  List<BuildingModel> buildingList = [];
  AuthStateManager authStateManager = AuthStateManager();
  UserModel? loggedInUser = UserModel();

  int? selectedBuildingId;
  int? buildingId;
  String? buildingName;

  @override
  void initState() {
    // fetchDueRentData();
    fetchBuilding();
    fetchLoggedInUser();
    getBuildingId();

    super.initState();
  }

  Future<UserModel?> fetchLoggedInUser() async {
    return loggedInUser = await authStateManager.getLoggedInUser();
  }

  Future<void> getBuildingId() async {
    buildingId = await authStateManager.getBuildingId();
  }

  Future<List<BuildingModel>> fetchBuilding() async {
    try {
      return buildingList = await buildingApiService.getAllBuildings();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 94, 91, 255),
      //   title: const Center(child: Text('Dashboard')),
      // ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Consumer<BuildingProvider>(
                        builder: (context, building, child) {
                          building.getBuildingList();
                          fetchLoggedInUser();
                          List<BuildingModel> allBuildingList =
                              building.buildingList;

                          buildingList = allBuildingList
                              .where((e) => e.userId == loggedInUser!.id)
                              .toList();
                          return DropdownButtonFormField<int>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              suffix: const Text(
                                '*',
                                style: TextStyle(color: Colors.red),
                              ),
                              labelText: 'Choose Building',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            disabledHint: const Text('Add Building First'),
                            value: selectedBuildingId,
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedBuildingId = newValue!;
                                buildingName = buildingList
                                    .firstWhere(
                                        (e) => e.id == selectedBuildingId)
                                    .name;

                                Provider.of<LocalData>(context, listen: false)
                                    .updateBuildingName(
                                        buildingName!, selectedBuildingId!);
                              });
                              getBuildingId();
                            },
                            items: buildingList.map<DropdownMenuItem<int>>(
                                (BuildingModel building) {
                              return DropdownMenuItem<int>(
                                  value: building.id,
                                  child: Text(building.name!));
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ),
                  Consumer<LocalData>(
                    builder: (context, localData, child) {
                      localData.getBuildingName();
                      return localData.buildingName != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.apartment_rounded,
                                      size: 50, color: Colors.amber),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Center(
                                    child: Text(
                                      "${localData.buildingName}",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            Color.fromARGB(255, 238, 155, 30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Select Building",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromARGB(255, 228, 71, 50),
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 198, 198, 198)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(FloorPage());
                              },
                              child: Card(
                                shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 10,
                                child: Container(
                                  child: Center(
                                    child: Consumer<FloorData>(
                                        builder: (context, floorData, _) {
                                      getBuildingId();
                                      floorData.getFloorList();
                                      List<FloorModel> floorList = floorData
                                          .floorList
                                          .where(
                                              (e) => e.buildingId == buildingId)
                                          .toList();
                                      return Text(
                                        "Total Floor \n${floorList.length}",
                                        style: const TextStyle(
                                            fontSize: 24, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      );
                                    }),
                                  ),
                                  height: 150,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 19, 255, 212),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(FlatPage());
                              },
                              child: Card(
                                shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 10,
                                child: Container(
                                  child: Center(
                                    child: Consumer<FlatData>(
                                        builder: (context, flatData, _) {
                                      getBuildingId();
                                      flatData.getFlatList();
                                      List<FlatModel> flatList = flatData
                                          .flatList
                                          .where((element) =>
                                              element.buildingId == buildingId)
                                          .toList();
                                      return Text(
                                        "Total Flat \n${flatList.length}",
                                        style: const TextStyle(
                                            fontSize: 24, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      );
                                    }),
                                  ),
                                  height: 150,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 81, 245, 86),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
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
                            child: InkWell(
                              onTap: () {
                                Get.to(TenentPage());
                              },
                              child: Card(
                                shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 10,
                                child: Container(
                                  child: Center(
                                    child: Consumer<TenantData>(
                                        builder: (context, tenantData, _) {
                                      tenantData.getTenantList();
                                      getBuildingId();
                                      List<TenantModel> tenantList = tenantData
                                          .tenantList
                                          .where((element) =>
                                              element.buildingId == buildingId)
                                          .toList();
                                      return Text(
                                        "Total Tenant \n${tenantList.length}",
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
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                // Get.to(MonthlyRent());
                              },
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
                                      color: const Color.fromARGB(
                                          255, 255, 202, 56),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
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
                                    // Get.to(DepositPage());
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
      ),
    );
  }
}
