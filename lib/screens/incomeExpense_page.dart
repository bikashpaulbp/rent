import 'package:flutter/material.dart';
import 'package:rent_management/screens/expensePage.dart';
import 'package:rent_management/screens/incomePage.dart';
import 'package:velocity_x/velocity_x.dart';

class IncomeExpense extends StatefulWidget {
  const IncomeExpense({super.key});

  @override
  State<IncomeExpense> createState() => _IncomeExpenseState();
}

class _IncomeExpenseState extends State<IncomeExpense> {
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
       
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 226, 155, 2),
            title: "Income and Expense".text.make(),
            bottom: const TabBar(tabs: [
              Tab(text: "Income"),
              Tab(
                text: "Expense",
              )
            ])),
        body: const TabBarView(children: [IncomePage(), ExpensePage()]),
      ),
    );
  }
}
