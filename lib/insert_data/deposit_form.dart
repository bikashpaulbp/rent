import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/models/deposit_model.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/models/rent_model.dart';
import 'package:rent_management/models/tenant_model.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/all_rent.dart';
import 'package:rent_management/screens/dashboard_page.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/services/deposite_service.dart';
import 'package:rent_management/services/flat_service.dart';
import 'package:rent_management/services/rent_service.dart';
import 'package:rent_management/shared_data/deposit_data.dart';
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
  DateTime? depositeDate;
  final format = DateFormat("dd MMM y");
  RentModel? rents;
  RentModel? rentInfo;
  List<DepositeModel> finalDepositList = [];
  List<TenantModel> finalTenantList = [];
  List<FlatModel> finalFlatList = [];
  List<RentModel> finalRentList = [];
  List<DepositeModel> totalDepositeList = [];
  List<DepositeModel> depositList = [];
  int? dueAmount = 0;
  int? totalDeposit = 0;
  int dueAmountForIsPaid = 0;
  bool isDueAmount = false;
  // double? finalTotalDeposit = 0;
  RentModel? updatedRent;
  RentApiService rentApiService = RentApiService();
  FlatApiService flatApiService = FlatApiService();
  DepositeApiService depositeApiService = DepositeApiService();
  List<FlatModel> flatList = [];
  AuthStateManager authStateManager = AuthStateManager();
  UserModel? loggedInUser = UserModel();
  UserModel user = UserModel();
  bool isLoading = false;
  int? buildingId;
  int? userId;
  int? flatId;

  @override
  void initState() {
    _fetchDeposite();
    getUser();
    getBuildingId();
    super.initState();
  }

  Future<void> getUser() async {
    user = (await authStateManager.getLoggedInUser())!;
    userId = user.id;
  }

  Future<void> getBuildingId() async {
    buildingId = await authStateManager.getBuildingId();
  }

  Future<void> _fetchDeposite() async {
    if (!mounted) {
      return;
    }

    try {
      depositList = await Provider.of<DepositData>(context, listen: false)
          .returnDepositList();
      List<RentModel> rentList =
          await Provider.of<RentData>(context, listen: false).returnRentList();
      totalDepositeList =
          depositList.where((e) => e.rentId == widget.rentID).toList();

      rents = rentList.firstWhere((e) => e.id == widget.rentID);
      for (var deposites in totalDepositeList) {
        totalDeposit = totalDeposit! + deposites.depositeAmount!;
      }
      dueAmount = rents!.totalAmount! - totalDeposit!;

      dueAmountTextControlller.text = dueAmount.toString();
    } catch (_) {}
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
                rentData.getRentList();

                if (rentData.rentList.isNotEmpty) {
                  try {
                    rentInfo = rentData.rentList
                        .firstWhere((e) => e.id == widget.rentID);
                  } catch (_) {}

                  rentMonthTextController.text = rentInfo!.rentMonth.toString();

                  totalAmountTextControlller.text =
                      rentInfo!.totalAmount.toString();
                }

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
                          DateTimeField(
                            decoration: InputDecoration(
                                suffix: const Text(
                                  '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                                labelText: 'deposit date',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                icon: const Icon(Icons.calendar_month)),
                            onChanged: (newValue) {
                              setState(() {
                                depositeDate = newValue!;
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
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              isLoading == true
                                  ? Center(child: CircularProgressIndicator())
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
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
                                        // await _fetchDeposite(),
                                        setState(() {
                                          isLoading = true;
                                        }),
                                        await getUser(),
                                        await getBuildingId(),
                                        if (depositAmountTextControlller
                                            .text.isNotEmpty)
                                          {
                                            await depositeApiService
                                                .createDeposite(DepositeModel(
                                                    buildingId: buildingId,
                                                    flatId: rentInfo!.flatId,
                                                    tenantId:
                                                        rentInfo!.tenantId,
                                                    userId: rentInfo!.userId,
                                                    totalAmount:
                                                        rentInfo!.totalAmount,
                                                    depositeAmount: int.parse(
                                                        depositAmountTextControlller
                                                            .text),
                                                    dueAmount: rentInfo!
                                                            .totalAmount! -
                                                        (totalDeposit! +
                                                            int.parse(
                                                                depositAmountTextControlller
                                                                    .text)),
                                                    tranDate:
                                                        depositeDate ?? date,
                                                    rentId: rentInfo!.id)),
                                            dueAmountForIsPaid = rentInfo!
                                                    .totalAmount! -
                                                (totalDeposit! +
                                                    int.parse(
                                                        depositAmountTextControlller
                                                            .text)),
                                            isDueAmount =
                                                dueAmountForIsPaid == 0
                                                    ? true
                                                    : false,
                                            updatedRent = RentModel(
                                                id: rentInfo!.id,
                                                buildingId:
                                                    rentInfo!.buildingId,
                                                isPrinted: rentInfo!.isPrinted,
                                                dueAmount: rentInfo!
                                                        .totalAmount! -
                                                    (totalDeposit! +
                                                        int.parse(
                                                            depositAmountTextControlller
                                                                .text)),
                                                gasBill: rentInfo!.gasBill,
                                                // reciptNo: rentInfo!.reciptNo,
                                                rentAmount:
                                                    rentInfo!.rentAmount,
                                                serviceCharge:
                                                    rentInfo!.serviceCharge,
                                                userId: rentInfo!.userId,
                                                waterBill: rentInfo!.waterBill,
                                                flatId: rentInfo!.flatId,
                                                tenantId: rentInfo!.tenantId,
                                                totalAmount:
                                                    rentInfo!.totalAmount,
                                                rentMonth: rentInfo!.rentMonth,
                                                isPaid: isDueAmount),
                                            await rentApiService.updateRent(
                                                id: widget.rentID,
                                                rent: updatedRent!),
                                            widget.refresh,
                                            setState(() {
                                              _fetchDeposite();
                                            }),
                                            Get.offAll(() => Dashboard()),
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "saved successfully")))
                                          }
                                        else
                                          {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "provide deposit amount")))
                                          },
                                        setState(() {
                                          isLoading = false;
                                        }),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
