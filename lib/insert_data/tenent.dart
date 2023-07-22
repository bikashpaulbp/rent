import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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

  String? date;
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
      body: Container(
        width: 500,
        height: 850,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 180, 180, 180).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 134, 134, 134),
                        width: 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      left: 140,
                      right: 140,
                    ),
                    child: const Text(
                      'Tenent',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 134, 134, 134),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            child: Text(
                              'Tenet Name',
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
                                controller: _tenentNameController,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            child: Text(
                              'Floor',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 78, 78, 78),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          Consumer<FloorData>(
                            builder: (context, floorData, child) {
                              List<Floor> floorList = floorData.floorList;

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 170,
                                  height: 30,
                                  child: DropdownButton<int>(
                                    isExpanded: true,
                                    alignment: Alignment.topCenter,
                                    disabledHint: Text('Add Floor First'),
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 3,
                                    hint: Text('Select Floor'),
                                    value: selectedFloorId,
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedFloorId = value!;
                                        selectedFloorName = floorList
                                            .firstWhere((floor) =>
                                                floor.id == selectedFloorId)
                                            .floorName;
                                      });
                                    },
                                    items: floorList.map<DropdownMenuItem<int>>(
                                        (Floor floor) {
                                      return DropdownMenuItem<int>(
                                        value: floor.id,
                                        child: Text(floor.floorName),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            child: Text(
                              'Flat',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 78, 78, 78),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          Consumer<FlatData>(
                            builder: (context, flatData, child) {
                              List<FlatInfo> flatList = flatData.flatList;

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 170,
                                  height: 30,
                                  child: DropdownButton<int>(
                                    isExpanded: true,
                                    alignment: Alignment.topCenter,
                                    disabledHint: Text('Add Flat First'),
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 3,
                                    hint: Text('Select Flat'),
                                    value: selectedFlatId,
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedFlatId = value!;
                                        selectedFlatName = flatList
                                            .firstWhere((flat) =>
                                                flat.id == selectedFlatId)
                                            .flatName;
                                      });
                                    },
                                    items: flatList.map<DropdownMenuItem<int>>(
                                        (FlatInfo flat) {
                                      return DropdownMenuItem<int>(
                                        value: flat.id,
                                        child: Text(flat.flatName),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            child: Text(
                              'NID No.',
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
                                controller: _nidNoController,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            child: Text(
                              'Passport No.',
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
                                controller: _passportNoController,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            child: Text(
                              'Birth \nCertificate No.',
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
                                controller: _birthCertificateNoController,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            child: Text(
                              'Mobile No.',
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
                                controller: _mobileNoController,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            child: Text(
                              'Emergency \nMobile No.',
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
                                controller: _emgMobileNoController,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            child: Text(
                              'No. Of Family \nMember',
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
                                controller: _noOfFamilyMemController,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            child: Text(
                              'Rent Amount',
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
                                controller: _rentAmountController,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            child: Text(
                              'Gas Bill',
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
                                controller: _gasBillController,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            child: Text(
                              'Water Bill',
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
                                controller: _waterBillController,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            child: Text(
                              'Service Charge',
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
                                controller: _serviceChargeController,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            child: Text(
                              'Date of In',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 78, 78, 78),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: <Widget>[
                                DateTimeField(
                                  decoration: InputDecoration(
                                      hintText: 'select date and month',
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
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100),
                                    );
                                  },
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Spacer(),
                        InkWell(
                          onTap: () async => {
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
                                    mobileNo:
                                        int.parse(_mobileNoController.text),
                                    emgMobileNo:
                                        int.parse(_emgMobileNoController.text),
                                    noOfFamilyMem: int.parse(
                                        _noOfFamilyMemController.text),
                                    rentAmount: double.parse(
                                        _rentAmountController.text),
                                    gasBill:
                                        double.parse(_gasBillController.text),
                                    waterBill:
                                        double.parse(_waterBillController.text),
                                    serviceCharge: double.parse(
                                        _serviceChargeController.text),
                                    totalAmount: double.parse(
                                            _rentAmountController.text) +
                                        double.parse(_gasBillController.text) +
                                        double.parse(
                                            _waterBillController.text) +
                                        double.parse(_serviceChargeController.text),
                                    dateOfIn: date.toString())),
                                setState(() {
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
                                Get.offAll(Dashboard())
                              }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 100,
                              height: 45,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                  topRight: Radius.circular(1),
                                  bottomRight: Radius.circular(1),
                                ),
                                color: Color.fromARGB(255, 138, 138, 138),
                              ),
                              child: Container(
                                width: 110,
                                height: 50,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    bottomLeft: Radius.circular(25),
                                    topRight: Radius.circular(1),
                                    bottomRight: Radius.circular(65),
                                  ),
                                  color: Color.fromARGB(255, 101, 99, 99),
                                ),
                                child: const Stack(
                                  children: [
                                    Positioned(
                                      bottom: -1,
                                      right: -1,
                                      child: Icon(
                                        Icons.save,
                                        size: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Positioned(
                                      left: 35,
                                      top: 15,
                                      child: Text(
                                        'Save',
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
                        ),
                        InkWell(
                          onTap: () {
                            Get.offAll(Dashboard());
                          },
                          child: Container(
                            width: 100,
                            height: 45,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                                topRight: Radius.circular(1),
                                bottomRight: Radius.circular(1),
                              ),
                              color: Color.fromARGB(255, 138, 138, 138),
                            ),
                            child: Container(
                              width: 110,
                              height: 50,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                  topRight: Radius.circular(1),
                                  bottomRight: Radius.circular(65),
                                ),
                                color: Color.fromARGB(255, 101, 99, 99),
                              ),
                              child: const Stack(
                                children: [
                                  Positioned(
                                    bottom: -1,
                                    right: -1,
                                    child: Icon(
                                      Icons.cancel,
                                      size: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Positioned(
                                    left: 25,
                                    top: 15,
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
                            ),
                          ),
                        ),
                      ],
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
