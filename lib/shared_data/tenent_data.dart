import 'package:flutter/material.dart';
import 'package:rent_management/models/tenant_model.dart';

class TenantData extends ChangeNotifier {
  List<TenantModel> _tenantList = [];

  List<TenantModel> get tenantList => _tenantList;
  void updateTenantList(List<TenantModel> newTenantList) {
    _tenantList = newTenantList;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  tenantListNew() {
    return _tenantList.length;
  }

  firstWhere(bool Function(dynamic tenant) param0) {}

  where(bool Function(dynamic e) param0) {}
}
