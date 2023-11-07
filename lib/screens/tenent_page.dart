import 'dart:io';
import 'dart:typed_data';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:rent_management/insert_data/tenent.dart';
import 'package:rent_management/models/building_model.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/models/tenant_model.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/services/flat_service.dart';
import 'package:rent_management/services/tenant_service.dart';

import '../shared_data/tenent_data.dart';

class TenentPage extends StatefulWidget {
  const TenentPage({super.key});

  @override
  State<TenentPage> createState() => _TenentPageState();
}

class _TenentPageState extends State<TenentPage> {
  final _newTenentNameController = TextEditingController();
  final _newNidNoController = TextEditingController();
  final _newPassportNoController = TextEditingController();
  final _newBirthCertificateNoController = TextEditingController();
  final _newMobileNoController = TextEditingController();
  final _newEmgMobileNoController = TextEditingController();
  final _newNoOfFamilyMemController = TextEditingController();
  final _newAdvanceAmountController = TextEditingController();

  late Stream<List<TenantModel>> tenantStream = const Stream.empty();
  TenantApiService tenantApiService = TenantApiService();
  DateTime dateTime = DateTime(2023, 1, 1);
  final format = DateFormat("dd MMM y");
  DateTime? date;
  UserModel user = UserModel();
  DateTime? arrivalDate;
  DateTime? rentAmountChangeDate;
  AuthStateManager authStateManager = AuthStateManager();
  UserModel? loggedInUser = UserModel();
  int? userId;
  int? buildingId;
  Uint8List? nidImage;
  Uint8List? tenantImage;
  bool isActive = true;
  File? _tenantImage;
  File? _nidImage;

  @override
  void initState() {
    _fetchTenantData();
    setState(() {});
    super.initState();
  }

  void refresh() {
    getLocalInfo();
    _fetchTenantData();
  }

  Future<void> getLocalInfo() async {
    buildingId = await authStateManager.getBuildingId();
    loggedInUser = await authStateManager.getLoggedInUser();
  }

  Future<void> _fetchTenantData() async {
    tenantStream = tenantApiService.getAllTenants().asStream();
  }

