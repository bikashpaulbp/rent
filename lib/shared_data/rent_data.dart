import 'package:flutter/material.dart';

import '../classes/rent_info.dart';

class RentData extends ChangeNotifier {
  List<RentInfo> _rentList = [];

  List<RentInfo> get rentList => _rentList;

  void updateRentList(List<RentInfo> newRentList) {
    _rentList = newRentList;
    notifyListeners();
  }
}
