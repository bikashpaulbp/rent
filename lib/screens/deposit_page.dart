import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rent_management/models/deposit_model.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/models/rent_model.dart';
import 'package:rent_management/models/tenant_model.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/services/deposite_service.dart';
import 'package:rent_management/services/flat_service.dart';
import 'package:rent_management/services/rent_service.dart';
import 'package:rent_management/services/tenant_service.dart';
import 'package:rxdart/rxdart.dart';

class DepositPage extends StatefulWidget {
  const DepositPage({super.key});

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  Stream<List<DepositeModel>> depositList = const Stream.empty();
  Stream<List<RentModel>> rentList = const Stream.empty();
  Stream<List<TenantModel>> tenantList = const Stream.empty();
  Stream<List<FlatModel>> flatList = const Stream.empty();
  int? no = 0;

  DepositeApiService depositeApiService = DepositeApiService();

  TenantApiService tenantApiService = TenantApiService();
  RentApiService rentApiService = RentApiService();
  FlatApiService flatApiService = FlatApiService();
  UserModel user = UserModel();
  DateTime? arrivalDate;
  DateTime? rentAmountChangeDate;
  AuthStateManager authStateManager = AuthStateManager();
  bool isLoading = false;
  int? buildingId;
  int? userId;
  DateTime? rentMonth;
  int? tenantId;
  String? flatName;
  String? tenantName;
  @override
  void initState() {
    getUser();
    getBuildingId();
    _fetchData();
    super.initState();
  }

  Future<void> getUser() async {
    user = (await authStateManager.getLoggedInUser())!;
    userId = user.id;
  }

  Future<void> getBuildingId() async {
    buildingId = await authStateManager.getBuildingId();
  }

  Future<void> _fetchData() async {
    depositList = depositeApiService.getAllDeposites().asStream();
    tenantList = tenantApiService.getAllTenants().asStream();
    rentList = rentApiService.getAllRents().asStream();
    flatList = flatApiService.getAllFlats().asStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade300,
        title: const Center(child: Text('Deposit History')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: StreamBuilder<List<dynamic>>(
              stream: CombineLatestStream.list(
                [depositList, tenantList, flatList, rentList],
              ),
              builder: (context, snapshot) {
                getBuildingId();
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<DepositeModel> deposits = snapshot.data?[0] ?? [];
                List<TenantModel> tenants = snapshot.data?[1] ?? [];
                List<FlatModel> flats = snapshot.data?[2] ?? [];
                List<RentModel> rents = snapshot.data?[3] ?? [];
                List<DepositeModel> depositsList = deposits
                    .where(
                        (e) => e.buildingId == buildingId && e.userId == userId)
                    .toList();

                return DataTable(
                  columns: const [
                    DataColumn(
                      label: Text('No.'),
                    ),
                    DataColumn(
                      label: Text('Rent Month'),
                    ),
                    DataColumn(
                      label: Text('Flat Name'),
                    ),
                    DataColumn(
                      label: Text('Tenant Name'),
                    ),
                    DataColumn(
                      label: Text('Total Amount'),
                    ),
                    DataColumn(
                      label: Text('Deposit Amount'),
                    ),
                    DataColumn(
                      label: Text('Due Amount'),
                    ),
                    DataColumn(
                      label: Text('Deposit Date'),
                    ),
                  ],
                  rows: depositsList.map((deposit) {
                    no = no! + 1;

                    try {
                      rentMonth = rents
                          .firstWhere((element) =>
                              element.id == deposit.rentId &&
                              element.buildingId == buildingId)
                          .rentMonth;
                      //     ??
                      // DateTime.now();
                    } catch (_) {}

                    try {
                      tenantId = rents
                          .firstWhere((element) =>
                              element.id == deposit.rentId &&
                              element.buildingId == buildingId)
                          .tenantId;
                    } catch (_) {}

                    // int? flatId = tenantList
                    //     .firstWhere((element) => element.id == tenantId && element.buildingId == buildingId)
                    //     .;
                    try {
                      flatName = flats
                          .firstWhere((element) =>
                              element.tenantId == tenantId &&
                              element.buildingId == buildingId)
                          .name;
                    } catch (_) {}

                    try {
                      tenantName = tenants
                          .firstWhere((tenant) =>
                              tenant.id == tenantId &&
                              tenant.buildingId == buildingId)
                          .name;
                    } catch (_) {}

                    return DataRow(cells: [
                      DataCell(Text(no.toString())),
                      DataCell(Text(DateFormat('MMM y').format(rentMonth!))),
                      DataCell(Text(flatName.toString())),
                      DataCell(Text(tenantName.toString())),
                      DataCell(Text(deposit.totalAmount.toString())),
                      DataCell(Text(deposit.depositeAmount.toString())),
                      DataCell(Text(deposit.dueAmount.toString())),
                      DataCell(
                        Text(DateFormat('dd MMM y').format(deposit.tranDate!)),
                      ),
                    ]);
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
