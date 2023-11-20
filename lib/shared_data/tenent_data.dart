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

      notifyListeners();
    } catch (_) {}
  }

  // Future<void> getTenantListCache() async {
  //   try {
  //     await getTenantList();

  //     tenantListCache = tenantList;

  //     notifyListeners();
  //   } catch (_) {}
  // }

  tenantListNew() {
    return tenantList.length;
  }
}
