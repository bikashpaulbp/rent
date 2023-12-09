import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rent_management/screens/monthly_rent_page.dart';
import '../classes/rent_info.dart';
import '../classes/tenent_info.dart';
import '../db_helper.dart';
import '../screens/dashboard_page.dart';

class RentDataPage extends StatefulWidget {
  const RentDataPage({super.key});

  @override
  State<RentDataPage> createState() => _RentDataPageState();
}

class _RentDataPageState extends State<RentDataPage> {
  late Stream<List<RentInfo>> rentStream = const Stream.empty();
  TenentInfo? tenentInfo;
  List<TenentInfo> tenentList = [];
  List<RentInfo> rentList = [];
  DateTime dateTime = DateTime(2023, 1, 1);
  final format = DateFormat("dd MMM y");
  DateTime rentMonth = DateTime(1990, 1, 1);
  String? date;

  int isPaid = 0;

  @override
  void initState() {
    setState(() {
      _fetchData();
    });

    super.initState();
  }

  Future<void> _fetchData() async {
    rentStream = DBHelper.readRentData().asStream();
    rentList = await DBHelper.readRentData();

    tenentList = await DBHelper.readTenentData();
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
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DateTimeField(
              decoration: InputDecoration(
                  labelText: "select month", icon: Icon(Icons.calendar_month)),
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
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => {
                    if (date != "" && tenentList.isNotEmpty)
                      {
                        for (RentInfo rentInfo in rentList)
                          {rentMonth = format.parse(rentInfo.month)},
                        if (rentMonth.month == dateTime.month)
                          {
                            Get.snackbar("", "",
                                messageText: Center(
                                    child: Text(
                                  "rent already added for selected month\n",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 22, 22),
                                      fontSize: 20),
                                )),
                                snackPosition: SnackPosition.BOTTOM,
                                duration: Duration(seconds: 2))
                          }
                        else
                          {
                            for (var i in tenentList)
                              {
                                tenentInfo = TenentInfo(
                                    // floorID: i.floorID,
                                    // floorName: i.floorName,
                                    flatID: i.flatID,
                                    flatName: i.flatName,
                                    tenentName: i.tenentName,
                                    nidNo: i.nidNo,
                                    birthCertificateNo: i.birthCertificateNo,
                                    mobileNo: i.mobileNo,
                                    emgMobileNo: i.emgMobileNo,
                                    noOfFamilyMem: i.noOfFamilyMem,
                                    rentAmount: i.rentAmount,
                                    gasBill: i.gasBill,
                                    waterBill: i.waterBill,
                                    serviceCharge: i.serviceCharge,
                                    totalAmount: i.totalAmount,
                                    dateOfIn: i.dateOfIn),
                                DBHelper.insertRentData(RentInfo(
                                        // floorID: tenentInfo!.floorID,
                                        // floorName: tenentInfo!.floorName,
                                        flatID: tenentInfo!.flatID,
                                        flatName: tenentInfo!.flatName,
                                        tenentID: tenentInfo?.id ?? 0,
                                        tenentName: tenentInfo!.tenentName,
                                        totalAmount: tenentInfo!.totalAmount,
                                        month: date.toString(),
                                        isPaid: isPaid))
                                    .then((_) => {
                                          setState(() {
                                            _fetchData();
                                          }),
                                        }),
                                Get.to(MonthlyRent()),
                              },
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
                          }
                      }
                    else
                      {
                        Get.snackbar("", "",
                            messageText: Center(
                                child: Text(
                              "please add tenant and select month\n",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 22, 22),
                                  fontSize: 20),
                            )),
                            snackPosition: SnackPosition.BOTTOM,
                            duration: Duration(seconds: 2))
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
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.offAll(Dashboard());
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
        ],
      ),
    );
  }
}
