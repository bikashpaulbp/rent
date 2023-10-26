import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/models/floor_model.dart';
import 'package:rent_management/services/flat_service.dart';
import 'package:rent_management/services/floor_service.dart';

import 'package:provider/provider.dart';

import '../insert_data/flat.dart';
import '../shared_data/flat_data.dart';

class FlatPage extends StatefulWidget {
  const FlatPage({Key? key}) : super(key: key);

  @override
  State<FlatPage> createState() => _FlatPageState();
}

class _FlatPageState extends State<FlatPage> {
  FlatApiService flatApiService = FlatApiService();
  FloorApiService floorApiService = FloorApiService();
  List<FloorModel> floorList = [];
  String? floorName;
  late Stream<List<FlatModel>> flatStream = const Stream.empty();

  final _newFlatNameController = TextEditingController();
  final _newNoOfMasterbedRoomController = TextEditingController();
  final _newNoOfBedroomController = TextEditingController();
  final _newFlatSideController = TextEditingController();

  final _newNoOfWashroomController = TextEditingController();
  final _newFlatSizeController = TextEditingController();

  @override
  void initState() {
     _fetchFlatData();
    super.initState();
   
  }

  void refresh() {
    _fetchFlatData();
  }

  Future<void> _fetchFlatData() async {
    flatStream = flatApiService.getAllFlats().asStream();
    List<FlatModel> flatList = await flatApiService.getAllFlats();
    floorList = await floorApiService.getAllFloors();
    setState(() {
      Provider.of<FlatData>(context, listen: false).updateFlatList(flatList);
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
        backgroundColor: const Color.fromARGB(255, 66, 129, 247),
        child: IconButton(
          onPressed: () {
            Get.to(FlatDataPage(
              refresh: refresh,
            ));
          },
          icon: const Icon(Icons.add),
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.blue.shade300,
      //   title: const Center(child: Text('Flat List')),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Column(
                  children: [
                    const Text(
                      'Flats',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 78, 78, 78),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: SizedBox(
                        width: 400,
                        height: MediaQuery.of(context).size.height * 0.72,
                        child: StreamBuilder<List<FlatModel>>(
                          stream: flatStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<FlatModel>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data!.isNotEmpty) {
                              List<FlatModel> flatList = snapshot.data!;

                              return ListView.builder(
                                itemCount: flatList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  FlatModel flat = flatList[index];
                                  if (floorList.isNotEmpty) {
                                    floorName = floorList
                                        .firstWhere((e) => e.id == flat.floorId)
                                        .name;
                                  } else {
                                    floorName = "floor not found";
                                  }

                                  return ListTile(
                                    title: Card(
                                      elevation: 10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Floor Name: $floorName',
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Flat Name: ${flat.name.toString()}',
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'No. Of Master Bedroom: ${flat.masterbedRoom.toString()}',
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'No. Of Bedroom: ${flat.bedroom.toString()}',
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'No. Of Washroom: ${flat.washroom.toString()}',
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Flat Side: ${flat.flatSide!.isEmpty ? "" : flat.flatSide.toString()}',
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Flat Size(Sqf): ${flat.flatSize == null ? 0.0 : flat.flatSize.toString()}',
                                                    style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 255, 221, 0),
                                              child: IconButton(
                                                  iconSize: 15,
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    _newFlatNameController
                                                            .text =
                                                        flat.name.toString();
                                                    _newNoOfMasterbedRoomController
                                                            .text =
                                                        flat.masterbedRoom
                                                            .toString();
                                                    _newNoOfBedroomController
                                                            .text =
                                                        flat.bedroom.toString();
                                                    _newNoOfWashroomController
                                                            .text =
                                                        flat.washroom
                                                            .toString();

                                                    _newFlatSideController
                                                            .text =
                                                        flat.flatSide
                                                            .toString();

                                                    _newFlatSizeController
                                                            .text =
                                                        flat.flatSize
                                                            .toString();
                                                    showModalBottomSheet<void>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return SingleChildScrollView(
                                                          child: Container(
                                                            height: 700,
                                                            color: const Color
                                                                .fromARGB(255,
                                                                255, 255, 255),
                                                            child: Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <Widget>[
                                                                  const Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            20.0),
                                                                    child: Text(
                                                                        'Update Your Information'),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            14.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            const SizedBox(
                                                                              child: Text(
                                                                                'Flat Name',
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: Color.fromARGB(255, 78, 78, 78),
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
                                                                                  controller: _newFlatNameController,
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
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            const SizedBox(
                                                                              child: Text(
                                                                                'No. Of Master \nBedroom',
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: Color.fromARGB(255, 78, 78, 78),
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
                                                                                  keyboardType: TextInputType.number,
                                                                                  controller: _newNoOfMasterbedRoomController,
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
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            const SizedBox(
                                                                              child: Text(
                                                                                'No. Of \nBedroom',
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: Color.fromARGB(255, 78, 78, 78),
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
                                                                                  keyboardType: TextInputType.number,
                                                                                  controller: _newNoOfBedroomController,
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
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            const SizedBox(
                                                                              child: Text(
                                                                                'No. Of \nWashroom',
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: Color.fromARGB(255, 78, 78, 78),
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
                                                                                  keyboardType: TextInputType.number,
                                                                                  controller: _newNoOfWashroomController,
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
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            const SizedBox(
                                                                              child: Text(
                                                                                'Flat Side',
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: Color.fromARGB(255, 78, 78, 78),
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
                                                                                  controller: _newFlatSideController,
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
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            const SizedBox(
                                                                              child: Text(
                                                                                'Flat Size',
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: Color.fromARGB(255, 78, 78, 78),
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
                                                                                  keyboardType: TextInputType.number,
                                                                                  controller: _newFlatSizeController,
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
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        ElevatedButton(
                                                                          child:
                                                                              const Text('update'),
                                                                          onPressed:
                                                                              () async {
                                                                            int?
                                                                                flatId =
                                                                                flat.id;
                                                                            String
                                                                                updatedflatName =
                                                                                _newFlatNameController.text;
                                                                            int updatedNoOfMasterBedroom =
                                                                                int.parse(_newNoOfMasterbedRoomController.text);

                                                                            int updatedNoOfBedroom =
                                                                                int.parse(_newNoOfBedroomController.text);

                                                                            int updatedNoOfWashroom =
                                                                                int.parse(_newNoOfWashroomController.text);

                                                                            String
                                                                                updatedFlatSide =
                                                                                _newFlatSideController.text;

                                                                            int updatedFlatSize =
                                                                                int.parse(_newFlatSizeController.text);

                                                                            FlatModel updatedFlat = FlatModel(
                                                                                id: flat.id,
                                                                                name: updatedflatName,
                                                                                masterbedRoom: updatedNoOfMasterBedroom,
                                                                                bedroom: updatedNoOfBedroom,
                                                                                washroom: updatedNoOfWashroom,
                                                                                flatSide: updatedFlatSide,
                                                                                flatSize: updatedFlatSize,
                                                                                floorId: flat.floorId);
                                                                            await flatApiService.updateFlat(
                                                                                flat: updatedFlat,
                                                                                id: flatId!);
                                                                            Get.snackbar("",
                                                                                "",
                                                                                messageText: const Center(
                                                                                    child: Text(
                                                                                  "updated successfully  \n",
                                                                                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                                                                                )),
                                                                                snackPosition: SnackPosition.BOTTOM,
                                                                                duration: const Duration(seconds: 2));

                                                                            setState(() {
                                                                              _fetchFlatData();

                                                                              Navigator.pop(context);
                                                                            });
                                                                          },
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              20,
                                                                        ),
                                                                        ElevatedButton(
                                                                          child:
                                                                              const Text('Cancel'),
                                                                          onPressed: () =>
                                                                              Navigator.pop(context),
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
                                                  icon: const Icon(Icons.edit)),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 1,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      222, 255, 0, 0),
                                              child: IconButton(
                                                  iconSize: 15,
                                                  color: Colors.white,
                                                  onPressed: () async {
                                                    int? id = flat.id;
                                                    await flatApiService
                                                        .deleteFlat(id!);
                                                    Get.snackbar("", "",
                                                        messageText:
                                                            const Center(
                                                                child: Text(
                                                          "deleted successfully  \n",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(255,
                                                                      0, 0, 0),
                                                              fontSize: 20),
                                                        )),
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        duration:
                                                            const Duration(
                                                                seconds: 1));
                                                    setState(() {
                                                      _fetchFlatData();
                                                    });
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                  child: Text('No flats available.'));
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
