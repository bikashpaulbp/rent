import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:rent_management/models/building_model.dart';

class BuildingApiService {
  final getBuildingsUrl =
      "http://103.197.204.163/RentMgtAPI/api/Building/GetAllBuilding";
  final postBuildingUrl =
      "http://103.197.204.163/RentMgtAPI/api/Building/CreateBuilding";
  final getSingleBuildingUrl =
      "http://103.197.204.163/RentMgtAPI/api/Building/GetSingleBuilding/";
  final putBuildingUrl =
      "http://103.197.204.163/RentMgtAPI/api/Building/UpdateBuilding/";
  final deleteBuildingUrl =
      "http://103.197.204.163/RentMgtAPI/api/Building/DeleteBuilding/";

  Future<List<BuildingModel>> getAllBuildings() async {
    try {
      final http.Response response = await http.get(Uri.parse(getBuildingsUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<BuildingModel> allBuildingList =
            body.map((e) => BuildingModel.fromJson(e)).toList();
        print(response.statusCode);
        return allBuildingList;
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

  Future<List<BuildingModel>> getSingleBuilding(int id) async {
    try {
      final http.Response response =
          await http.get(Uri.parse(getSingleBuildingUrl + id.toString()));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<BuildingModel> allBuildingList =
            body.map((e) => BuildingModel.fromJson(e)).toList();

        return allBuildingList;
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

  Future<BuildingModel> createBuilding(BuildingModel building) async {
    final http.Response response = await http.post(Uri.parse(postBuildingUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(building.toJson()));
    if (response.statusCode == 200) {
      return BuildingModel.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      throw Exception('Failed to create building.');
    }
  }

  Future<BuildingModel> updateBuilding(
      {required int id, required BuildingModel building}) async {
    final http.Response response = await http.put(
      Uri.parse(putBuildingUrl + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(building.toJson()),
    );

    if (response.statusCode == 200) {
      return BuildingModel.fromJson(jsonDecode(response.body));
    } else {
      print(Uri.parse(putBuildingUrl + id.toString()));
      throw Exception('Failed to update building.');
    }
  }

  Future<BuildingModel> deleteBuilding(int id) async {
    final http.Response response = await http.delete(
      Uri.parse(deleteBuildingUrl + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return BuildingModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete building.');
    }
  }
}
