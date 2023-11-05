import 'package:flutter/material.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/login_screen.dart';

class LocalData extends ChangeNotifier {
  AuthStateManager authStateManager = AuthStateManager();
  UserModel? loggedInUser = UserModel();
  int? buildingId;
  String? buildingName;

  Future<void> fetchLoggedInUser() async {
    loggedInUser = await authStateManager.getLoggedInUser();
    notifyListeners();
  }

  Future<void> getBuildingId() async {
    buildingId = await authStateManager.getBuildingId();
    notifyListeners();
  }

  Future<void> getBuildingName() async {
    buildingName = await authStateManager.getBuildingName();
    notifyListeners();
  }

  Future<void> updateBuildingName(String newName, int id) async {
    await authStateManager.saveBuildingId(id, newName);
    buildingName = await authStateManager.getBuildingName();
    notifyListeners();
  }
}
