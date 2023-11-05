import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/insert_data/floor.dart';
import 'package:rent_management/models/building_model.dart';
import 'package:rent_management/models/floor_model.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/services/building_service.dart';
import 'package:rent_management/services/floor_service.dart';

import 'package:get/get.dart';
import 'package:rent_management/shared_data/floor_data.dart';

class FloorPage extends StatefulWidget {
  const FloorPage({Key? key}) : super(key: key);

  @override
  State<FloorPage> createState() => _FloorPageState();
}

class _FloorPageState extends State<FloorPage> {
  FloorApiService floorApiService = FloorApiService();
  BuildingApiService buildingApiService = BuildingApiService();
  late Stream<List<FloorModel>> floorStream = const Stream.empty();
  final _floorNameController = TextEditingController();
  List<BuildingModel> buildingList = [];

  AuthStateManager authStateManager = AuthStateManager();
  UserModel? loggedInUser = UserModel();
  int? buildingId;
  

  @override
  void initState() {
    setState(() {
      _fetchFloorData();
    });
    fetchBuilding();
    getLocalInfo();
    super.initState();
  }

  Future<void> getLocalInfo() async {
    buildingId = await authStateManager.getBuildingId();
    loggedInUser = await authStateManager.getLoggedInUser();
  }

  Future<List<BuildingModel>> fetchBuilding() async {
    return buildingList = await buildingApiService.getAllBuildings();
  }

  Future<void> _fetchFloorData() async {
    floorStream = floorApiService.getAllFloors().asStream();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 49, 49, 49)),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
            child: Text(
          "Floors",
          style: TextStyle(color: Colors.black),
        )),
      ),
      floatingActionButton: CircleAvatar(
        backgroundColor: const Color.fromARGB(255, 66, 129, 247),
        child: IconButton(
          onPressed: () {
            Get.to(FloorDataPage());
          },
          icon: const Icon(Icons.add),
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 229, 115, 115),
      //   title: const Center(child: Text('Floor List')),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    // const Text(
                    //   'Floors',
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     color: Color.fromARGB(255, 78, 78, 78),
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        width: 500,
                        height: MediaQuery.of(context).size.height * 0.745,
                        child: Consumer<FloorData>(
                          builder: (context, floor, child) {
                            floor.getFloorList();
                            getLocalInfo();
                            List<FloorModel> allFloorList = floor.floorList;

                            List<FloorModel> floorList = allFloorList
                                .where((e) => e.buildingId == buildingId)
                                .toList();

                            return floorList.isNotEmpty
                                ? ListView.builder(
                                    itemCount: floorList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      FloorModel floor = floorList[index];

                                      return ListTile(
                                        title: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 60,
                                                  child: Card(
                                                    elevation: 10,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          RichText(
                                                            text:
                                                                const TextSpan(
                                                              children: [],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 15),
                                                          SizedBox(
                                                            width: 220,
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  const TextSpan(
                                                                    text:
                                                                        'Floor Name: ',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color
                                                                          .fromARGB(
                                                                              255,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: floor
                                                                        .name,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black,
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
                                                          CircleAvatar(
                                                            radius: 15,
                                                            backgroundColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    241,
                                                                    221,
                                                                    0),
                                                            child: IconButton(
                                                              iconSize: 15,
                                                              color:
                                                                  Colors.white,
                                                              onPressed: () {
                                                                _floorNameController
                                                                        .text =
                                                                    floor.name!;
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
                                                                            450,
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
                                                                                padding: EdgeInsets.all(20.0),
                                                                                child: Text(
                                                                                  'Update Your Information',
                                                                                  style: TextStyle(
                                                                                    fontSize: 18,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(14.0),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      child: Text(
                                                                                        'Floor',
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
                                                                                          controller: _floorNameController,
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
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                                  children: [
                                                                                    ElevatedButton(
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        backgroundColor: Colors.blue,
                                                                                      ),
                                                                                      child: const Text('Update', style: TextStyle(color: Colors.white)),
                                                                                      onPressed: () async {
                                                                                        getLocalInfo();
                                                                                        int? floorId = floor.id;
                                                                                        String updatedFloorName = _floorNameController.text;
                                                                                        FloorModel updatedFloor = FloorModel(id: floorId, name: updatedFloorName, buildingId: buildingId, isActive: true, userId: loggedInUser!.id);

                                                                                        await floorApiService.updateFloor(floor: updatedFloor, id: floorId!);
                                                                                        // ignore: use_build_context_synchronously
                                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("updated successfully")));

                                                                                        setState(() {
                                                                                          _fetchFloorData();
                                                                                          Navigator.pop(context);
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
                                                          const SizedBox(
                                                              width: 10),
                                                          CircleAvatar(
                                                            radius: 15,
                                                            backgroundColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    215,
                                                                    224,
                                                                    2,
                                                                    2),
                                                            child: IconButton(
                                                              iconSize: 15,
                                                              color:
                                                                  Colors.white,
                                                              onPressed:
                                                                  () async {
                                                                int? id =
                                                                    floor.id;
                                                                await floorApiService
                                                                    .deleteFloor(
                                                                        id!);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(SnackBar(
                                                                        content:
                                                                            Text("deleted successfully")));
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
                                  )
                                : Center(child: Text("no floor found"));
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
