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
  late Stream<List<IncomeExpenseTransactionModel>> expenseList = Stream.empty();
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
    getUser();
    getBuildingId();

    refresh();
  }

  Future<void> getUser() async {
    loggedInUser = (await authStateManager.getLoggedInUser())!;
  }

  Future<void> getBuildingId() async {
    buildingId = await authStateManager.getBuildingId();
  }

  bool isRentCurrentMonth(IncomeExpenseTransactionModel expense, selectedDate) {
    try {
      DateTime date = expense.tranDate!;

      return date.year == selectedDate!.year &&
          date.month == selectedDate!.month;
    } catch (_) {
      return false;
    }
  }

  refresh() async {
    try {
      expenseList = expenseApi.getAllIncomeExpenseTransaction().asStream();
    } catch (_) {}
  }

  Future<void> fetchExpense() async {
    setState(() {
      expenseList = expenseApi.getAllIncomeExpenseTransaction().asStream();
    });
  }

  // Future<double> calTotal() async {
  //   try {
  //     totalExpense = 0.0;
  //     List<IncomeExpenseTransactionModel> expenseListFilter;
  //     List<IncomeExpenseTransactionModel>? expensesList;
  //     List<IncomeExpenseTransactionModel> allExpenseList;
  //     allExpenseList = await Provider.of<IncomeExpenseTransactionProvider>(
  //             context,
  //             listen: false)
  //         .returnIncomeExpenseTranList();
  //     if (selectedDate != null) {
  //       expensesList = allExpenseList
  //           .where((element) =>
  //               element.buildingId == buildingId &&
  //               element.userId == loggedInUser!.id)
  //           .toList();

  //       expenseListFilter = expensesList
  //           .where((expense) =>
  //               expense.tranDate!.year == selectedDate!.year &&
  //               expense.tranDate!.month == selectedDate!.month)
  //           .toList();
  //       totalExpense = expenseListFilter.fold(
  //           0.0,
  //           (previousValue, element) =>
  //               previousValue! + (element.amount ?? 0.0));

  //       return totalExpense!;
  //     } else if (selectedDate == null) {
  //       expensesList = allExpenseList
  //           .where((element) =>
  //               element.buildingId == buildingId &&
  //               element.userId == loggedInUser!.id)
  //           .toList();

  //       expenseListFilter = expensesList
  //           .where((expense) =>
  //               expense.tranDate!.year == currentDate.year &&
  //               expense.tranDate!.month == currentDate.month)
  //           .toList();

  //       totalExpense = expenseListFilter.fold(
  //           0.0,
  //           (previousValue, element) =>
  //               previousValue! + (element.amount ?? 0.0));

  //       return totalExpense!;
  //     } else {
  //       return 0;
  //     }
  //   } catch (_) {
  //     return 0;
  //   }
  // }

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
              Get.to(() => Expense(refresh: refresh));
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
                          refresh();
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
            selectedDate != null
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: StreamBuilder<List<IncomeExpenseTransactionModel>>(
                      stream: expenseList,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<IncomeExpenseTransactionModel>>
                              snapshot) {
                        getBuildingId();
                        getUser();
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data!.isNotEmpty) {
                          List<IncomeExpenseTransactionModel> expenses =
                              snapshot.data!
                                  .where((element) =>
                                      element.buildingId == buildingId &&
                                      element.userId == loggedInUser!.id)
                                  .toList();
                          List<IncomeExpenseTransactionModel>?
                              expenseListFilter;

                          if (selectedDate != null) {
                            expenseListFilter = expenses
                                .where((expense) =>
                                    expense.tranDate!.year ==
                                        selectedDate!.year &&
                                    expense.tranDate!.month ==
                                        selectedDate!.month)
                                .toList();
                          } else {
                            expenseListFilter = expenses
                                .where((expense) =>
                                    expense.tranDate!.year ==
                                        currentDate.year &&
                                    expense.tranDate!.month ==
                                        currentDate.month)
                                .toList();
                          }

                          // totalExpense = expenseListFilter!.fold(
                          //     0.0,
                          //     (previousValue, element) =>
                          //         previousValue! + (element.amount ?? 0.0));

                          // else if (selectedDate == null) {
                          //   DateTime now = DateTime.now();
                          //   // DateTime firstDayOfCurrentMonth =
                          //   //     DateTime(now.year, now.month, 1);
                          //   DateTime previousMonth =
                          //       DateTime(now.year, now.month - 1);

                          //   // DateTime firstDayOfPreviousMonth =
                          //   //     firstDayOfCurrentMonth
                          //   //         .subtract(Duration(days: 1));

                          //   expenseListFilter = List.from(expenses.where(
                          //     (element) =>
                          //         element.tranDate!.year ==
                          //             previousMonth.year &&
                          //         element.tranDate!.month ==
                          //             previousMonth.month,
                          //     // element.rentMonth!
                          //     //     .isAfter(firstDayOfPreviousMonth) &&
                          //     // element.rentMonth!
                          //     //     .isBefore(firstDayOfCurrentMonth)
                          //   ));
                          // } else {
                          //   expenseListFilter = List.from(expenses);
                          // }

                          return ListView.builder(
                            itemCount: expenseListFilter.length,
                            itemBuilder: (context, index) {
                              IncomeExpenseTransactionModel expense =
                                  expenses[index];

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
                                          backgroundColor: const Color.fromARGB(
                                              215, 224, 2, 2),
                                          child: IconButton(
                                            iconSize: 15,
                                            color: Colors.white,
                                            onPressed: () async {
                                              int? id = expense.id;
                                              await expenseApi
                                                ..deleteIncomeExpenseTransaction(
                                                    id!);
                                              setState(() {
                                                refresh();
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
                        } else {
                          return const Center(
                              child: Text('no expense available'));
                        }
                      },
                    ),
                  )
                : Center(
                    child: "Please choose month".text.make().p(100),
                  ),
          ],
        ),
      ),
      bottomSheet: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            "Total Expense".text.bold.size(16).make(),
            // "BDT $total"
            //     .text
            //     .color(Colors.deepOrangeAccent)
            //     .bold
            //     .size(16)
            //     .make(),
            // Consumer<IncomeExpenseTransactionProvider>(
            //   builder: (context, value, child) {
            //     calTotal();

            //     return "BDT ${total}"
            //         .text
            //         .color(Colors.deepOrangeAccent)
            //         .bold
            //         .size(16)
            //         .make();
            //   },
            // )

            // FutureBuilder<double>(
            //   future: calTotal(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       // If the Future is still running, show a loading indicator or default value
            //       return CircularProgressIndicator();
            //     } else if (snapshot.hasError) {
            //       // If there's an error, show an error message
            //       return Text('Error: ${snapshot.error}');
            //     } else {
            //       // If the Future is complete, display the result
            //       return Text("BDT ${snapshot.data}")
            //           .text
            //           .color(Colors.deepOrangeAccent)
            //           .bold
            //           .size(16)
            //           .make();
            //     }
            //   },
            // )
          ],
        ),
      ).p(20),
    );
  }
}
