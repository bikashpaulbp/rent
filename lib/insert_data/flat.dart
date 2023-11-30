import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/models/floor_model.dart';
import 'package:rent_management/models/tenant_model.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/services/flat_service.dart';
import 'package:rent_management/shared_data/tenent_data.dart';

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
  final TextEditingController _rentAmountController = TextEditingController();
  final TextEditingController _gasBillController = TextEditingController();
  final TextEditingController _waterBillController = TextEditingController();
  final TextEditingController _serviceChargeController =
      TextEditingController();
  int? selectedTenantId;
  int? buildingId;
  int? selectedFloorId;
  bool isLoading = false;
  UserModel user = UserModel();
  AuthStateManager authStateManager = AuthStateManager();
  bool isActive = true;

  @override
  void initState() {
    getUser();
    getBuildingId();
    super.initState();
  }

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

  Future<void> getUser() async {
    user = (await authStateManager.getLoggedInUser())!;
  }

  Future<void> getBuildingId() async {
    buildingId = await authStateManager.getBuildingId();
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
                  getBuildingId();
                  floorData.getFloorList();

                  List<FloorModel> floorList = floorData.floorList
                      .where((e) => e.buildingId == buildingId)
                      .toList();

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
                        // selectedFloorName = floorList
                        //     .firstWhere((floor) => floor.id == selectedFloorId)
                        //     .name;
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
              Consumer<TenantData>(
                builder: (context, tenant, child) {
                  getBuildingId();
                  tenant.getTenantList();

                  List<TenantModel> tenantList = tenant.tenantList
                      .where((element) => element.buildingId == buildingId)
                      .toList();
                  return DropdownButtonFormField<int>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      suffix: const Text(
                        '*',
                        style: TextStyle(color: Colors.red),
                      ),
                      labelText: 'Tenant',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    disabledHint: const Text('Add Tenant First'),
                    value: selectedTenantId,
                    onChanged: (int? value) {
                      setState(() {
                        selectedTenantId = value!;
                        // selectedFloorName = floorList
                        //     .firstWhere((floor) => floor.id == selectedFloorId)
                        //     .name;
                      });
                    },
                    items: tenantList
                        .map<DropdownMenuItem<int>>((TenantModel tenant) {
                      return DropdownMenuItem<int>(
                        value: tenant.id,
                        child: Text(tenant.name!),
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
                controller: _rentAmountController,
                decoration: InputDecoration(
                  suffix: const Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                  labelText: 'Rent Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _gasBillController,
                decoration: InputDecoration(
                  labelText: 'Gas Bill',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _waterBillController,
                decoration: InputDecoration(
                  labelText: 'Water Bill',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _serviceChargeController,
                decoration: InputDecoration(
                  labelText: 'Service Charge',
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
              SizedBox(
                height: 10,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  isLoading == true
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            getUser();
                            int userId = user.id!;
                            getBuildingId();

                            if (_flatNameController.text.isNotEmpty &&
                                _noOfMasterbedRoomController.text.isNotEmpty &&
                                _noOfBedroomController.text.isNotEmpty &&
                                _noOfWashroomController.text.isNotEmpty &&
                                _flatSideController.text.isNotEmpty &&
                                _rentAmountController.text.isNotEmpty &&
                                selectedFloorId != null &&
                                selectedTenantId != null) {
                              await flatApiService.createFlat(FlatModel(
                                userId: userId,
                                buildingId: buildingId,
                                isActive: isActive,
                                tenantId: selectedTenantId,
                                rentAmount:
                                    _rentAmountController.text.isNotEmpty
                                        ? int.parse(_rentAmountController.text)
                                        : 0,
                                waterBill: _waterBillController.text.isNotEmpty
                                    ? int.parse(_waterBillController.text)
                                    : 0,
                                gasBill: _gasBillController.text.isNotEmpty
                                    ? int.parse(_gasBillController.text)
                                    : 0,
                                serviceCharge: _serviceChargeController
                                        .text.isNotEmpty
                                    ? int.parse(_serviceChargeController.text)
                                    : 0,
                                floorId: selectedFloorId!,
                                name: _flatNameController.text,
                                flatSide: _flatSideController.text,
                                flatSize: _flatSizeController.text.isNotEmpty
                                    ? int.parse(_flatSizeController.text)
                                    : 0,
                                masterbedRoom:
                                    _noOfMasterbedRoomController.text.isNotEmpty
                                        ? int.parse(
                                            _noOfMasterbedRoomController.text)
                                        : 0,
                                bedroom: _noOfBedroomController.text.isNotEmpty
                                    ? int.parse(_noOfBedroomController.text)
                                    : 0,
                                washroom: _noOfWashroomController
                                        .text.isNotEmpty
                                    ? int.parse(_noOfWashroomController.text)
                                    : 0,
                              ));

                              Get.back();

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("saved successfully")));

                              setState(() {
                                widget.refresh();
                                _flatNameController.clear();
                                _noOfMasterbedRoomController.clear();
                                _noOfBedroomController.clear();
                                _noOfWashroomController.clear();
                                _flatSideController.clear();

                                _flatSizeController.clear();

                                selectedFloorId = null;
                                selectedTenantId = null;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("enter required information")));
                            }
                            setState(() {
                              isLoading = false;
                            });
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
