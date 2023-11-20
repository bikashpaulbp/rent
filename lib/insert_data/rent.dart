import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/models/rent_model.dart';
import 'package:rent_management/models/tenant_model.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/all_rent.dart';
import 'package:rent_management/screens/login_screen.dart';
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
  FlatModel? flatModel;
  List<TenantModel>? tenentList;
  List<RentModel> allRentList = [];
  List<RentModel> rentList = [];
  List<FlatModel> allFlatList = [];
  List<FlatModel> flatList = [];
  DateTime dateTime = DateTime(2023, 1, 1);
  final format = DateFormat("dd MMM y");
  DateTime? rentMonth;
  DateTime? rentYear;
  DateTime? rentDate;
  DateTime? date;
  String? formattedDate;
  bool isPaid = false;

  RentApiService rentApiService = RentApiService();
  TenantApiService tenantApiService = TenantApiService();
  FlatApiService flatApiService = FlatApiService();
  DepositeApiService depositeApiService = DepositeApiService();

  bool isActive = true;
  UserModel user = UserModel();
  DateTime? arrivalDate;
  DateTime? rentAmountChangeDate;
  AuthStateManager authStateManager = AuthStateManager();
  UserModel? loggedInUser = UserModel();
  bool isLoading = false;
  int? buildingId;
  int? userId;
  @override
  void initState() {
    getUser();
    getBuildingId();
    setState(() {
      _fetchRentData();
    });
    super.initState();
  }

  Future<void> getUser() async {
    user = (await authStateManager.getLoggedInUser())!;
    userId = user.id;
  }

  Future<void> getBuildingId() async {
    buildingId = await authStateManager.getBuildingId();
  }

  Future<void> _fetchRentData() async {
    allFlatList = await flatApiService.getAllFlats();
    rentStream = rentApiService.getAllRents().asStream();
    allRentList = await rentApiService.getAllRents();
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
                  onPressed: () async {
                    await _fetchRentData();
                    await getBuildingId();
                    flatList = allFlatList
                        .where((element) => element.buildingId == buildingId)
                        .toList();
                    rentList = allRentList
                        .where((element) => element.buildingId == buildingId)
                        .toList();

                    if (date != null && flatList.isNotEmpty) {
                      for (RentModel rent in rentList) {
                        formattedDate =
                            DateFormat('dd MMM y').format(rent.rentMonth!);
                        rentMonth =
                            DateFormat('dd MMM y').parse(formattedDate!);
                        rentYear = DateFormat('dd MMM y').parse(formattedDate!);

                        if (rentMonth!.month == dateTime.month &&
                            rentYear!.year == dateTime.year) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Rent already added for the selected month"),
                          ));
                          return;
                        }
                      }

                      for (var i in flatList) {
                        getBuildingId();
                        getUser();
                        flatModel = FlatModel(
                          id: i.id,
                          name: i.name,
                          floorId: i.floorId,
                          buildingId: i.buildingId,
                          userId: i.userId,
                          tenantId: i.tenantId,
                          bedroom: i.bedroom,
                          washroom: i.washroom,
                          flatSide: i.flatSide,
                          flatSize: i.flatSize,
                          isActive: i.isActive,
                          masterbedRoom: i.bedroom,
                          gasBill: i.gasBill,
                          serviceCharge: i.serviceCharge,
                          waterBill: i.waterBill,
                          rentAmount: i.rentAmount,
                        );

                        await rentApiService.createRent(RentModel(
                          userId: flatModel!.userId,
                          buildingId: flatModel!.buildingId,
                          flatId: flatModel!.id,
                          tenantId: flatModel!.tenantId,
                          dueAmount: 0,
                          isPrinted: false,
                          rentAmount: flatModel!.rentAmount,
                          serviceCharge: flatModel!.serviceCharge,
                          gasBill: flatModel!.gasBill,
                          waterBill: flatModel!.waterBill,
                          totalAmount: flatModel!.rentAmount! +
                              flatModel!.serviceCharge! +
                              flatModel!.gasBill! +
                              flatModel!.waterBill!,
                          rentMonth: date,
                          isPaid: isPaid,
                        ));
                      }

                      await widget.refresh();
                      await _fetchRentData();
                      Get.offAll(() => AllRent());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Saved successfully")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please select a month")),
                      );
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
                    Get.offAll(() => AllRent());
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
