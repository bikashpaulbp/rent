import 'package:flutter/material.dart';

import '../classes/floor_info.dart';

class FloorData extends ChangeNotifier {
  List<Floor> _floorList = [];

  List<Floor> get floorList => _floorList;
  void updateFloorList(List<Floor> newFloorList) {
    _floorList = newFloorList;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  floorListNew() {
    return _floorList.length;
  }
}
