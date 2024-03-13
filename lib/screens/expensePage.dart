import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rent_management/insert_data/expense.dart';
import 'package:rent_management/insert_data/income.dart';
import 'package:rent_management/models/IncomeExpenseTransaction.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/services/incomeExpenseTran_service.dart';
import 'package:rent_management/shared_data/incomeExpenseTran_provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  IncomeExpenseTransactionApiService expenseApi =
      IncomeExpenseTransactionApiService();
  AuthStateManager authStateManager = AuthStateManager();
  UserModel? loggedInUser = UserModel();
  int? buildingId;
  int? userId;
  int? year;
  int? month;
  DateTime? selectedDate;

  double? totalExpense = 0.0;
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    final expenseProvider =
        Provider.of<IncomeExpenseTransactionProvider>(context, listen: false);
    expenseProvider.getIncomeExpenseTransactionList();
    // expenseProvider.calTotal();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 66, 129, 247),
          child: IconButton(
            onPressed: () {
              Get.to(() => Expense());
            },
            icon: const Icon(Icons.add),
            color: const Color.fromARGB(255, 255, 255, 255),
          )),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Expense',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 78, 78, 78),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                selectedDate != null
                    ? IconButton(
                        onPressed: () {
                          // refresh();
                        },
                        icon: Icon(Icons.refresh),
                        color: Colors.blue)
                    : SizedBox(),
                selectedDate != null
                    ? ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 230, 1, 1))),
                        onPressed: () {
                          setState(() {
                            selectedDate = null;
                          });
                        },
                        child: const Text("Reset"))
                    : const SizedBox(
                        width: 100,
                      ),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: Colors.blue,
                            hintColor: Colors.blue,
                            colorScheme:
                                const ColorScheme.light(primary: Colors.blue),
                            buttonTheme: const ButtonThemeData(
                                textTheme: ButtonTextTheme.primary),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = DateTime(picked.year, picked.month);
                      });
                    }
                  },
                  child: const Text('Choose Month'),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              child: Consumer<IncomeExpenseTransactionProvider>(
                builder: (context, value, child) {
                  List<IncomeExpenseTransactionModel> expenseListFilter = [];
                  if (selectedDate != null) {
                    expenseListFilter = value.incomeExpenseTransactionList
                        .where((expense) =>
                            expense.tranDate!.year == selectedDate!.year &&
                            expense.tranDate!.month == selectedDate!.month)
                        .toList();
                  } else {
                    expenseListFilter = value.incomeExpenseTransactionList
                        .where((expense) =>
                            expense.tranDate!.year == currentDate.year &&
                            expense.tranDate!.month == currentDate.month)
                        .toList();
                  }

                  return value.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : expenseListFilter.isEmpty
                          ? Center(child: Text("no expense found"))
                          : ListView.builder(
                              itemCount: expenseListFilter.length,
                              itemBuilder: (context, index) {
                                IncomeExpenseTransactionModel expense =
                                    expenseListFilter[index];
                                return ListTile(
                                  title: Card(
                                    elevation: 10,
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            width: 290,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Description: ${expense.name}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ).pOnly(bottom: 8),
                                                Text(
                                                  "Amount: ${expense.amount}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ).pOnly(bottom: 8),
                                                Text(
                                                  "Tran Date: ${DateFormat("dd MMM y").format(expense.tranDate!)}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ).pOnly(bottom: 8),
                                              ],
                                            ).p(15),
                                          ),
                                          CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    215, 224, 2, 2),
                                            child: IconButton(
                                              iconSize: 15,
                                              color: Colors.white,
                                              onPressed: () async {
                                                int? id = expense.id;
                                                await expenseApi
                                                  ..deleteIncomeExpenseTransaction(
                                                      id!);
                                                Provider.of<IncomeExpenseTransactionProvider>(
                                                        context,
                                                        listen: false)
                                                    .getIncomeExpenseTransactionList();
                                                setState(() {
                                                  // refresh();
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "deleted successfully")));
                                              },
                                              icon: const Icon(Icons.delete),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).p(8),
                                );
                              },
                            );
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            "Total Expense".text.bold.size(16).make(),
            Consumer<IncomeExpenseTransactionProvider>(
              builder: (context, value, child) {
                value.calTotal(selectedDate: selectedDate);
                return Text("BDT ${value.totalExpense}")
                    .text
                    .color(Colors.deepOrangeAccent)
                    .bold
                    .size(16)
                    .make();
              },
            )
          ],
        ),
      ).p(20),
    );
  }
}
