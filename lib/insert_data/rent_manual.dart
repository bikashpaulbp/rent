import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/classes/rent_info.dart';

import '../classes/flat_info.dart';
import '../classes/tenent_info.dart';
import '../db_helper.dart';
import '../screens/dashboard_page.dart';
import '../screens/monthly_rent_page.dart';
import '../shared_data/flat_data.dart';
import '../shared_data/tenent_data.dart';

class RentManual extends StatefulWidget {
  const RentManual({super.key});

  @override
  State<RentManual> createState() => _RentManualState();
}

class _RentManualState extends State<RentManual> {
  int? selectedFlatId;
  String? selectedFlatName;
  int? selectedTenantId;
  String? selectedTenantName;

  final TextEditingController _totalAmountController = TextEditingController();

  late Stream<List<RentInfo>> rentStream = const Stream.empty();
  DateTime dateTime = DateTime(2023, 1, 1);
  final format = DateFormat("dd MMM y");
  String? date;
  int isPaid = 0;

  @override
  void initState() {
    _fetchRentData();

    super.initState();
  }

  Future<void> _fetchRentData() async {
    rentStream = DBHelper.readRentData().asStream();
  }

  @override
  void dispose() {
    _totalAmountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Rent Manually',
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
                      Consumer<TenantData>(
                        builder: (context, tenantData, child) {
                          List<TenentInfo> tenantList = tenantData.tenantList;

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
                                selectedTenantName = tenantList
                                    .firstWhere((tenant) =>
                                        tenant.id == selectedTenantId)
                                    .tenentName;
                              });
                            },
                            items: tenantList.map<DropdownMenuItem<int>>(
                                (TenentInfo tenant) {
                              return DropdownMenuItem<int>(
                                value: tenant.id,
                                child: Text(tenant.tenentName),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _totalAmountController,
                        decoration: InputDecoration(
                          suffix: const Text(
                            '*',
                            style: TextStyle(color: Colors.red),
                          ),
                          labelText: 'Total Amount',
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
                            labelText: 'select month of rent',
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
                          if (date != "" &&
                              selectedFlatId != null &&
                              selectedFlatName != "" &&
                              selectedTenantId != null &&
                              selectedTenantName != "" &&
                              date != null)
                            {
                              await DBHelper.insertRentData(RentInfo(
                                  flatID: selectedFlatId!,
                                  flatName: selectedFlatName!,
                                  tenentID: selectedTenantId!,
                                  tenentName: selectedTenantName!,
                                  month: date.toString(),
                                  totalAmount:
                                      double.parse(_totalAmountController.text),
                                  isPaid: isPaid)),
                              setState(() {
                                _fetchRentData();

                                _totalAmountController.text = "";

                                date = "";

                                selectedFlatName = "";
                                selectedFlatId = null;
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
                              Get.to(const MonthlyRent()),
                            }
                          else
                            {
                              Get.snackbar("", "",
                                  messageText: const Center(
                                      child: Text(
                                    "please fill up all * marked field\n",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 255, 22, 22),
                                        fontSize: 20),
                                  )),
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 2))
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
