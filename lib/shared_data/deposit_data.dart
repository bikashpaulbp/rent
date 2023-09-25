import 'package:flutter/material.dart';
import 'package:rent_management/models/deposit_model.dart';

class DepositData extends ChangeNotifier {
  List<DepositeModel> _depositList = [];

  List<DepositeModel> get depositList => _depositList;

  void updateRentList(List<DepositeModel> newDepositList) {
    _depositList = newDepositList;
    notifyListeners();
  }
}
