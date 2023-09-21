import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/classes/deposit.dart';
import 'package:rent_management/classes/rent_info.dart';
import 'package:rent_management/db_helper.dart';
import 'package:rent_management/models/deposit_model.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/models/rent_model.dart';
import 'package:rent_management/models/tenant_model.dart';
import 'package:rent_management/screens/dashboard_page.dart';
import 'package:rent_management/screens/monthly_rent_page.dart';
import 'package:rent_management/services/deposite_service.dart';
import 'package:rent_management/services/rent_service.dart';
import 'package:rent_management/shared_data/rent_data.dart';

// ignore: must_be_immutable
class DepositDataPage extends StatefulWidget {
  // int rentIDIndex;
  // List<RentInfo> rentList = [];
  final Function() refresh;
  int rentID;
  DepositDataPage({required this.rentID, required this.refresh, super.key});

  @override
  State<DepositDataPage> createState() => _DepositDataPageState();
}

class _DepositDataPageState extends State<DepositDataPage> {
  var rentMonthTextController = TextEditingController();
  var tenantNameTextControlller = TextEditingController();
  var flatNameTextControlller = TextEditingController();
  var totalAmountTextControlller = TextEditingController();
  var dueAmountTextControlller = TextEditingController();
  final TextEditingController depositAmountTextControlller =
      TextEditingController();

  DateTime? date;

  List<DepositeModel> finalDepositList = [];
  List<TenantModel> finalTenantList = [];
  List<FlatModel> finalFlatList = [];
  List<RentModel> finalRentList = [];

  double? dueAmount;
  double totalDeposit = 0.0;
  RentApiService rentApiService = RentApiService();
  DepositeApiService depositeApiService = DepositeApiService();

  @override
  void initState() {
    _fetchDeposite();
    super.initState();
  }

  Future<void> _fetchDeposite() async {
    List<DepositeModel> depositList =
        await depositeApiService.getAllDeposites();
    finalDepositList = depositList;
    for (var deposites in finalDepositList) {
      totalDeposit = totalDeposit + deposites.depositeAmount!;
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
        title: const Text(
          'Deposit',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: Colors.yellow,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Consumer<RentData>(
              builder: (context, rentData, child) {
                RentModel? rentInfo =
                    rentData.rentList.firstWhere((e) => e.id == widget.rentID);

                rentMonthTextController.text = rentInfo.rentMonth.toString();

                totalAmountTextControlller.text =
                    rentInfo.totalAmount.toString();
                dueAmountTextControlller.text =
                    (rentInfo.totalAmount! - totalDeposit).toString();
                return Container(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: totalAmountTextControlller,
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: 'Total Amount',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: dueAmountTextControlller,
                                enabled: false,
                                decoration: InputDecoration(
                                  labelText: 'Due Amount',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: depositAmountTextControlller,
                                decoration: InputDecoration(
                                  labelText: 'Deposit',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
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
                                  if (depositAmountTextControlller
                                      .text.isNotEmpty)
                                    {
                                      await depositeApiService.createDeposite( 
                                          DepositeModel(
                                              totalAmount: rentInfo.totalAmount,
                                              depositeAmount: double.parse(
                                                  depositAmountTextControlller
                                                      .text),
                                              dueAmount: rentInfo.totalAmount! -
                                                  totalDeposit,
                                              depositeDate: date,
                                              rentId: rentInfo.id)),
                                      Get.back(),
                                      Get.snackbar("", "",
                                          messageText: const Center(
                                              child: Text(
                                            "saved successfully\n",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
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
                                            "provide deposit amount\n",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 245, 50, 50),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
