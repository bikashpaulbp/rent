import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_management/models/floor_model.dart';
import 'package:rent_management/services/floor_service.dart';

// ignore: must_be_immutable
class FloorDataPage extends StatefulWidget {
  void Function() refresh;
  FloorDataPage({super.key, required this.refresh});

  @override
  State<FloorDataPage> createState() => _FloorDataPageState();
}

class _FloorDataPageState extends State<FloorDataPage> {
  final TextEditingController _floorController = TextEditingController();

  FloorApiService floorApiService = FloorApiService();

  @override
  void dispose() {
    _floorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Floor',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.name,
              controller: _floorController,
              decoration: InputDecoration(
                labelText: "Floor Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_floorController.text.isNotEmpty) {
                          await floorApiService.createFloor(
                            FloorModel(name: _floorController.text),
                          );
                          widget.refresh();
                          Get.back();
                          _floorController.clear();

                          Get.snackbar("", "",
                              messageText: const Center(
                                  child: Text(
                                "saved successfully  \n",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 20),
                              )),
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 2));
                        } else {
                          Get.snackbar("", "",
                              messageText: const Center(
                                  child: Text(
                                " please provide floor name\n",
                                style: TextStyle(
                                    color: Color.fromARGB(233, 216, 41, 41),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
