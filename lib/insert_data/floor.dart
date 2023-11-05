import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_management/models/floor_model.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/services/floor_service.dart';

// ignore: must_be_immutable
class FloorDataPage extends StatefulWidget {
  FloorDataPage({super.key});

  @override
  State<FloorDataPage> createState() => _FloorDataPageState();
}

class _FloorDataPageState extends State<FloorDataPage> {
  final TextEditingController _floorController = TextEditingController();
  FloorApiService floorApiService = FloorApiService();

  AuthStateManager authStateManager = AuthStateManager();
  UserModel? loggedInUser = UserModel();
  int? buildingId;
  @override
  void initState() {
    getLocalInfo();
    super.initState();
  }

  Future<void> getLocalInfo() async {
    buildingId = await authStateManager.getBuildingId();
    loggedInUser = await authStateManager.getLoggedInUser();
  }

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
                        if (_floorController.text.isNotEmpty &&
                            buildingId != null) {
                          await floorApiService
                              .createFloor(
                            FloorModel(
                              name: _floorController.text,
                              buildingId: buildingId,
                              isActive: true,
                              userId: loggedInUser!.id,
                            ),
                          )
                              .whenComplete(() {
                            Get.back();
                            _floorController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("saved successfully")));
                          });
                        } else if (buildingId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("please add building first")));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("please provide floor name")));
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
