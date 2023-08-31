import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rent_management/screens/tenent_page.dart';
import 'package:rent_management/shared_data/tenent_data.dart';
import '../classes/flat_info.dart';
import '../classes/tenent_info.dart';
import '../db_helper.dart';
import '../screens/dashboard_page.dart';
import '../shared_data/flat_data.dart';

class TenentDataPage extends StatefulWidget {
  const TenentDataPage({super.key});

  @override
  State<TenentDataPage> createState() => _TenentDataPageState();
}

class _TenentDataPageState extends State<TenentDataPage> {
  int? selectedFlatId;
  String? selectedFlatName;
  int? selectedFloorId;
  String? selectedFloorName;

  final TextEditingController _tenentNameController = TextEditingController();
  final TextEditingController _nidNoController = TextEditingController();
  final TextEditingController _passportNoController = TextEditingController();
  final TextEditingController _birthCertificateNoController =
      TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _emgMobileNoController = TextEditingController();
  final TextEditingController _noOfFamilyMemController =
      TextEditingController();
  final TextEditingController _rentAmountController = TextEditingController();
  final TextEditingController _gasBillController = TextEditingController();
  final TextEditingController _waterBillController = TextEditingController();
  final TextEditingController _serviceChargeController =
      TextEditingController();

  late Stream<List<TenentInfo>> tenentStream = const Stream.empty();
  DateTime dateTime = DateTime(2023, 1, 1);
  final format = DateFormat("dd MMM y");
  String? date;
  bool ifFlatIDMatch = false;
  @override
  void initState() {
    _fetchTenentData();

    super.initState();
  }

  Future<void> _fetchTenentData() async {
    tenentStream = DBHelper.readTenentData().asStream();
  }

