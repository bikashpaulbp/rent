// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:rent_management/classes/deposit.dart';
// import 'package:rent_management/db_helper.dart';
// import 'package:rent_management/models/deposit_model.dart';
// import 'package:rent_management/models/flat_model.dart';
// import 'package:rent_management/models/rent_model.dart';
// import 'package:rent_management/models/tenant_model.dart';
// import 'package:rent_management/services/deposite_service.dart';
// import 'package:rent_management/services/flat_service.dart';
// import 'package:rent_management/services/rent_service.dart';
// import 'package:rent_management/services/tenant_service.dart';

// class DepositPage extends StatefulWidget {
//   const DepositPage({super.key});

//   @override
//   State<DepositPage> createState() => _DepositPageState();
// }

// class _DepositPageState extends State<DepositPage> {
//   List<DepositeModel> depositList = [];
//   List<RentModel> rentList = [];
//   List<TenantModel> tenantList = [];
//   List<FlatModel> flatList = [];
//   int? no = 0;

//   DepositeApiService depositeApiService = DepositeApiService();
//   TenantApiService tenantApiService = TenantApiService();
//   RentApiService rentApiService = RentApiService();
//   FlatApiService flatApiService = FlatApiService();

//   @override
//   void initState() {
//      _fetchData();
//     super.initState();
   
//   }

//   Future _fetchData() async {
//     depositList = await depositeApiService.getAllDeposites();
//     tenantList = await tenantApiService.getAllTenants();
//     rentList = await rentApiService.getAllRents();
//     flatList = await flatApiService.getAllFlats();

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue.shade300,
//         title: const Center(child: Text('Deposit History')),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columns: [
//                   DataColumn(
//                     label: Text('No.'),
//                   ),
//                   DataColumn(
//                     label: Text('Rent Month'),
//                   ),
//                   DataColumn(
//                     label: Text('Flat Name'),
//                   ),
//                   DataColumn(
//                     label: Text('Tenant Name'),
//                   ),
//                   DataColumn(
//                     label: Text('Total Amount'),
//                   ),
//                   DataColumn(
//                     label: Text('Deposit Amount'),
//                   ),
//                   DataColumn(
//                     label: Text('Due Amount'),
//                   ),
//                   DataColumn(
//                     label: Text('Deposit Date'),
//                   ),
//                 ],
//                 rows: depositList.map((deposit) {
//                   no = no! + 1;
//                   DateTime? rentMonth = rentList
//                       .firstWhere((element) => element.id == deposit.rentId)
//                       .rentMonth;
//                   int? tenantId = rentList
//                       .firstWhere((element) => element.id == deposit.rentId)
//                       .tenantId;
//                   int? flatId = tenantList
//                       .firstWhere((element) => element.id == tenantId)
//                       .flatId;
//                   String? flatName = flatList
//                       .firstWhere((element) => element.id == flatId)
//                       .name;
//                   String? tenantName = tenantList
//                       .firstWhere((tenant) => tenant.id == tenantId)
//                       .name;

//                   return DataRow(cells: [
//                     DataCell(Text(no.toString())),
//                     DataCell(Text(DateFormat('MMM y').format(rentMonth!))),
//                     DataCell(Text(flatName.toString())),
//                     DataCell(Text(tenantName.toString())),
//                     DataCell(Text(deposit.totalAmount.toString())),
//                     DataCell(Text(deposit.depositeAmount.toString())),
//                     DataCell(Text(deposit.dueAmount.toString())),
//                     DataCell(Text(
//                         DateFormat('dd MMM y').format(deposit.depositeDate!))),
//                   ]);
//                 }).toList(),
//               ),
//             )),
//       ),
//     );
//   }
// }
