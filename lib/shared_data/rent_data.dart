import 'package:flutter/material.dart';
import 'package:rent_management/models/rent_model.dart';

import '../classes/rent_info.dart';

class RentData extends ChangeNotifier {
  List<RentModel> _rentList = [];

  List<RentModel> get rentList => _rentList;

  void updateRentList(List<RentModel> newRentList) {
    _rentList = newRentList;
    notifyListeners();
  }
}
