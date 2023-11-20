import 'package:flutter/material.dart';
import 'package:rent_management/models/deposit_model.dart';
import 'package:rent_management/services/deposite_service.dart';

class DepositData extends ChangeNotifier {
  List<DepositeModel> depositList = [];
  DepositeApiService depositApiService = DepositeApiService();

  Future<void> getDepositList() async {
    try {
      List<DepositeModel> allDepositList =
          await depositApiService.getAllDeposites();
      depositList = allDepositList;
      notifyListeners();
    } catch (_) {}
  }

  depositListNew() {
    return depositList.length;
  }
}
