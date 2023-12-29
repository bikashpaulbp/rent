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
  late Stream<List<IncomeExpenseTransactionModel>> expenseList =
      const Stream.empty();
  IncomeExpenseTransactionApiService expenseApi =
      IncomeExpenseTransactionApiService();
  AuthStateManager authStateManager = AuthStateManager();
  UserModel? loggedInUser = UserModel();
  int? buildingId;
  int? userId;
 
  @override
  void initState() {
    setState(() {
      refresh();
      getUser();
      getBuildingId();
    });
    super.initState();
  }

  Future<void> getUser() async {
    loggedInUser = (await authStateManager.getLoggedInUser())!;
  }

  Future<void> getBuildingId() async {
    buildingId = await authStateManager.getBuildingId();
  }

  refresh() {
    fetchExpense();
  }

  Future<void> fetchExpense() async {
    expenseList = expenseApi.getAllIncomeExpenseTransaction().asStream();
  }

  Future<int> calTotal() async {
    try {
      int total = 0;
      List<IncomeExpenseTransactionModel> allExpenseList =
          await Provider.of<IncomeExpenseTransactionProvider>(context,
                  listen: false)
              .returnIncomeExpenseTranList();
      List<IncomeExpenseTransactionModel> expensesList = allExpenseList
          .where((element) =>
              element.buildingId == buildingId &&
              element.userId == loggedInUser!.id)
          .toList();
      for (var expense in expensesList) {
        total += expense.amount!;
      }

      return total;
    } catch (_) {
      return 0;
    }
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
      body: Container(
        child: StreamBuilder<List<IncomeExpenseTransactionModel>>(
          stream: expenseList,
          builder: (BuildContext context,
              AsyncSnapshot<List<IncomeExpenseTransactionModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.isNotEmpty) {
              getBuildingId();
              getUser();
              List<IncomeExpenseTransactionModel> expenses = snapshot.data!
                  .where((element) =>
                      element.buildingId == buildingId &&
                      element.userId == loggedInUser!.id)
                  .toList();

              return ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  IncomeExpenseTransactionModel expense = expenses[index];

                  return ListTile(
                    title: Card(
                      elevation: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description: ${expense.name}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ).pOnly(bottom: 8),
                          Text(
                            "Amount: ${expense.amount}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ).pOnly(bottom: 8),
                          Text(
                            "Date: ${DateFormat("dd MMM y").format(expense.tranDate!)}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ).pOnly(bottom: 8),
                        ],
                      ).p(15),
                    ).p(8),
                  );
                },
              );
            } else {
              return const Center(child: Text('no expense available'));
            }
          },
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

            FutureBuilder<int>(
              future: calTotal(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // If the Future is still running, show a loading indicator or default value
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // If there's an error, show an error message
                  return Text('Error: ${snapshot.error}');
                } else {
                  // If the Future is complete, display the result
                  return Text("BDT ${snapshot.data}")
                      .text
                      .color(Colors.deepOrangeAccent)
                      .bold
                      .size(16)
                      .make();
                }
              },
            )
          ],
        ),
      ).p(20),
    );
  }
}
