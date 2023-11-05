import 'package:flutter/material.dart';
import 'package:rent_management/models/tenant_model.dart';
import 'package:rent_management/services/tenant_service.dart';

class TenantData extends ChangeNotifier {
  List<TenantModel> tenantList = [];

  TenantApiService tenantApiService = TenantApiService();

  Future<void> getTenantList() async {
    try {
      List<TenantModel> allTenantList = await tenantApiService.getAllTenants();
      tenantList = allTenantList;
      notifyListeners();
    } catch (_) {}
  }

  tenantListNew() {
    return tenantList.length;
  }
}
