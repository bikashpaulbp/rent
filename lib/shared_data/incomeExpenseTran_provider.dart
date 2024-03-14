import 'package:flutter/material.dart';
import 'package:rent_management/models/IncomeExpenseTransaction.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/services/incomeExpenseTran_service.dart';

class IncomeExpenseTransactionProvider extends ChangeNotifier {
  List<IncomeExpenseTransactionModel> incomeExpenseTransactionList = [];
  List<IncomeExpenseTransactionModel> allIncomeExpenseTransactionList = [];
  IncomeExpenseTransactionApiService incomeExpenseTransactionApiService =
      IncomeExpenseTransactionApiService();
  AuthStateManager authStateManager = AuthStateManager();
  UserModel? loggedInUser = UserModel();
  int? buildingId;
  int? userId;
  int total = 0;
  int amount = 0;
  bool isLoading = false;

  double? totalExpense;

  DateTime currentDate = DateTime.now();

  Future<void> getUser() async {
    loggedInUser = (await authStateManager.getLoggedInUser())!;
  }

  Future<void> getBuildingId() async {
    buildingId = await authStateManager.getBuildingId();
  }

  Future<void> getIncomeExpenseTransactionList() async {
    try {
      allIncomeExpenseTransactionList = [];
      incomeExpenseTransactionList = [];
      isLoading = true;

      await getUser();
      await getBuildingId();
      allIncomeExpenseTransactionList = await incomeExpenseTransactionApiService
          .getAllIncomeExpenseTransaction();

      incomeExpenseTransactionList = allIncomeExpenseTransactionList
          .where((element) =>
              element.buildingId == buildingId &&
              element.userId == loggedInUser!.id)
          .toList();

      notifyListeners();
    } catch (_) {
    } finally {
      isLoading = false;
      notifyListeners(); // Moved notifyListeners() to the finally block to ensure it's called after the async operations
    }
  }

  Future<void> refreshList() async {
    try {
      allIncomeExpenseTransactionList = [];
      incomeExpenseTransactionList = [];
      isLoading = true;

      await getUser();
      await getBuildingId();
      allIncomeExpenseTransactionList = await incomeExpenseTransactionApiService
          .getAllIncomeExpenseTransaction();

      incomeExpenseTransactionList = allIncomeExpenseTransactionList
          .where((element) =>
              element.buildingId == buildingId &&
              element.userId == loggedInUser!.id)
          .toList();

      notifyListeners();
    } catch (_) {
    } finally {
      isLoading = false;
      notifyListeners(); // Moved notifyListeners() to the finally block to ensure it's called after the async operations
    }
  }

  incomeExpenseTransactionListNew() {
    return incomeExpenseTransactionList.length;
  }

  void calTotal({DateTime? selectedDate}) async {
    try {
      totalExpense = 0.0;
      List<IncomeExpenseTransactionModel> expenseListFilter;
      List<IncomeExpenseTransactionModel> expensesList;

      if (selectedDate != null) {
        expensesList = incomeExpenseTransactionList
            .where((element) =>
                element.buildingId == buildingId &&
                element.userId == loggedInUser!.id)
            .toList();

        expenseListFilter = incomeExpenseTransactionList
            .where((expense) =>
                expense.tranDate!.year == selectedDate.year &&
                expense.tranDate!.month == selectedDate.month)
            .toList();
        totalExpense = expenseListFilter.fold(
            0.0,
            (previousValue, element) =>
                previousValue! + (element.amount ?? 0.0));

        // return totalExpense!;
      } else if (selectedDate == null) {
        expensesList = incomeExpenseTransactionList
            .where((element) =>
                element.buildingId == buildingId &&
                element.userId == loggedInUser!.id)
            .toList();

        expenseListFilter = expensesList
            .where((expense) =>
                expense.tranDate!.year == currentDate.year &&
                expense.tranDate!.month == currentDate.month)
            .toList();

        totalExpense = expenseListFilter.fold(
            0.0,
            (previousValue, element) =>
                previousValue! + (element.amount ?? 0.0));

        // return totalExpense!;
      } else {
        // return 0;
      }
    } catch (_) {
      // return 0;
    }
  }
}
