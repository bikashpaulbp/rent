import 'package:flutter/material.dart';
import 'package:rent_management/models/floor_model.dart';
import 'package:rent_management/services/floor_service.dart';

class FloorData extends ChangeNotifier {
  List<FloorModel> floorList = [];
  FloorApiService floorApiService = FloorApiService();

  Future<void> getFloorList() async {
    try {
      List<FloorModel> allFloorList = await floorApiService.getAllFloors();
      floorList = allFloorList;
      notifyListeners();
    } catch (_) {}
  }

  floorListNew() {
    return floorList.length;
  }
}
