import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_management/models/building_model.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/building_page.dart';
import 'package:rent_management/screens/dashboard_page.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/services/building_service.dart';

// ignore: must_be_immutable
class BuildingDataPage extends StatefulWidget {
  void Function() refresh;
  BuildingDataPage({super.key, required this.refresh});

  @override
  State<BuildingDataPage> createState() => _BuildingDataPageState();
}

class _BuildingDataPageState extends State<BuildingDataPage> {
  final TextEditingController _buildingNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  BuildingApiService buildingApiService = BuildingApiService();
  AuthStateManager authStateManager = AuthStateManager();

  UserModel? loggedInUser = UserModel();
  bool isLoading = false;

  @override
  void initState() {
    fetchLoggedInUser();
    super.initState();
  }

  Future<UserModel?> fetchLoggedInUser() async {
    return loggedInUser = await authStateManager.getLoggedInUser();
  }

  @override
  void dispose() {
    _buildingNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Building',
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
              controller: _buildingNameController,
              decoration: InputDecoration(
                labelText: "Building Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.name,
              controller: _addressController,
              decoration: InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
                height: 50,
                width: 50,
                child: isLoading == true
                    ? Center(child: CircularProgressIndicator())
                    : null),
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
                        setState(() {
                          isLoading = true;
                        });
                        if (_buildingNameController.text.isNotEmpty &&
                            _addressController.text.isNotEmpty) {
                          await fetchLoggedInUser();
                          print(loggedInUser!.email);
                          await buildingApiService
                              .createBuilding(
                            BuildingModel(
                                userId: loggedInUser!.id,
                                name: _buildingNameController.text.toString(),
                                address: _addressController.text.toString(),
                                isActive: true),
                          )
                              .then((_) {
                            widget.refresh();
                            setState(() {
                              isLoading = false;
                            });

                            // widget.refresh();
                            // Get.back();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("building saved successfully")));
                            Navigator.of(context).pop();
                            _buildingNameController.clear();
                            _addressController.clear();
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("please provide all information")));
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
                        Navigator.of(context).pop();
                        // pushReplacement(MaterialPageRoute(
                        //     builder: (context) => Dashboard()));
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
