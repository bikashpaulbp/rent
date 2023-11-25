import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:rent_management/models/tenant_model.dart';

class TenantApiService {
  final getTenantsUrl =
      "http://103.197.204.163/RentMgtAPI/api/Tenant/GetAllTenant";
  final postTenantUrl =
      "http://103.197.204.163/RentMgtAPI/api/Tenant/CreateTenant";
  final getSingleTenantUrl =
      "http://103.197.204.163/RentMgtAPI/api/Tenant/GetSingleTenant/";
  final putTenantUrl =
      "http://103.197.204.163/RentMgtAPI/api/Tenant/UpdateTenant/";
  final deleteTenantUrl =
      "http://103.197.204.163/RentMgtAPI/api/Tenant/DeleteTenant/";

  Future<List<TenantModel>> getAllTenants() async {
    try {
      final http.Response response = await http.get(Uri.parse(getTenantsUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<TenantModel> allTenantList =
            body.map((e) => TenantModel.fromJson(e)).toList();

        return allTenantList;
      } else if (response.statusCode == 404) {
        print("Data not found (404)");
        return [];
      } else {
        throw "Request failed with status: ${response.statusCode}";
      }
    } catch (e) {
      // if (e is SocketException) {
      //   print("Network error: ${e.message}");

      //   return [];
      // } else {
      //   print("Error: $e");
      //   rethrow;
      // }
      return [];
    }
  }

  Future<List<TenantModel>> getSingleTenant(int id) async {
    try {
      final http.Response response =
          await http.get(Uri.parse(getSingleTenantUrl + id.toString()));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<TenantModel> allTenantList =
            body.map((e) => TenantModel.fromJson(e)).toList();

        return allTenantList;
      } else if (response.statusCode == 404) {
        print("Data not found (404)");
        return [];
      } else {
        throw "Request failed with status: ${response.statusCode}";
      }
    } catch (e) {
      if (e is SocketException) {
        print("Network error: ${e.message}");

        return [];
      } else {
        print("Error: $e");
        rethrow;
      }
    }
  }

  Future<TenantModel> createTenant(TenantModel tenant) async {
    try {
      final http.Response response = await http.post(Uri.parse(postTenantUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(tenant.toJson()));

      if (response.statusCode == 200) {
        
        return TenantModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Error: Status code ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }

  Future<TenantModel> updateTenant(
      {required int id, required TenantModel tenant}) async {
    try {
      final http.Response response = await http.put(
        Uri.parse(putTenantUrl + id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(tenant.toJson()),
      );

      if (response.statusCode == 200) {
        return TenantModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw ('Tenant not found.');
      } else {
        final responseBody = jsonDecode(response.body);
        final errorMessage =
            responseBody['message'] ?? 'Failed to update tenant.';

        print(response.statusCode);
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Exception: $e');
      rethrow;
    }
  }

  Future<TenantModel> deleteTenant(int id) async {
    final http.Response response = await http.delete(
      Uri.parse(deleteTenantUrl + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return TenantModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete tenant.');
    }
  }
}
