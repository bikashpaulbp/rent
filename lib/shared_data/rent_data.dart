import 'package:flutter/material.dart';
import 'package:rent_management/models/rent_model.dart';
import 'package:rent_management/services/rent_service.dart';

class RentData extends ChangeNotifier {
  List<RentModel> rentList = [];
  RentApiService rentApiService = RentApiService();

  Future<void> getRentList() async {
    try {
      List<RentModel> allRentList = await rentApiService.getAllRents();
      rentList = allRentList;
      notifyListeners();
    } catch (_) {}
  }

  Future<List<RentModel>> returnRentList() async {
    await getRentList();
    return rentList;
  }

  rentListNew() {
    return rentList.length;
  }
}
