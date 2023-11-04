import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/models/floor_model.dart';
import 'package:rent_management/services/flat_service.dart';

import '../shared_data/floor_data.dart';

// ignore: must_be_immutable
class FlatDataPage extends StatefulWidget {
  void Function() refresh;
  FlatDataPage({super.key, required this.refresh});

  @override
  State<FlatDataPage> createState() => _FlatDataPageState();
}

class _FlatDataPageState extends State<FlatDataPage> {
  FlatApiService flatApiService = FlatApiService();
  final TextEditingController _flatNameController = TextEditingController();
  final TextEditingController _noOfMasterbedRoomController =
      TextEditingController();
  final TextEditingController _noOfBedroomController = TextEditingController();
  final TextEditingController _flatSideController = TextEditingController();

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
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: _flatNameController,
                decoration: InputDecoration(
                  suffix: const Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                  labelText: 'Flat Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Consumer<FloorData>(
                builder: (context, floorData, child) {
                  floorData.getFloorList();
                  List<FloorModel> floorList = floorData.floorList;

                  return DropdownButtonFormField<int>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      suffix: const Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                      labelText: 'Floor',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    disabledHint: const Text('Add Floor First'),
                    value: selectedFloorId,
                    onChanged: (int? value) {
                      setState(() {
                        selectedFloorId = value!;
                        selectedFloorName = floorList
                            .firstWhere((floor) => floor.id == selectedFloorId)
                            .name;
                      });
                    },
                    items: floorList
                        .map<DropdownMenuItem<int>>((FloorModel floor) {
                      return DropdownMenuItem<int>(
                        value: floor.id,
                        child: Text(floor.name!),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _noOfMasterbedRoomController,
                decoration: InputDecoration(
                  suffix: const Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                  labelText: 'No. Of Master Bedroom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _noOfBedroomController,
                decoration: InputDecoration(
                  suffix: const Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                  labelText: 'No. of Bedroom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _noOfWashroomController,
                decoration: InputDecoration(
                  suffix: const Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                  labelText: 'No. of Washroom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: _flatSideController,
                decoration: InputDecoration(
                  suffix: const Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                  labelText: 'Flat Side',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_flatNameController.text.isNotEmpty &&
                          _noOfMasterbedRoomController.text.isNotEmpty &&
                          _noOfBedroomController.text.isNotEmpty &&
                          _noOfWashroomController.text.isNotEmpty &&
                          _flatSideController.text.isNotEmpty &&
                          selectedFloorId != null &&
                          selectedFloorName != "") {
                        await flatApiService.createFlat(FlatModel(
                          floorId: selectedFloorId!,
                          name: _flatNameController.text,
                          flatSide: _flatSideController.text,
                          flatSize: _flatSizeController.text.isNotEmpty
                              ? int.parse(_flatSizeController.text)
                              : 0,
                          masterbedRoom:
                              int.parse(_noOfMasterbedRoomController.text),
                          bedroom: int.parse(_noOfBedroomController.text),
                          washroom: int.parse(_noOfWashroomController.text),
                        ));
                        widget.refresh();
                        Get.back();

                        Get.snackbar("", "",
                            messageText: const Center(
                                child: Text(
                              "saved successfully\n",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 20),
                            )),
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2));

                        setState(() {
                          _flatNameController.clear();
                          _noOfMasterbedRoomController.clear();
                          _noOfBedroomController.clear();
                          _noOfWashroomController.clear();
                          _flatSideController.clear();

                          _flatSizeController.clear();

                          selectedFloorId = null;
                        });
                      } else {
                        Get.snackbar("", "",
                            messageText: const Center(
                                child: Text(
                              " please fill up all * marked field\n",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 22, 22),
                                  fontSize: 20),
                            )),
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2));
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
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
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
                    child: const Text(
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
