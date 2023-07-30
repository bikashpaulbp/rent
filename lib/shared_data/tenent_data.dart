import 'package:flutter/material.dart';
import 'package:rent_management/classes/flat_info.dart';
import 'package:rent_management/classes/tenent_info.dart';

class TenantData extends ChangeNotifier {
  List<TenentInfo> _tenantList = [];

  List<TenentInfo> get tenantList => _tenantList;
  void updateTenantList(List<TenentInfo> newTenantList) {
    _tenantList = newTenantList;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  tenantListNew() {
    return _tenantList.length;
  }
}
