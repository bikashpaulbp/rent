import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:rent_management/classes/tenent_info.dart';
import 'package:rent_management/db_helper.dart';
import 'package:rent_management/insert_data/tenent.dart';

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
  final _newServiceChargeController = TextEditingController();

  late Stream<List<TenentInfo>> tenentStream = const Stream.empty();

  @override
  void initState() {
    _fetchTenentData();
    setState(() {});

    super.initState();
  }

  Future<void> _fetchTenentData() async {
    tenentStream = DBHelper.readTenentData().asStream();
    List<TenentInfo> tenantList = await DBHelper.readTenentData();

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
            Get.offAll(const TenentDataPage());
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
                      child: StreamBuilder<List<TenentInfo>>(
                        stream: tenentStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<TenentInfo>> snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data!.isNotEmpty) {
                            List<TenentInfo> tenentList = snapshot.data!;

                            return ListView.builder(
                              itemCount: tenentList.length,
                              itemBuilder: (BuildContext context, int index) {
                                TenentInfo tenent = tenentList[index];

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
                                                  // Padding(
                                                  //   padding:
                                                  //       const EdgeInsets.all(5.0),
                                                  //   child: Text(
                                                  //     'ID: ${tenent.id}',
                                                  //     style: TextStyle(
                                                  //       color:
                                                  //           const Color.fromARGB(
                                                  //               255, 0, 0, 0),
                                                  //       fontSize: 16,
                                                  //       fontWeight:
                                                  //           FontWeight.bold,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      'Tenent Name: ${tenent.tenentName}',
                                                      style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  // Padding(
                                                  //   padding:
                                                  //       const EdgeInsets.all(5.0),
                                                  //   child: Text(
                                                  //     'Floor Name: ${tenent.floorName}',
                                                  //     style: TextStyle(
                                                  //       color:
                                                  //           const Color.fromARGB(
                                                  //               255, 0, 0, 0),
                                                  //       fontSize: 16,
                                                  //       fontWeight:
                                                  //           FontWeight.bold,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      'Flat Name: ${tenent.flatName}',
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
                                                      'Date of In: ${tenent.dateOfIn.toString()}',
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
                                                      'NID : ${tenent.nidNo == 0 ? "" : tenent.nidNo.toString()}',
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
                                                      'Passport : ${tenent.passportNo == "" ? "" : tenent.passportNo.toString()}',
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
                                                      'BirthCertificate: ${tenent.birthCertificateNo == 0 ? "" : tenent.birthCertificateNo.toString()}',
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
                                                      'Mobile: ${tenent.mobileNo == 0 ? "" : tenent.mobileNo.toString()}',
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
                                                      'Emergency Mobile: ${tenent.emgMobileNo == 0 ? "" : tenent.emgMobileNo.toString()}',
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
                                                      'Family Members: ${tenent.noOfFamilyMem == 0 ? "" : tenent.noOfFamilyMem.toString()}',
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
                                                      'Rent Amount: ${tenent.rentAmount.toString()}',
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
                                                      'Gas Bill: ${tenent.gasBill == 0 ? "" : tenent.gasBill.toString()}',
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
                                                      'Water Bill: ${tenent.waterBill == 0 ? "" : tenent.waterBill.toString()}',
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
                                                      'Service Charge: ${tenent.serviceCharge == 0 ? "" : tenent.serviceCharge.toString()}',
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
                                                      'Total Amount: ${tenent.totalAmount.toString()}',
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
                                                            .text =
                                                        tenent.tenentName;
                                                    _newNidNoController.text =
                                                        tenent.nidNo.toString();
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
                                                        tenent.noOfFamilyMem
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
                                                    _newServiceChargeController
                                                            .text =
                                                        tenent.serviceCharge
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
                                                                                  controller: _newServiceChargeController,
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
                                                                            TenentInfo updatedTenent = TenentInfo(
                                                                                id: tenent.id,
                                                                                tenentName: _newTenentNameController.text,
                                                                                // floorID: tenent.floorID,
                                                                                // floorName: tenent.floorName,
                                                                                flatID: tenent.flatID,
                                                                                flatName: tenent.flatName,
                                                                                nidNo: int.parse(_newNidNoController.text),
                                                                                passportNo: _newPassportNoController.text,
                                                                                birthCertificateNo: int.parse(_newBirthCertificateNoController.text),
                                                                                mobileNo: int.parse(_newMobileNoController.text),
                                                                                emgMobileNo: int.parse(_newEmgMobileNoController.text),
                                                                                noOfFamilyMem: int.parse(_newNoOfFamilyMemController.text),
                                                                                rentAmount: double.parse(_newRentAmountController.text),
                                                                                gasBill: double.parse(_newGasBillController.text),
                                                                                waterBill: double.parse(_newWaterBillController.text),
                                                                                serviceCharge: double.parse(_newServiceChargeController.text),
                                                                                totalAmount: double.parse(_newRentAmountController.text) + double.parse(_newGasBillController.text) + double.parse(_newWaterBillController.text) + double.parse(_newServiceChargeController.text),
                                                                                dateOfIn: tenent.dateOfIn);
                                                                            await DBHelper.updateTenent(updatedTenent);
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
                                                                              _fetchTenentData();

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
                                                    int? id = tenent.id;
                                                    await DBHelper.deleteTenent(
                                                        id);
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
                                                      _fetchTenentData();
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
                                child: Text('no tenents available.'));
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
