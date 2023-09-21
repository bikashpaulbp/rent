import 'package:flutter/material.dart';
import 'package:rent_management/models/floor_model.dart';

class FloorData extends ChangeNotifier {
  List<FloorModel> _floorList = [];

  List<FloorModel> get floorList => _floorList;
  void updateFloorList(List<FloorModel> newFloorList) {
    _floorList = newFloorList;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  floorListNew() {
    return _floorList.length;
  }
}
