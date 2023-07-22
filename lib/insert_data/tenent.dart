import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rent_management/screens/tenent_page.dart';
import '../classes/flat_info.dart';
import '../classes/floor_info.dart';
import '../classes/tenent_info.dart';
import '../db_helper.dart';
import '../screens/dashboard_page.dart';
import '../shared_data/flat_data.dart';
import '../shared_data/floor_data.dart';

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

  final format = DateFormat("yyyy-MM-dd");
  late Stream<List<TenentInfo>> tenentStream = const Stream.empty();
  String? date;
  @override
  void initState() {
    _fetchTenentData();

    super.initState();
  }

  Future<void> _fetchTenentData() async {
    tenentStream = await DBHelper.readTenentData().asStream();
    //  List<FlatInfo> flatList = await DBHelper.readFlatData();
    //   setState(() {
    //     Provider.of<FlatData>(context, listen: false).updateFlatList(flatList);
    //   });
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
                  SizedBox(height: 16),
                  Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: _tenentNameController,
                        decoration: InputDecoration(
                          labelText: 'Tenent Name',
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
                                    .firstWhere(
                                        (floor) => floor.id == selectedFloorId)
                                    .floorName;
                              });
                            },
                            items: floorList
                                .map<DropdownMenuItem<int>>((Floor floor) {
                              return DropdownMenuItem<int>(
                                value: floor.id,
                                child: Text(floor.floorName),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      SizedBox(height: 8),
                      Consumer<FlatData>(
                        builder: (context, flatData, child) {
                          List<FlatInfo> flatList = flatData.flatList;

                          return DropdownButtonFormField<int>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Flat',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            disabledHint: Text('Add Flat First'),
                            value: selectedFlatId,
                            onChanged: (int? value) {
                              setState(() {
                                selectedFlatId = value!;
                                selectedFlatName = flatList
                                    .firstWhere(
                                        (flat) => flat.id == selectedFlatId)
                                    .flatName;
                              });
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
                      SizedBox(height: 8),
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
                      SizedBox(height: 8),
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
                      SizedBox(height: 8),
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
                      SizedBox(height: 8),
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
                      SizedBox(height: 8),
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
                      SizedBox(height: 8),
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
                      SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _rentAmountController,
                        decoration: InputDecoration(
                          labelText: 'Rent Amount',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
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
                      SizedBox(height: 8),
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
                      SizedBox(height: 8),
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
                      SizedBox(height: 8),
                      DateTimeField(
                        decoration: InputDecoration(
                            labelText: 'select date and month of in',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            icon: Icon(Icons.calendar_month)),
                        onChanged: (newValue) {
                          setState(() {
                            date = newValue.toString();
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
                  SizedBox(height: 16),
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
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () async => {
                          if (_tenentNameController.text.isEmpty ||
                              _nidNoController.text.isEmpty ||
                              _passportNoController.text.isEmpty ||
                              _mobileNoController.text.isEmpty ||
                              _emgMobileNoController.text.isEmpty ||
                              _noOfFamilyMemController.text.isEmpty ||
                              _rentAmountController.text.isEmpty ||
                              _gasBillController.text.isEmpty ||
                              _waterBillController.text.isEmpty ||
                              _serviceChargeController.text.isEmpty ||
                              date == "" ||
                              selectedFloorId == null ||
                              selectedFloorName == "" ||
                              selectedFlatId == null ||
                              selectedFlatName == "")
                            {}
                          else
                            {
                              await DBHelper.insertTenentData(TenentInfo(
                                  tenentName: _tenentNameController.text,
                                  floorID: selectedFloorId!,
                                  floorName: selectedFloorName.toString(),
                                  flatID: selectedFlatId!,
                                  flatName: selectedFlatName!,
                                  nidNo: int.parse(_nidNoController.text),
                                  passportNo: _passportNoController.text,
                                  birthCertificateNo: int.parse(
                                      _birthCertificateNoController.text),
                                  mobileNo: int.parse(_mobileNoController.text),
                                  emgMobileNo:
                                      int.parse(_emgMobileNoController.text),
                                  noOfFamilyMem:
                                      int.parse(_noOfFamilyMemController.text),
                                  rentAmount:
                                      double.parse(_rentAmountController.text),
                                  gasBill:
                                      double.parse(_gasBillController.text),
                                  waterBill:
                                      double.parse(_waterBillController.text),
                                  serviceCharge: double.parse(
                                      _serviceChargeController.text),
                                  totalAmount: double.parse(
                                          _rentAmountController.text) +
                                      double.parse(_gasBillController.text) +
                                      double.parse(_waterBillController.text) +
                                      double.parse(
                                          _serviceChargeController.text),
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
                                  messageText: Center(
                                      child: Text(
                                    "saved successfully  \n",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 20),
                                  )),
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: Duration(seconds: 2)),
                              Get.to(TenentPage())
                            }
                        },
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
            ],
          ),
        ),
      ),
    );
  }
}
