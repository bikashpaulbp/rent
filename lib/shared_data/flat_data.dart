import 'package:flutter/material.dart';
import 'package:rent_management/classes/flat_info.dart';

class FlatData extends ChangeNotifier {
  List<FlatInfo> _flatList = [];

  List<FlatInfo> get flatList => _flatList;
  void updateFlatList(List<FlatInfo> newFlatList) {
    _flatList = newFlatList;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  flatListNew() {
    return _flatList.length;
  }
}
