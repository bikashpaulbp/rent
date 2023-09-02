import 'package:flutter/material.dart';
import 'package:rent_management/classes/deposit.dart';

class DepositData extends ChangeNotifier {
  List<Deposit> _depositList = [];

  List<Deposit> get depositList => _depositList;

  void updateRentList(List<Deposit> newDepositList) {
    _depositList = newDepositList;
    notifyListeners();
  }
}
