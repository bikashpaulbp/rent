import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../classes/flat_info.dart';
import '../db_helper.dart';
import 'package:provider/provider.dart';

import '../insert_data/flat.dart';
import '../shared_data/flat_data.dart';

class FlatPage extends StatefulWidget {
  const FlatPage({Key? key}) : super(key: key);

  @override
  State<FlatPage> createState() => _FlatPageState();
}

class _FlatPageState extends State<FlatPage> {
  late Stream<List<FlatInfo>> flatStream = const Stream.empty();

  final _newFlatNameController = TextEditingController();
  final _newNoOfMasterbedRoomController = TextEditingController();
  final _newNoOfBedroomController = TextEditingController();
  final _newFlatSideController = TextEditingController();
  // final _newRentAmountController = TextEditingController();
  final _newNoOfWashroomController = TextEditingController();
  final _newFlatSizeController = TextEditingController();

  @override
  void initState() {
    _fetchFlatData();

    super.initState();
  }

  Future<void> _fetchFlatData() async {
    flatStream = DBHelper.readFlatData().asStream();
    List<FlatInfo> flatList = await DBHelper.readFlatData();
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
            Get.offAll(const FlatDataPage());
          },
          icon: const Icon(Icons.add),
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        title: const Center(child: Text('Flat List')),
      ),
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
                        child: StreamBuilder<List<FlatInfo>>(
                          stream: flatStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<FlatInfo>> snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data!.isNotEmpty) {
                              List<FlatInfo> flatList = snapshot.data!;

                              return ListView.builder(
                                itemCount: flatList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  FlatInfo flat = flatList[index];

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
                                                // Padding(
                                                //   padding:
                                                //       const EdgeInsets.all(5.0),
                                                //   child: Text(
                                                //     'ID: ${flat.id}',
                                                //     style: TextStyle(
                                                //       color: const Color.fromARGB(
                                                //           255, 0, 0, 0),
                                                //       fontSize: 16,
                                                //       fontWeight: FontWeight.w500,
                                                //     ),
                                                //   ),
                                                // ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Floor Name: ${flat.floorName}',
                                                    style: const TextStyle(
                                                      color:
                                                          Color.fromARGB(
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
                                                    'Flat Name: ${flat.flatName.toString()}',
                                                    style: const TextStyle(
                                                      color:
                                                          Color.fromARGB(
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
                                                    'No. Of Master Bedroom: ${flat.noOfMasterbedRoom.toString()}',
                                                    style: const TextStyle(
                                                      color:
                                                          Color.fromARGB(
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
                                                    'No. Of Bedroom: ${flat.noOfBedroom.toString()}',
                                                    style: const TextStyle(
                                                      color:
                                                          Color.fromARGB(
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
                                                    'No. Of Washroom: ${flat.noOfWashroom.toString()}',
                                                    style: const TextStyle(
                                                      color:
                                                          Color.fromARGB(
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
                                                    'Flat Side: ${flat.flatSide.toString()}',
                                                    style: const TextStyle(
                                                      color:
                                                          Color.fromARGB(
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
                                                    'Flat Size(Sqf): ${flat.flatSize == 0 ? "" : flat.flatSize.toString()}',
                                                    style: const TextStyle(
                                                      color:
                                                          Color.fromARGB(
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
                                              backgroundColor: const Color.fromARGB(
                                                  255, 255, 221, 0),
                                              child: IconButton(
                                                  iconSize: 15,
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    _newFlatNameController
                                                        .text = flat.flatName;
                                                    _newNoOfMasterbedRoomController
                                                            .text =
                                                        flat.noOfMasterbedRoom
                                                            .toString();
                                                    _newNoOfBedroomController
                                                            .text =
                                                        flat.noOfBedroom
                                                            .toString();
                                                    _newFlatSideController
                                                        .text = flat.flatSide;
                                                    // _newRentAmountController.text =
                                                    //     flat.rentAmount.toString();
                                                    _newNoOfWashroomController
                                                            .text =
                                                        flat.noOfWashroom
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
                                                                // mainAxisSize:
                                                                //     MainAxisSize.min,
                                                                children: <Widget>[
                                                                  const Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(
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
                                                                            String
                                                                                updatedFlatSide =
                                                                                _newFlatSideController.text;
                                                                            // double
                                                                            //     updatedRentAmount =
                                                                            //     double.parse(
                                                                            //         _newRentAmountController.text);
                                                                            int updatedNoOfWashroom =
                                                                                int.parse(_newNoOfWashroomController.text);
                                                                            int updatedFlatSize =
                                                                                int.parse(_newFlatSizeController.text);

                                                                            FlatInfo updatedFlat = FlatInfo(
                                                                                id: flatId,
                                                                                floorId: flat.floorId,
                                                                                floorName: flat.floorName,
                                                                                flatName: updatedflatName,
                                                                                noOfMasterbedRoom: updatedNoOfMasterBedroom,
                                                                                noOfBedroom: updatedNoOfBedroom,
                                                                                flatSide: updatedFlatSide,
                                                                                // rentAmount:
                                                                                //     updatedRentAmount,
                                                                                noOfWashroom: updatedNoOfWashroom,
                                                                                flatSize: updatedFlatSize);
                                                                            await DBHelper.updateFlat(updatedFlat);
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
                                              backgroundColor: const Color.fromARGB(
                                                  222, 255, 0, 0),
                                              child: IconButton(
                                                  iconSize: 15,
                                                  color: Colors.white,
                                                  onPressed: () async {
                                                    int? id = flat.id;
                                                    await DBHelper.deleteFlat(
                                                        id);
                                                    Get.snackbar("", "",
                                                        messageText: const Center(
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
                                                        duration: const Duration(
                                                            seconds: 1));
                                                    setState(() {
                                                      _fetchFlatData();
                                                    });
                                                  },
                                                  icon: const Icon(Icons.delete)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Center(child: Text('No flats available.'));
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
