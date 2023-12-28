import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/models/incomeExpenseTypeModel.dart';
import 'package:rent_management/shared_data/incomeExpense_provider.dart';
import 'package:velocity_x/velocity_x.dart';

class Income extends StatefulWidget {
  final Function() refresh;
  Income({required this.refresh, super.key});

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  int typeId = 1;
  int? selectedTypeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Income".text.make(),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<IncomeExpenseProvider>(
              builder: (context, typeData, child) {
                List<IncomeExpenseTypeModel> typeList = typeData.typeList;

                return DropdownButtonFormField<int>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    suffix: const Text(
                      '*',
                      style: TextStyle(color: Colors.red),
                    ),
                    labelText: 'Select Income/Expense Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: selectedTypeId,
                  onChanged: (int? value) {
                    setState(() {
                      selectedTypeId = value!;
                    });
                  },
                  items: typeList.map<DropdownMenuItem<int>>(
                      (IncomeExpenseTypeModel type) {
                    return DropdownMenuItem<int>(
                      value: type.id,
                      child: Text(type.name!),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ).p16(),
      ),
    );
  }
}