  Future<void> _pickTenantImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _tenantImage = File(pickedFile.path);
      });
      tenantImage = await _tenantImage!.readAsBytes();
    }
  }

  Future<void> _pickNidImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _nidImage = File(pickedFile.path);
      });
      nidImage = await _nidImage!.readAsBytes();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 49, 49, 49)),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
            child: Text(
          "Tenants",
          style: TextStyle(color: Colors.black),
        )),
      ),
      floatingActionButton: CircleAvatar(
        backgroundColor: const Color.fromARGB(255, 66, 129, 247),
        child: IconButton(
          onPressed: () {
            Get.to(TenentDataPage(refresh: refresh));
          },
          icon: const Icon(Icons.add),
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.green.shade300,
      //   title: const Center(child: Text('Tenant List')),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    // const Text(
                    //   'Tenants',
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     color: Color.fromARGB(255, 78, 78, 78),
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.72,
                      child: StreamBuilder<List<TenantModel>>(
                        stream: tenantStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<TenantModel>> snapshot) {
                          getLocalInfo();
                          _fetchTenantData();
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data!.isNotEmpty) {
                            List<TenantModel> tenentList = snapshot.data!
                                .where((e) => e.buildingId == buildingId)
                                .toList();

                            return ListView.builder(
                              itemCount: tenentList.length,
                              itemBuilder: (BuildContext context, int index) {
                                TenantModel tenent = tenentList[index];

                                return ListTile(
                                  title: Container(
                                    width: 500,
                                    height:
                                        MediaQuery.sizeOf(context).height * 1,
                                    child: Card(
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 250,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      'Tenent Name: ${tenent.name}',
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      'NID : ${tenent.nid}',
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      'Passport : ${tenent.passportNo}',
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      'BirthCertificate: ${tenent.birthCertificateNo}',
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      'Mobile: ${tenent.mobileNo}',
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      'Emergency Mobile: ${tenent.emgMobileNo}',
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      'Family Members: ${tenent.noofFamilyMember ?? ""}',
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      'Advance Amount: ${tenent.advanceAmount ?? ""}',
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      'Date of Arrival: ${tenent.arrivalDate != null ? DateFormat('dd MMM y').format(tenent.arrivalDate!) : ""}',
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      'Date of Change Rent Amount: ${tenent.rentAmountChangeDate != null ? DateFormat('dd MMM y').format(tenent.rentAmountChangeDate!) : ""}',
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Tenant Image",
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    22,
                                                                    167,
                                                                    192),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Image.memory(
                                                          tenent.tenantImage!,
                                                          width: 300,
                                                          height: 200,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "NID Image",
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    22,
                                                                    167,
                                                                    192),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Image.memory(
                                                          tenent
                                                              .tenantNidImage!,
                                                          width: 300,
                                                          height: 200,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 255, 225, 0),
                                              child: IconButton(
                                                  iconSize: 15,
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    _newTenentNameController
                                                        .text = tenent.name!;
                                                    _newNidNoController.text =
                                                        tenent.nid.toString();
                                                    _newPassportNoController
                                                            .text =
                                                        tenent.passportNo
                                                            .toString();
                                                    _newBirthCertificateNoController
                                                            .text =
                                                        tenent
                                                            .birthCertificateNo
                                                            .toString();
                                                    _newMobileNoController
                                                            .text =
                                                        tenent.mobileNo
                                                            .toString();
                                                    _newEmgMobileNoController
                                                            .text =
                                                        tenent.emgMobileNo
                                                            .toString();
                                                    _newAdvanceAmountController
                                                            .text =
                                                        tenent.advanceAmount
                                                            .toString();
                                                    _newNoOfFamilyMemController
                                                            .text =
                                                        tenent.noofFamilyMember
                                                            .toString();

                                                    showModalBottomSheet<void>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return SingleChildScrollView(
                                                          child: Container(
                                                            height: 1000,
                                                            color: const Color
                                                                .fromARGB(255,
                                                                255, 255, 255),
                                                            child: Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <Widget>[
                                                                  const Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
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
                                                                                  controller: _newTenentNameController,
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
                                                                                  controller: _newNidNoController,
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
                                                                                  controller: _newPassportNoController,
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
                                                                                  controller: _newBirthCertificateNoController,
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
                                                                                  controller: _newMobileNoController,
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
                                                                                  controller: _newEmgMobileNoController,
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
                                                                                  controller: _newNoOfFamilyMemController,
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
                                                                                'Advance \n Amount',
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
                                                                                  controller: _newAdvanceAmountController,
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
                                                                        DateTimeField(
                                                                          decoration: InputDecoration(
                                                                              suffix: const Text(
                                                                                '*',
                                                                                style: TextStyle(color: Colors.red),
                                                                              ),
                                                                              labelText: 'select date of arrival',
                                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                                                              icon: const Icon(Icons.calendar_month)),
                                                                          onChanged:
                                                                              (newValue) {
                                                                            setState(() {
                                                                              dateTime = newValue!;
                                                                              arrivalDate = dateTime;
                                                                            });
                                                                          },
                                                                          format:
                                                                              format,
                                                                          onShowPicker:
                                                                              (context, currentValue) {
                                                                            return showDatePicker(
                                                                              context: context,
                                                                              firstDate: DateTime(1900),
                                                                              initialDate: currentValue ?? DateTime.now(),
                                                                              lastDate: DateTime(2100),
                                                                            );
                                                                          },
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),
                                                                        DateTimeField(
                                                                          decoration: InputDecoration(
                                                                              labelText: 'select date of change rent amount',
                                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                                                              icon: const Icon(Icons.calendar_month)),
                                                                          onChanged:
                                                                              (newValue) {
                                                                            setState(() {
                                                                              dateTime = newValue!;
                                                                              rentAmountChangeDate = dateTime;
                                                                            });
                                                                          },
                                                                          format:
                                                                              format,
                                                                          onShowPicker:
                                                                              (context, currentValue) {
                                                                            return showDatePicker(
                                                                              context: context,
                                                                              firstDate: DateTime(1900),
                                                                              initialDate: currentValue ?? DateTime.now(),
                                                                              lastDate: DateTime(2100),
                                                                            );
                                                                          },
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),
                                                                        Center(
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              if (_tenantImage != null)
                                                                                Image.file(
                                                                                  _tenantImage!,
                                                                                  width: 100,
                                                                                  height: 100,
                                                                                )
                                                                              else
                                                                                Icon(Icons.image, size: 100),
                                                                              SizedBox(height: 20),
                                                                              TextButton(
                                                                                child: _tenantImage == null
                                                                                    ? Text(
                                                                                        "choose tenant image",
                                                                                        style: TextStyle(fontSize: 20),
                                                                                      )
                                                                                    : Text(
                                                                                        "change tenant image",
                                                                                        style: TextStyle(fontSize: 20),
                                                                                      ),
                                                                                onPressed: _pickTenantImage,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),
                                                                        Center(
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              if (_nidImage != null)
                                                                                Image.file(
                                                                                  _nidImage!,
                                                                                  width: 100,
                                                                                  height: 100,
                                                                                )
                                                                              else
                                                                                Icon(Icons.image, size: 100),
                                                                              SizedBox(width: 20),
                                                                              TextButton(
                                                                                child: _nidImage == null
                                                                                    ? Text(
                                                                                        "choose NID image",
                                                                                        style: TextStyle(fontSize: 20),
                                                                                      )
                                                                                    : Text(
                                                                                        "change NID image",
                                                                                        style: TextStyle(fontSize: 20),
                                                                                      ),
                                                                                onPressed: _pickNidImage,
                                                                              ),
                                                                            ],
                                                                          ),
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
                                                                            int id =
                                                                                tenent.id!;
                                                                            TenantModel updatedTenant = TenantModel(
                                                                                name: _newTenentNameController.text == "" ? "" : _newTenentNameController.text,
                                                                                nid: _newNidNoController.text == "" ? "" : _newNidNoController.text,
                                                                                passportNo: _newPassportNoController.text == "" ? "" : _newPassportNoController.text,
                                                                                birthCertificateNo: _newBirthCertificateNoController.text == "" ? "" : _newBirthCertificateNoController.text,
                                                                                mobileNo: _newMobileNoController.text == "" ? "" : _newMobileNoController.text,
                                                                                emgMobileNo: _newEmgMobileNoController == "" ? "" : _newMobileNoController.text,
                                                                                noofFamilyMember: int.parse(_newNoOfFamilyMemController.text),
                                                                                advanceAmount: int.parse(_newAdvanceAmountController.text),
                                                                                arrivalDate: arrivalDate ?? tenent.arrivalDate,
                                                                                buildingId: buildingId,
                                                                                isActive: isActive,
                                                                                rentAmountChangeDate: rentAmountChangeDate ?? tenent.rentAmountChangeDate,
                                                                                tenantImage: tenantImage,
                                                                                tenantNidImage: nidImage,
                                                                                userId: user.id);
                                                                            await tenantApiService.updateTenant(
                                                                                tenant: updatedTenant,
                                                                                id: id);
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("updated successfully")));

                                                                            setState(() {
                                                                              _fetchTenantData();

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
                                            const SizedBox(width: 5),
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 252, 0, 0),
                                              child: IconButton(
                                                  iconSize: 15,
                                                  color: Colors.white,
                                                  onPressed: () async {
                                                    await tenantApiService
                                                        .deleteTenant(
                                                            tenent.id!);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "deleted successfully")));

                                                    setState(() {
                                                      _fetchTenantData();
                                                    });
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Center(
                                child: Text('no tenants available.'));
                          }
                        },
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
