import 'package:flutter/material.dart';
import 'package:rent_management/models/IncomeExpenseTransaction.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/services/incomeExpenseTran_service.dart';

class IncomeExpenseTransactionProvider extends ChangeNotifier {
  List<IncomeExpenseTransactionModel> incomeExpenseTransactionList = [];
  IncomeExpenseTransactionApiService incomeExpenseTransactionApiService =
      IncomeExpenseTransactionApiService();
  AuthStateManager authStateManager = AuthStateManager();
  UserModel? loggedInUser = UserModel();
  int? buildingId;
  int? userId;
  int total = 0;
  int amount = 0;
  Future<void> getUser() async {
    loggedInUser = (await authStateManager.getLoggedInUser())!;
  }

  Future<void> getBuildingId() async {
    buildingId = await authStateManager.getBuildingId();
  }

  Future<void> getIncomeExpenseTransactionList() async {
    try {
      List<IncomeExpenseTransactionModel> allIncomeExpenseTransactionList =
          await incomeExpenseTransactionApiService
              .getAllIncomeExpenseTransaction();
      incomeExpenseTransactionList = allIncomeExpenseTransactionList;
      notifyListeners();
    } catch (_) {}
  }

  Future<List<IncomeExpenseTransactionModel>>
      returnIncomeExpenseTranList() async {
    await getIncomeExpenseTransactionList();
    return incomeExpenseTransactionList;
  }

  incomeExpenseTransactionListNew() {
    return incomeExpenseTransactionList.length;
  }

  Future<void> calTotal() async {
    await getIncomeExpenseTransactionList();
    await getBuildingId();
    await getUser();
    try {
      List<IncomeExpenseTransactionModel> allExpenseList =
          incomeExpenseTransactionList;

      List<IncomeExpenseTransactionModel> expensesList = allExpenseList
          .where((element) =>
              element.buildingId == buildingId &&
              element.userId == loggedInUser!.id)
          .toList();
      for (var expense in expensesList) {
        amount = amount + expense.amount!;
      }
      total = amount;
    } catch (_) {}
  }
}
