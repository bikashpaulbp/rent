import 'package:flutter/material.dart';
import 'package:rent_management/models/tenant_model.dart';
import 'package:rent_management/services/tenant_service.dart';

class TenantData extends ChangeNotifier {
  List<TenantModel> tenantList = [];
  List<TenantModel> tenantListCache = [];
  TenantApiService tenantApiService = TenantApiService();

  Future<void> getTenantList() async {
    try {
      List<TenantModel> allTenantList = await tenantApiService.getAllTenants();

      tenantList = allTenantList;
      tenantListCache = tenantList;
      notifyListeners();
    } catch (_) {}
  }

  tenantListNew() {
    return tenantList.length;
  }
}
