import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/models/rent_model.dart';
import 'package:rent_management/models/tenant_model.dart';
import 'package:rent_management/services/deposite_service.dart';
import 'package:rent_management/services/flat_service.dart';
import 'package:rent_management/services/rent_service.dart';
import 'package:rent_management/services/tenant_service.dart';
import '../screens/dashboard_page.dart';

// ignore: must_be_immutable
class RentDataPage extends StatefulWidget {
  final Function() refresh;
  const RentDataPage({super.key, required this.refresh});

  @override
  State<RentDataPage> createState() => _RentDataPageState();
}

class _RentDataPageState extends State<RentDataPage> {
  late Stream<List<RentModel>> rentStream = const Stream.empty();
  TenantModel? tenantModel;
  List<TenantModel>? tenentList;
  List<RentModel> rentList = [];
  List<FlatModel> flatList = [];
  DateTime dateTime = DateTime(2023, 1, 1);
  final format = DateFormat("dd MMM y");
  int? rentMonth;
  int? rentYear;
  DateTime rentDate = DateTime(1990, 1, 1);
  DateTime? date;

  bool isPaid = false;

  RentApiService rentApiService = RentApiService();
  TenantApiService tenantApiService = TenantApiService();
  FlatApiService flatApiService = FlatApiService();
  DepositeApiService depositeApiService = DepositeApiService();

  @override
  void initState() {
    super.initState();
    setState(() {
      _fetchRentData();
    });
  }

  Future<void> _fetchRentData() async {
    tenentList = await tenantApiService.getAllTenants();
    rentStream = rentApiService.getAllRents().asStream();
    rentList = await rentApiService.getAllRents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Month of Rent',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DateTimeField(
              decoration: const InputDecoration(
                  labelText: "select month", icon: Icon(Icons.calendar_month)),
              onChanged: (newValue) {
                setState(() {
                  dateTime = newValue!;
                  date = dateTime;
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
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async => {
                    if (date != null && tenentList!.isNotEmpty)
                      {
                        for (RentModel rent in rentList)
                          {
                            rentDate = DateTime.parse(
                                DateFormat('dd MMM y').format(rent.rentMonth!)),
                            rentMonth = rentDate.month,
                            rentYear = rentDate.year,
                          },
                        if (rentMonth == dateTime.month &&
                            rentYear == dateTime.year)
                          {
                            Get.snackbar("", "",
                                messageText: const Center(
                                    child: Text(
                                  "rent already added for selected month\n",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 22, 22),
                                      fontSize: 20),
                                )),
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 2))
                          }
                        else
                          {
                            for (var i in tenentList!)
                              {
                                tenantModel = TenantModel(
                                  id: i.id,
                                  flatId: i.flatId,
                                  rentAmount: i.rentAmount,
                                  totalAmount: i.totalAmount,
                                ),
                                await rentApiService.createRent(RentModel(
                                    flatId: tenantModel!.flatId,
                                    tenantId: tenantModel?.id,
                                    totalAmount: tenantModel!.totalAmount,
                                    rentMonth: date,
                                    isPaid: isPaid)),
                                await widget.refresh(),
                                await _fetchRentData(),
                                Get.back(),
                              },
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
                          }
                      }
                    else
                      {
                        print(tenentList!.length),
                        print(date),
                        Get.snackbar("", "",
                            messageText: const Center(
                                child: Text(
                              "please add tenant and select month\n",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 22, 22),
                                  fontSize: 20),
                            )),
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 2))
                      }
                  },
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
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(const Dashboard());
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
          ),
        ],
      ),
    );
  }
}
