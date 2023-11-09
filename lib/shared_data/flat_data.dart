import 'package:flutter/material.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/services/flat_service.dart';

class FlatData extends ChangeNotifier {
  List<FlatModel> flatList = [];
  FlatApiService flatApiService = FlatApiService();

  Future<void> getFlatList() async {
    try {
      List<FlatModel> allFlatList = await flatApiService.getAllFlats();
      flatList = allFlatList;
      notifyListeners();
    } catch (_) {}
  }

  flatListNew() {
    return flatList.length;
  }
}
