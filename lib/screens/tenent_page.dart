import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:rent_management/classes/tenent_info.dart';
import 'package:rent_management/db_helper.dart';
import 'package:rent_management/insert_data/tenent.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/models/tenant_model.dart';
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
  final _newRentAmountController = TextEditingController();
  final _newGasBillController = TextEditingController();
  final _newWaterBillController = TextEditingController();
  final _newUtilityController = TextEditingController();

  late Stream<List<TenantModel>> tenantStream = const Stream.empty();
  TenantApiService tenantApiService = TenantApiService();
  FlatApiService flatApiService = FlatApiService();
  late List<FlatModel> flatList = [];
  String? flatName;
  final format = DateFormat('dd MMM y');
  @override
  void initState() {
    super.initState();
    _fetchTenantData();
    setState(() {});
  }

  void refresh() {
    _fetchTenantData();
  }

  Future<void> _fetchTenantData() async {
    tenantStream = tenantApiService.getAllTenants().asStream();
    List<TenantModel> tenantList = await tenantApiService.getAllTenants();
    flatList = await flatApiService.getAllFlats();
    setState(() {
      Provider.of<TenantData>(context, listen: false)
          .updateTenantList(tenantList);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: const Center(child: Text('Tenant List')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    const Text(
                      'Tenants',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 78, 78, 78),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.72,
                      child: StreamBuilder<List<TenantModel>>(
                        stream: tenantStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<TenantModel>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data!.isNotEmpty) {
                            List<TenantModel> tenentList = snapshot.data!;

                            return ListView.builder(
                              itemCount: tenentList.length,
                              itemBuilder: (BuildContext context, int index) {
                                TenantModel tenent = tenentList[index];
                                if (flatList.isNotEmpty) {
                                  flatName = flatList
                                      .firstWhere(
                                          (flat) => flat.id == tenent.flatId)
                                      .name;
                                }

                                return ListTile(
                                  title: Container(
                                    width: 500,
                                    height: 500,
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
                                                      'Flat Name: $flatName',
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
                                                      'Date of Arrival: ${tenent.arrivalDate != null ? DateFormat('dd MMM y').format(tenent.arrivalDate!) : "N/A"}',
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
                                                      'Family Members: ${tenent.noofFamilyMember}',
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
                                                      'Rent Amount: ${tenent.rentAmount}',
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
                                                      'Gas Bill: ${tenent.gasBill}',
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
                                                      'Water Bill: ${tenent.waterBill}',
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
                                                      'Utility Bill: ${tenent.utilityBill}',
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
                                                      'Total Amount: ${tenent.totalAmount = (tenent.rentAmount! + tenent.gasBill! + tenent.waterBill! + tenent.utilityBill!)}',
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
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

                                                    _newNoOfFamilyMemController
                                                            .text =
                                                        tenent.noofFamilyMember
                                                            .toString();
                                                    _newRentAmountController
                                                            .text =
                                                        tenent.rentAmount
                                                            .toString();
                                                    _newGasBillController.text =
                                                        tenent.gasBill
                                                            .toString();
                                                    _newWaterBillController
                                                            .text =
                                                        tenent.waterBill
                                                            .toString();
                                                    _newUtilityController.text =
                                                        tenent.utilityBill
                                                            .toString();

                                                    showModalBottomSheet<void>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return SingleChildScrollView(
                                                          child: Container(
                                                            height: 900,
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
                                                                                  controller: _newRentAmountController,
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
                                                                                  controller: _newGasBillController,
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
                                                                                  controller: _newWaterBillController,
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
                                                                                'Utility Bill',
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
                                                                                  controller: _newUtilityController,
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
                                                                                rentAmount: _newRentAmountController.text == "0.0" ? 0 : double.parse(_newRentAmountController.text),
                                                                                gasBill: _newGasBillController.text == "0.0" ? 0 : double.parse(_newGasBillController.text),
                                                                                waterBill: _newWaterBillController.text == "0.0" ? 0 : double.parse(_newWaterBillController.text),
                                                                                utilityBill: _newUtilityController.text == "0.0" ? 0 : double.parse(_newUtilityController.text),
                                                                                arrivalDate: tenent.arrivalDate,
                                                                                flatId: tenent.flatId,
                                                                                id: tenent.id,
                                                                                totalAmount: tenent.totalAmount);
                                                                            await tenantApiService.updateTenant(
                                                                                tenant: updatedTenant,
                                                                                id: id);
                                                                            Get.snackbar("",
                                                                                "",
                                                                                messageText: const Center(
                                                                                    child: Text(
                                                                                  "updated successfully  \n",
                                                                                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                                                                                )),
                                                                                snackPosition: SnackPosition.BOTTOM,
                                                                                duration: const Duration(seconds: 2));

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
                                                    Get.snackbar("", "",
                                                        messageText:
                                                            const Center(
                                                                child: Text(
                                                          "deleted successfully  \n",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(255,
                                                                      0, 0, 0),
                                                              fontSize: 20),
                                                        )),
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        duration:
                                                            const Duration(
                                                                seconds: 1));
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
