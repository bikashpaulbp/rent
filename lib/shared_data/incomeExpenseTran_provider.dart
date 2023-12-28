import 'package:flutter/material.dart';
import 'package:rent_management/models/IncomeExpenseTransaction.dart';
import 'package:rent_management/services/incomeExpenseTran_service.dart';

class IncomeExpenseTransactionProvider extends ChangeNotifier {
  List<IncomeExpenseTransactionModel> incomeExpenseTransactionList = [];
  IncomeExpenseTransactionApiService incomeExpenseTransactionApiService =
      IncomeExpenseTransactionApiService();

  Future<void> getIncomeExpenseTransactionList() async {
    try {
      List<IncomeExpenseTransactionModel> allIncomeExpenseTransactionList =
          await incomeExpenseTransactionApiService
              .getAllIncomeExpenseTransaction();
      incomeExpenseTransactionList = allIncomeExpenseTransactionList;
      notifyListeners();
    } catch (_) {}
  }

  incomeExpenseTransactionListNew() {
    return incomeExpenseTransactionList.length;
  }
}