  @override
  void dispose() {
    _tenentNameController.dispose();

    _nidNoController.dispose();
    _passportNoController.dispose();
    _birthCertificateNoController.dispose();
    _mobileNoController.dispose();
    _emgMobileNoController.dispose();
    _rentAmountController.dispose();
    _gasBillController.dispose();
    _waterBillController.dispose();
    _serviceChargeController.dispose();
    _noOfFamilyMemController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tenent',
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
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Column(
                children: [
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _tenentNameController,
                        decoration: InputDecoration(
                          labelText: 'Tenent Name',
                          suffix: const Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      // SizedBox(height: 8),
                      // Consumer<FloorData>(
                      //   builder: (context, floorData, child) {
                      //     List<Floor> floorList = floorData.floorList;

                      //     return DropdownButtonFormField<int>(
                      //       isExpanded: true,
                      //       decoration: InputDecoration(
                      //         suffix: Text(
                      //           '*',
                      //           style: TextStyle(color: Colors.red),
                      //         ),
                      //         labelText: 'Floor',
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //       ),
                      //       disabledHint: Text('Add Floor First'),
                      //       value: selectedFloorId,
                      //       onChanged: (int? value) {
                      //         setState(() {
                      //           selectedFloorId = value!;
                      //           selectedFloorName = floorList
                      //               .firstWhere(
                      //                   (floor) => floor.id == selectedFloorId)
                      //               .floorName;
                      //         });
                      //       },
                      //       items: floorList
                      //           .map<DropdownMenuItem<int>>((Floor floor) {
                      //         return DropdownMenuItem<int>(
                      //           value: floor.id,
                      //           child: Text(floor.floorName),
                      //         );
                      //       }).toList(),
                      //     );
                      //   },
                      // ),
                      const SizedBox(height: 8),
                      Consumer<FlatData>(
                        builder: (context, flatData, child) {
                          List<FlatInfo> flatList = flatData.flatList;

                          return DropdownButtonFormField<int>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              suffix: const Text(
                                '*',
                                style: TextStyle(color: Colors.red),
                              ),
                              labelText: 'Flat',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            disabledHint: const Text('Add Flat First'),
                            value: selectedFlatId,
                            onChanged: (int? value) {
                              setState(() {
                                selectedFlatId = value!;
                                selectedFlatName = flatList
                                    .firstWhere(
                                        (flat) => flat.id == selectedFlatId)
                                    .flatName;
                              });
                              ifFlatIDMatch = Provider.of<TenantData>(context,
                                      listen: false)
                                  .tenantList
                                  .any((e) => e.flatID == selectedFlatId);
                              if (ifFlatIDMatch) {
                                Get.snackbar("", "",
                                    messageText: const Center(
                                        child: Text(
                                      "selected flat already \nadded to another tenant\n",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 255, 22, 22),
                                          fontSize: 20),
                                    )),
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 2));
                              }
                            },
                            items: flatList
                                .map<DropdownMenuItem<int>>((FlatInfo flat) {
                              return DropdownMenuItem<int>(
                                value: flat.id,
                                child: Text(flat.flatName),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _nidNoController,
                        decoration: InputDecoration(
                          labelText: 'NID No.',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _passportNoController,
                        decoration: InputDecoration(
                          labelText: 'Passport No.',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _birthCertificateNoController,
                        decoration: InputDecoration(
                          labelText: 'Birth Certificate No.',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _mobileNoController,
                        decoration: InputDecoration(
                          labelText: 'Mobile No.',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _emgMobileNoController,
                        decoration: InputDecoration(
                          labelText: 'Emergency Mobile No.',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _noOfFamilyMemController,
                        decoration: InputDecoration(
                          labelText: 'No. Of Family Member',
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
                      DateTimeField(
                        decoration: InputDecoration(
                            suffix: const Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            labelText: 'select date and month of in',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            icon: const Icon(Icons.calendar_month)),
                        onChanged: (newValue) {
                          setState(() {
                            dateTime = newValue!;
                            date = format.format(dateTime);
                          });
                        },
                        format: format,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
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
                        onPressed: () async => {
                          if (_tenentNameController.text.isNotEmpty &&
                              // _nidNoController.text.isEmpty ||
                              // _passportNoController.text.isEmpty ||
                              // _mobileNoController.text.isEmpty ||
                              // _emgMobileNoController.text.isEmpty ||
                              // _noOfFamilyMemController.text.isEmpty ||
                              _rentAmountController.text.isNotEmpty &&
                              // _gasBillController.text.isEmpty ||
                              // _waterBillController.text.isEmpty ||
                              // _serviceChargeController.text.isEmpty ||
                              date != "" &&
                              // selectedFloorId != null &&
                              // selectedFloorName != "" &&
                              selectedFlatId != null &&
                              selectedFlatName != "" &&
                              ifFlatIDMatch == false)
                            {
                              await DBHelper.insertTenentData(TenentInfo(
                                  tenentName: _tenentNameController.text,
                                  // floorID: selectedFloorId!,
                                  // floorName: selectedFloorName.toString(),
                                  flatID: selectedFlatId!,
                                  flatName: selectedFlatName!,
                                  nidNo: _nidNoController.text.isNotEmpty
                                      ? int.parse(_nidNoController.text)
                                      : 0,
                                  passportNo: _passportNoController.text.isNotEmpty
                                      ? _passportNoController.text
                                      : "",
                                  birthCertificateNo: _birthCertificateNoController.text.isNotEmpty
                                      ? int.parse(
                                          _birthCertificateNoController.text)
                                      : 0,
                                  mobileNo: _mobileNoController.text.isNotEmpty
                                      ? int.parse(_mobileNoController.text)
                                      : 0,
                                  emgMobileNo: _emgMobileNoController.text.isNotEmpty
                                      ? int.parse(_emgMobileNoController.text)
                                      : 0,
                                  noOfFamilyMem: _noOfFamilyMemController.text.isNotEmpty
                                      ? int.parse(_noOfFamilyMemController.text)
                                      : 0,
                                  rentAmount:
                                      double.parse(_rentAmountController.text),
                                  gasBill: _gasBillController.text.isNotEmpty
                                      ? double.parse(_gasBillController.text)
                                      : 0,
                                  waterBill: _waterBillController.text.isNotEmpty
                                      ? double.parse(_waterBillController.text)
                                      : 0,
                                  serviceCharge:
                                      _serviceChargeController.text.isNotEmpty
                                          ? double.parse(
                                              _serviceChargeController.text)
                                          : 0,
                                  totalAmount: double.parse(_rentAmountController.text) +
                                      (_gasBillController.text.isNotEmpty
                                          ? double.parse(_gasBillController.text)
                                          : 0) +
                                      (_waterBillController.text.isNotEmpty ? double.parse(_waterBillController.text) : 0) +
                                      (_serviceChargeController.text.isNotEmpty ? double.parse(_serviceChargeController.text) : 0),
                                  dateOfIn: date.toString())),
                              setState(() {
                                _fetchTenentData();
                                _tenentNameController.text = "";
                                _nidNoController.text = "";
                                _passportNoController.text = "";
                                _birthCertificateNoController.text = "";
                                _mobileNoController.text = "";
                                _emgMobileNoController.text = "";
                                _noOfFamilyMemController.text = "";
                                _rentAmountController.text = "";
                                _gasBillController.text = "";
                                _waterBillController.text = "";
                                _serviceChargeController.text = "";
                                date = "";

                                selectedFloorId = null;
                                selectedFlatName = "";
                                selectedFlatId = null;
                                selectedFloorName = "";
                              }),
                              Get.snackbar("", "",
                                  messageText: const Center(
                                      child: Text(
                                    "saved successfully  \n",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 20),
                                  )),
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 2)),
                              Get.to(const TenentPage())
                            }
                          else
                            {
                              if (ifFlatIDMatch)
                                {
                                  Get.snackbar("", "",
                                      messageText: const Center(
                                          child: Text(
                                        "please change flat\n",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 22, 22),
                                            fontSize: 20),
                                      )),
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 2))
                                }
                              else
                                {
                                  Get.snackbar("", "",
                                      messageText: const Center(
                                          child: Text(
                                        "please fill up all * marked field\n",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 22, 22),
                                            fontSize: 20),
                                      )),
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 2))
                                },
                            }
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.offAll(const Dashboard());
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
            ],
          ),
        ),
      ),
    );
  }
}
