import 'package:flutter/material.dart';
import 'package:rent_management/models/IncomeExpense.dart';
import 'package:rent_management/models/incomeExpenseTypeModel.dart';

import 'package:rent_management/services/incomeExpense_service.dart';

class IncomeExpenseProvider extends ChangeNotifier {
  List<IncomeExpenseModel> incomeExpenseList = [];
  IncomeExpenseApiService incomeExpenseApiService = IncomeExpenseApiService();
  // List<IncomeExpenseTypeModel> incomeExpenseTypeList = [
  //   IncomeExpenseTypeModel(id: 1, name: "income"),
  //   IncomeExpenseTypeModel(id: 2, name: "expense")
  // ];
  List<IncomeExpenseTypeModel> typeList = [];

  Future<void> getIncomeExpenseList() async {
    try {
      List<IncomeExpenseModel> allIncomeExpenseList =
          await incomeExpenseApiService.getAllIncomeExpense();
      incomeExpenseList = allIncomeExpenseList;
      notifyListeners();
    } catch (_) {}
  }

  // void getIncomeExpenseType() {
  //   typeList = incomeExpenseTypeList;
  // }

  incomeExpenseListNew() {
    return incomeExpenseList.length;
  }
}
