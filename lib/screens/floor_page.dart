import 'package:flutter/material.dart';
import 'package:rent_management/insert_data/floor.dart';
import 'package:rent_management/shared_data/floor_data.dart';
import 'package:get/get.dart';
import '../classes/floor_info.dart';
import '../db_helper.dart';
import 'package:provider/provider.dart';

class FloorPage extends StatefulWidget {
  const FloorPage({Key? key}) : super(key: key);

  @override
  State<FloorPage> createState() => _FloorPageState();
}

class _FloorPageState extends State<FloorPage> {
  late Stream<List<Floor>> floorStream = const Stream.empty();
  final _floorNameController = TextEditingController();

  @override
  void initState() {
    setState(() {
      _fetchFloorData();
    });

    super.initState();
  }

  Future<void> _fetchFloorData() async {
    floorStream = DBHelper.readFloorData().asStream();
    List<Floor> floorList = await DBHelper.readFloorData();
    setState(() {
      Provider.of<FloorData>(context, listen: false).updateFloorList(floorList);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircleAvatar(
        backgroundColor: Color.fromARGB(255, 197, 197, 197),
        child: IconButton(
          onPressed: () {
            Get.offAll(FloorDataPage());
          },
          icon: Icon(Icons.add),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 229, 115, 115),
        title: const Center(child: Text('Floor List')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    'Floors',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      width: 500,
                      height: MediaQuery.of(context).size.height * 0.74,
                      child: StreamBuilder<List<Floor>>(
                        stream: floorStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Floor>> snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data!.isNotEmpty) {
                            List<Floor> floorList = snapshot.data!;
                            Provider.of<FloorData>(context, listen: false)
                                .updateFloorList(floorList);

                            return ListView.builder(
                              itemCount: floorList.length,
                              itemBuilder: (BuildContext context, int index) {
                                Floor floor = floorList[index];

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
                                            height: 60,
                                            child: Card(
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
                                                      text: TextSpan(
                                                        children: [
                                                          // TextSpan(
                                                          //   text: 'ID: ',
                                                          //   style: TextStyle(
                                                          //     color: const Color
                                                          //             .fromARGB(
                                                          //         255, 0, 0, 0),
                                                          //     fontSize: 18,
                                                          //     fontWeight:
                                                          //         FontWeight
                                                          //             .bold,
                                                          //   ),
                                                          // ),
                                                          // TextSpan(
                                                          //   text: '${floor.id}',
                                                          //   style: TextStyle(
                                                          //     color:
                                                          //         Colors.black,
                                                          //     fontSize: 18,
                                                          //     fontWeight:
                                                          //         FontWeight
                                                          //             .bold,
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: 15),
                                                    SizedBox(
                                                      width: 220,
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  'Floor Name: ',
                                                              style: TextStyle(
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    0,
                                                                    0,
                                                                    0),
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  '${floor.floorName}',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
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
                                                          Color.fromARGB(
                                                              255, 241, 221, 0),
                                                      child: IconButton(
                                                        iconSize: 15,
                                                        color: Colors.white,
                                                        onPressed: () {
                                                          _floorNameController
                                                                  .text =
                                                              floor.floorName;
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
                                                                  child: Center(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: <Widget>[
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              20.0),
                                                                          child:
                                                                              Text(
                                                                            'Update Your Information',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              14.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceAround,
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
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Colors.blue,
                                                                                ),
                                                                                child: Text('Update', style: TextStyle(color: Colors.white)),
                                                                                onPressed: () async {
                                                                                  int? floorId = floor.id;
                                                                                  String updatedFloorName = _floorNameController.text;
                                                                                  Floor updatedFloor = Floor(id: floorId, floorName: updatedFloorName);

                                                                                  await DBHelper.updateFloor(updatedFloor);
                                                                                  Get.snackbar("", "",
                                                                                      messageText: Center(
                                                                                          child: Text(
                                                                                        "updated successfully  \n",
                                                                                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                                                                                      )),
                                                                                      snackPosition: SnackPosition.BOTTOM,
                                                                                      duration: Duration(seconds: 2));
                                                                                  setState(() {
                                                                                    _fetchFloorData();
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                              ),
                                                                              SizedBox(width: 20),
                                                                              ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Colors.red,
                                                                                ),
                                                                                child: Text('Cancel', style: TextStyle(color: Colors.white)),
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
                                                        icon: Icon(Icons.edit),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    CircleAvatar(
                                                      radius: 15,
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              215, 224, 2, 2),
                                                      child: IconButton(
                                                        iconSize: 15,
                                                        color: Colors.white,
                                                        onPressed: () async {
                                                          int? id = floor.id;
                                                          await DBHelper
                                                              .deleteFloor(id);
                                                          Get.snackbar("", "",
                                                              messageText:
                                                                  Center(
                                                                      child:
                                                                          Text(
                                                                "deleted successfully  \n",
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    fontSize:
                                                                        20),
                                                              )),
                                                              snackPosition:
                                                                  SnackPosition
                                                                      .BOTTOM,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1));
                                                          setState(() {
                                                            _fetchFloorData();
                                                          });
                                                        },
                                                        icon:
                                                            Icon(Icons.delete),
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
                            return Center(child: Text('no floors available.'));
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
    );
  }
}
