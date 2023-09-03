import 'package:flutter/material.dart';
import 'package:rent_management/classes/deposit.dart';
import 'package:rent_management/db_helper.dart';

class DepositPage extends StatefulWidget {
  const DepositPage({super.key});

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  List<Deposit> depositList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future _fetchData() async {
    depositList = await DBHelper.readDepositData();
    setState(() {});
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
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text('No'),
                  ),
                  DataColumn(
                    label: Text('Month'),
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
                    label: Text('Date'),
                  ),
                ],
                rows: depositList.map((deposit) {
                  return DataRow(cells: [
                    DataCell(Text(deposit.id.toString())),
                    DataCell(Text(deposit.rentMonth)),
                    DataCell(Text(deposit.flatName)),
                    DataCell(Text(deposit.tenantName)),
                    DataCell(Text(deposit.totalAmount.toString())),
                    DataCell(Text(deposit.depositAmount.toString())),
                    DataCell(Text(deposit.dueAmount.toString())),
                    DataCell(Text(deposit.date)),
                  ]);
                }).toList(),
              ),
            )),
      ),
    );
  }
}
