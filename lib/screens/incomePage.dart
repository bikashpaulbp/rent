import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rent_management/insert_data/expense.dart';
import 'package:rent_management/insert_data/income.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
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
              Get.to(() => Income(refresh: refresh));
            },
            icon: const Icon(Icons.add),
            color: const Color.fromARGB(255, 255, 255, 255),
          )),
    );
  }
}
