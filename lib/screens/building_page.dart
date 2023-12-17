import 'package:flutter/material.dart';
import 'package:rent_management/insert_data/building.dart';
import 'package:rent_management/models/building_model.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/services/building_service.dart';

import 'package:get/get.dart';

class BuildingPage extends StatefulWidget {
  BuildingPage({Key? key}) : super(key: key);

  @override
  State<BuildingPage> createState() => _BuildingPageState();
}

class _BuildingPageState extends State<BuildingPage> {
  BuildingApiService buildingApiService = BuildingApiService();
  late Stream<List<BuildingModel>> buildingStream = const Stream.empty();
  final TextEditingController _buildingNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  AuthStateManager authStateManager = AuthStateManager();
  List<BuildingModel> buildingList = [];
  UserModel? loggedInUser = UserModel();
  bool loading = false;

  @override
  void initState() {
    setState(() {
      fetchLoggedInUser();
      _fetchBuildingData();
    });
    super.initState();
  }

  void refresh() {
    _fetchBuildingData();
  }

  Future<void> _fetchBuildingData() async {
    buildingStream = buildingApiService.getAllBuildings().asStream();
    buildingList = await buildingApiService.getAllBuildings();
  }

  Future<UserModel?> fetchLoggedInUser() async {
    return loggedInUser = await authStateManager.getLoggedInUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 49, 49, 49)),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.apartment),
            SizedBox(
              width: 30,
            ),
            Text(
              "Buildings",
              style: TextStyle(color: Colors.black),
            ),
          ],
        )),
      ),
      floatingActionButton: CircleAvatar(
        backgroundColor: const Color.fromARGB(255, 66, 129, 247),
        child: IconButton(
          onPressed: () {
            Get.to(BuildingDataPage(
              refresh: refresh,
            ));
          },
          icon: const Icon(Icons.add),
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        width: 500,
                        height: MediaQuery.of(context).size.height * 0.745,
                        child: StreamBuilder<List<BuildingModel>>(
                          stream: buildingStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<BuildingModel>> snapshot) {
                            fetchLoggedInUser();
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data!.isNotEmpty) {
                              List<BuildingModel> allBuildingList =
                                  snapshot.data!;

                              buildingList = allBuildingList
                                  .where((e) => e.userId == loggedInUser!.id)
                                  .toList();

                              return ListView.builder(
                                itemCount: buildingList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  BuildingModel building = buildingList[index];

                                  return ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 100,
                                              child: Card(
                                                color: index % 2 == 0
                                                    ? const Color.fromARGB(
                                                        255, 255, 255, 255)
                                                    : const Color.fromARGB(
                                                        255, 175, 175, 175),
                                                elevation: 10,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      RichText(
                                                        text: const TextSpan(
                                                          children: [],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 15),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: 220,
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Name: ',
                                                                    style:
                                                                        TextStyle(
                                                                      color: index % 2 ==
                                                                              0
                                                                          ? const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              61,
                                                                              61,
                                                                              61)
                                                                          : const Color.fromARGB(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: building
                                                                        .name,
                                                                    style:
                                                                        TextStyle(
                                                                      color: index % 2 ==
                                                                              0
                                                                          ? const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              61,
                                                                              61,
                                                                              61)
                                                                          : const Color.fromARGB(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          SizedBox(
                                                            width: 220,
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Address: ',
                                                                    style:
                                                                        TextStyle(
                                                                      color: index % 2 ==
                                                                              0
                                                                          ? const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              61,
                                                                              61,
                                                                              61)
                                                                          : const Color.fromARGB(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: building
                                                                        .address,
                                                                    style:
                                                                        TextStyle(
                                                                      color: index % 2 ==
                                                                              0
                                                                          ? const Color.fromARGB(
                                                                              255,
                                                                              61,
                                                                              61,
                                                                              61)
                                                                          : const Color.fromARGB(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      CircleAvatar(
                                                        radius: 15,
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                241, 221, 0),
                                                        child: IconButton(
                                                          iconSize: 15,
                                                          color: Colors.white,
                                                          onPressed: () {
                                                            _buildingNameController
                                                                    .text =
                                                                building.name!;
                                                            _addressController
                                                                    .text =
                                                                building
                                                                    .address!;
                                                            showModalBottomSheet<
                                                                void>(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return SingleChildScrollView(
                                                                  child:
                                                                      Container(
                                                                    height: 450,
                                                                    color: Colors
                                                                        .white,
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
                                                                                Text(
                                                                              'Update Building Information',
                                                                              style: TextStyle(
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(14.0),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      child: Text(
                                                                                        'Name',
                                                                                        style: TextStyle(
                                                                                          fontSize: 16,
                                                                                          color: Colors.grey[700],
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
                                                                                          keyboardType: TextInputType.name,
                                                                                          controller: _buildingNameController,
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
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      child: Text(
                                                                                        'Address',
                                                                                        style: TextStyle(
                                                                                          fontSize: 16,
                                                                                          color: Colors.grey[700],
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
                                                                                          keyboardType: TextInputType.name,
                                                                                          controller: _addressController,
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
                                                                                const SizedBox(
                                                                                  height: 20,
                                                                                ),
                                                                                Center(
                                                                                  child: SizedBox(height: 50, width: 50, child: loading == true ? const Center(child: CircularProgressIndicator()) : null),
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
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: Colors.blue,
                                                                                  ),
                                                                                  child: const Text('Update', style: TextStyle(color: Colors.white)),
                                                                                  onPressed: () async {
                                                                                    setState(() {
                                                                                      loading = true;
                                                                                    });
                                                                                    int? buildingId = building.id;
                                                                                    String updatedBuildingName = _buildingNameController.text;
                                                                                    String updatedAddress = _addressController.text;
                                                                                    await fetchLoggedInUser();
                                                                                    BuildingModel updatedBuilding = BuildingModel(
                                                                                      id: buildingId,
                                                                                      name: updatedBuildingName,
                                                                                      address: updatedAddress,
                                                                                      isActive: true,
                                                                                      userId: loggedInUser!.id,
                                                                                    );

                                                                                    await buildingApiService.updateBuilding(building: updatedBuilding, id: buildingId!).then((_) {
                                                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("updated successfully")));
                                                                                      setState(() {
                                                                                        loading = false;
                                                                                        _fetchBuildingData();

                                                                                        Navigator.pop(context);
                                                                                      });
                                                                                    });
                                                                                  },
                                                                                ),
                                                                                const SizedBox(width: 20),
                                                                                ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: Colors.red,
                                                                                  ),
                                                                                  child: const Text('Cancel', style: TextStyle(color: Colors.white)),
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
                                                              Icons.edit),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      CircleAvatar(
                                                        radius: 15,
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(
                                                                215, 224, 2, 2),
                                                        child: IconButton(
                                                          iconSize: 15,
                                                          color: Colors.white,
                                                          onPressed: () async {
                                                            int? id =
                                                                building.id;
                                                            await buildingApiService
                                                                .deleteBuilding(
                                                                    id!)
                                                                .then((_) {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                          content:
                                                                              Text("deleted successfully")));
                                                              setState(() {
                                                                _fetchBuildingData();
                                                              });
                                                            });
                                                          },
                                                          icon: const Icon(
                                                              Icons.delete),
                                                        ),
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
                                },
                              );
                            } else {
                              return const Center(
                                child: Text('no buildings available.'),
                              );
                            }
                          },
                        ),
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
