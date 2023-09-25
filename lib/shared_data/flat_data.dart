import 'package:flutter/material.dart';
import 'package:rent_management/models/flat_model.dart';

class FlatData extends ChangeNotifier {
  List<FlatModel> _flatList = [];

  List<FlatModel> get flatList => _flatList;
  void updateFlatList(List<FlatModel> newFlatList) {
    _flatList = newFlatList;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  flatListNew() {
    return _flatList.length;
  }
}
