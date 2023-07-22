import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/screens/dashboard_page.dart';
import 'package:rent_management/screens/flat_page.dart';

import '../classes/flat_info.dart';
import '../classes/floor_info.dart';
import '../db_helper.dart';
import '../shared_data/floor_data.dart';

class FlatDataPage extends StatefulWidget {
  const FlatDataPage({super.key});

  @override
  State<FlatDataPage> createState() => _FlatDataPageState();
}

class _FlatDataPageState extends State<FlatDataPage> {
  final TextEditingController _flatNameController = TextEditingController();
  final TextEditingController _noOfMasterbedRoomController =
      TextEditingController();
  final TextEditingController _noOfBedroomController = TextEditingController();
  final TextEditingController _flatSideController = TextEditingController();
  // final TextEditingController _rentAmountController = TextEditingController();
  final TextEditingController _noOfWashroomController = TextEditingController();
  final TextEditingController _flatSizeController = TextEditingController();

  int? selectedFloorId;
  String? selectedFloorName;

  @override
  void dispose() {
    _flatNameController.dispose();
    _noOfMasterbedRoomController.dispose();
    _noOfBedroomController.dispose();
    _flatSideController.dispose();
    // _rentAmountController.dispose();
    _noOfWashroomController.dispose();
    _flatSizeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flat',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: _flatNameController,
                decoration: InputDecoration(
                  labelText: 'Flat Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Consumer<FloorData>(
                builder: (context, floorData, child) {
                  List<Floor> floorList = floorData.floorList;

                  return DropdownButtonFormField<int>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Floor',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    disabledHint: Text('Add Floor First'),
                    value: selectedFloorId,
                    onChanged: (int? value) {
                      setState(() {
                        selectedFloorId = value!;
                        selectedFloorName = floorList
                            .firstWhere((floor) => floor.id == selectedFloorId)
                            .floorName;
                      });
                    },
                    items: floorList.map<DropdownMenuItem<int>>((Floor floor) {
                      return DropdownMenuItem<int>(
                        value: floor.id,
                        child: Text(floor.floorName),
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _noOfMasterbedRoomController,
                decoration: InputDecoration(
                  labelText: 'No. Of Master Bedroom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _noOfBedroomController,
                decoration: InputDecoration(
                  labelText: 'No. Of Bedroom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: _flatSideController,
                decoration: InputDecoration(
                  labelText: 'Flat Side',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _noOfWashroomController,
                decoration: InputDecoration(
                  labelText: 'No. Of Washroom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _flatSizeController,
                decoration: InputDecoration(
                  labelText: 'Flat Size',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_flatNameController.text.isNotEmpty &&
                          _noOfMasterbedRoomController.text.isNotEmpty &&
                          _flatSideController.text.isNotEmpty &&
                          _noOfWashroomController.text.isNotEmpty &&
                          _flatSizeController.text.isNotEmpty &&
                          _noOfBedroomController.text.isNotEmpty &&
                          selectedFloorId != null &&
                          selectedFloorName == "") {
                      } else {
                        await DBHelper.insertFlatData(FlatInfo(
                          floorId: selectedFloorId!,
                          floorName: selectedFloorName!,
                          flatName: _flatNameController.text,
                          flatSide: _flatSideController.text,
                          flatSize: int.parse(_flatSizeController.text),
                          noOfBedroom: int.parse(_noOfBedroomController.text),
                          noOfMasterbedRoom:
                              int.parse(_noOfMasterbedRoomController.text),
                          noOfWashroom: int.parse(_noOfWashroomController.text),
                        ));

                        Get.snackbar("", "",
                            messageText: Center(
                                child: Text(
                              "saved successfully  \n",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 20),
                            )),
                            snackPosition: SnackPosition.BOTTOM,
                            duration: Duration(seconds: 2));

                        setState(() {
                          _flatNameController.clear();
                          _noOfMasterbedRoomController.clear();
                          _flatSideController.clear();
                          _noOfWashroomController.clear();
                          _flatSizeController.clear();
                          _noOfBedroomController.clear();
                          selectedFloorId = null;
                          selectedFloorName = "";
                        });

                        // Navigate to the Dashboard and clear the route stack
                        Get.to(FlatPage());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.offAll(Dashboard());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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
