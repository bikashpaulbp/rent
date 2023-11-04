import 'package:flutter/material.dart';
import 'package:rent_management/models/building_model.dart';
import 'package:rent_management/services/building_service.dart';

class BuildingProvider extends ChangeNotifier {
  BuildingApiService buildingApiService = BuildingApiService();
  List<BuildingModel> buildingList = [];

  Future<void> getBuildingList() async {
    List<BuildingModel> allBuildingList =
        await buildingApiService.getAllBuildings();
    buildingList = allBuildingList;
    notifyListeners();
  }
}
