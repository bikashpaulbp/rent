import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:rent_management/models/tenant_model.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/services/tenant_service.dart';
import 'package:rent_management/shared_data/tenent_data.dart';

// ignore: must_be_immutable
class TenentDataPage extends StatefulWidget {
  void Function() refresh;
  TenentDataPage({super.key, required this.refresh});

  @override
  State<TenentDataPage> createState() => _TenentDataPageState();
}

class _TenentDataPageState extends State<TenentDataPage> {
  final TextEditingController _tenentNameController = TextEditingController();
  final TextEditingController _nidNoController = TextEditingController();
  final TextEditingController _passportNoController = TextEditingController();
  final TextEditingController _birthCertificateNoController =
      TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _emgMobileNoController = TextEditingController();
  final TextEditingController _noOfFamilyMemController =
      TextEditingController();
  final TextEditingController _advanceAmountController =
      TextEditingController();
  bool isActive = true;

  TenantApiService tenantApiService = TenantApiService();
  DateTime dateTime = DateTime(2023, 1, 1);
  final format = DateFormat("dd MMM y");
  DateTime? date;
  UserModel user = UserModel();
  DateTime? arrivalDate;
  DateTime? rentAmountChangeDate;
  AuthStateManager authStateManager = AuthStateManager();
  UserModel? loggedInUser = UserModel();

  int? buildingId;
  Uint8List? nidImage;
  Uint8List? tenantImage;

  File? _tenantImage;
  File? _nidImage;
  bool isLoading = false;

  @override
  void initState() {
    getBuildingId();
    getUser();
    super.initState();
  }

  Future<void> _pickTenantImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final originalImageData = await imageFile.readAsBytes();

      final compressedImageData = await FlutterImageCompress.compressWithList(
        originalImageData,
        minWidth: 900,
        minHeight: 600,
        quality: 40,
      );

      setState(() {
        _tenantImage = imageFile;
        tenantImage = compressedImageData;
      });
    }
  }

  Future<void> _pickNidImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final originalImageData = await imageFile.readAsBytes();

      final compressedImageData = await FlutterImageCompress.compressWithList(
        originalImageData,
        minWidth: 900,
        minHeight: 600,
        quality: 40,
      );

      setState(() {
        _nidImage = imageFile;
        nidImage = compressedImageData;
      });
    }
  }

  Future<void> getUser() async {
    user = (await authStateManager.getLoggedInUser())!;
  }

  Future<void> getBuildingId() async {
    buildingId = await authStateManager.getBuildingId();
  }

  @override
  void dispose() {
    _tenentNameController.dispose();

    _nidNoController.dispose();
    _passportNoController.dispose();
    _birthCertificateNoController.dispose();
    _mobileNoController.dispose();
    _emgMobileNoController.dispose();
    _advanceAmountController.dispose();

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
                      const SizedBox(height: 8),
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
                        controller: _advanceAmountController,
                        decoration: InputDecoration(
                          suffix: const Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          ),
                          labelText: 'Advance Amount',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const SizedBox(height: 8),
                      DateTimeField(
                        decoration: InputDecoration(
                            suffix: const Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            ),
                            labelText: 'select date of arrival',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            icon: const Icon(Icons.calendar_month)),
                        onChanged: (newValue) {
                          setState(() {
                            dateTime = newValue!;
                            arrivalDate = dateTime;
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
                      SizedBox(
                        height: 20,
                      ),
                      DateTimeField(
                        decoration: InputDecoration(
                            labelText: 'select date of change rent amount',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            icon: const Icon(Icons.calendar_month)),
                        onChanged: (newValue) {
                          setState(() {
                            dateTime = newValue!;
                            rentAmountChangeDate = dateTime;
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
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        height: 20,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      isLoading == false
                          ? Text("")
                          : Center(child: CircularProgressIndicator()),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                          getBuildingId(),
                          getUser(),
                          if (_tenentNameController.text.isNotEmpty &&
                              arrivalDate != null &&
                              _advanceAmountController.text.isNotEmpty)
                            {
                              setState(() {
                                isLoading = true;
                              }),
                              await tenantApiService
                                  .createTenant(TenantModel(
                                    name: _tenentNameController.text,
                                    nid: _nidNoController.text.isNotEmpty
                                        ? _nidNoController.text
                                        : "",
                                    passportNo:
                                        _passportNoController.text.isNotEmpty
                                            ? _passportNoController.text
                                            : "",
                                    birthCertificateNo:
                                        _birthCertificateNoController
                                                .text.isNotEmpty
                                            ? _birthCertificateNoController.text
                                            : "",
                                    mobileNo:
                                        _mobileNoController.text.isNotEmpty
                                            ? _mobileNoController.text
                                            : "",
                                    emgMobileNo:
                                        _emgMobileNoController.text.isNotEmpty
                                            ? _emgMobileNoController.text
                                            : "",
                                    noofFamilyMember:
                                        _noOfFamilyMemController.text.isNotEmpty
                                            ? int.parse(
                                                _noOfFamilyMemController.text)
                                            : 0,
                                    arrivalDate: arrivalDate,
                                    advanceAmount: int.parse(
                                        _advanceAmountController.text),
                                    buildingId: buildingId,
                                    isActive: isActive,
                                    rentAmountChangeDate:
                                        rentAmountChangeDate ?? null,
                                    tenantImage: tenantImage!.isNotEmpty
                                        ? tenantImage
                                        : null,
                                    tenantNidImage:
                                        nidImage!.isNotEmpty ? nidImage : null,
                                    userId: user.id,
                                  ))
                                  .whenComplete(() => setState(
                                        () {
                                          isLoading = false;
                                        },
                                      )),
                              widget.refresh(),
                              Get.back(),
                              setState(() {
                                context.read<TenantData>().getTenantList();
                                // _fetchTenantData();

                                _tenentNameController.text = "";
                                _nidNoController.text = "";
                                _passportNoController.text = "";
                                _birthCertificateNoController.text = "";
                                _mobileNoController.text = "";
                                _emgMobileNoController.text = "";
                                _noOfFamilyMemController.text = "";
                                _advanceAmountController.text = "";
                              }),
                              context.read<TenantData>().getTenantList(),
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("saved successfully"))),
                              Get.back(),
                            }
                          else
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("enter required information")))
                            }
                        },
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
            ],
          ),
        ),
      ),
    );
  }
}
