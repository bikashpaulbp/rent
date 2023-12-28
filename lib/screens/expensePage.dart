import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rent_management/insert_data/expense.dart';
import 'package:rent_management/insert_data/income.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  @override
  void initState() {
    super.initState();
  }

  refresh() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 66, 129, 247),
          child: IconButton(
            onPressed: () {
              Get.to(() => Expense(refresh: refresh));
            },
            icon: const Icon(Icons.add),
            color: const Color.fromARGB(255, 255, 255, 255),
          )),
    );
  }
}
