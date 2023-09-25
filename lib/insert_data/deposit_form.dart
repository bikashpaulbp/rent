import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/models/deposit_model.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/models/rent_model.dart';
import 'package:rent_management/models/tenant_model.dart';
import 'package:rent_management/screens/dashboard_page.dart';
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

  DateTime date = DateTime.now();

  List<DepositeModel> finalDepositList = [];
  List<TenantModel> finalTenantList = [];
  List<FlatModel> finalFlatList = [];
  List<RentModel> finalRentList = [];
  List<DepositeModel> totalDepositeList = [];
  List<DepositeModel> depositList = [];
  double? dueAmount = 0;
  double? totalDeposit = 0;
  // double? finalTotalDeposit = 0;
  RentApiService rentApiService = RentApiService();
  DepositeApiService depositeApiService = DepositeApiService();

  @override
  void initState() {
    super.initState();
    _fetchDeposite();
  }

  Future<void> _fetchDeposite() async {
    List<RentModel> rentList = await rentApiService.getAllRents();
    // depositList = await DBHelper.readDepositData();
    RentModel rentInfo = rentList.firstWhere((e) => e.id == widget.rentID);
    depositList = await depositeApiService.getAllDeposites();

    totalDepositeList =
        depositList.where((e) => e.rentId == widget.rentID).toList();
    for (var deposites in totalDepositeList) {
      totalDeposit = totalDeposit! + deposites.depositeAmount!;
    }

    dueAmount = rentInfo.totalAmount! - totalDeposit!;

    dueAmountTextControlller.text = dueAmount.toString();
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
                                      // depositList = await depositeApiService
                                      //     .getAllDeposites(),
                                      // totalDepositeList = depositList
                                      //     .where(
                                      //         (e) => e.rentId == widget.rentID)
                                      //     .toList(),
                                      // for (var deposites in totalDepositeList)
                                      //   {
                                      //     totalDeposit = totalDeposit! +
                                      //         deposites.depositeAmount!,
                                      //   },
                                      await depositeApiService.createDeposite(
                                          DepositeModel(
                                              totalAmount: rentInfo.totalAmount,
                                              depositeAmount: double.parse(
                                                  depositAmountTextControlller
                                                      .text),
                                              dueAmount: rentInfo.totalAmount! -
                                                  (totalDeposit! +
                                                      double.parse(
                                                          depositAmountTextControlller
                                                              .text)),
                                              depositeDate: date,
                                              rentId: rentInfo.id)),
                                      setState(() {
                                        _fetchDeposite();
                                      }),
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
