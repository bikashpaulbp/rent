import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:rent_management/models/floor_model.dart';

class FloorApiService {
  final getFloorsUrl =
      "http://103.197.204.163/RentMgtAPI/api/Floor/GetAllFloor";
  final postFloorUrl =
      "http://103.197.204.163/RentMgtAPI/api/Floor/CreateFloor";
  final getSingleFloorUrl =
      "http://103.197.204.163/RentMgtAPI/api/Floor/GetSingleFloor/";
  final putFloorUrl =
      "http://103.197.204.163/RentMgtAPI/api/Floor/UpdateFloor/";
  final deleteFloorUrl =
      "http://103.197.204.163/RentMgtAPI/api/Floor/DeleteFloor/";

  Future<List<FloorModel>> getAllFloors() async {
    try {
      final http.Response response = await http.get(Uri.parse(getFloorsUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<FloorModel> allFloorList =
            body.map((e) => FloorModel.fromJson(e)).toList();
        print(response.statusCode);
        return allFloorList;
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

  Future<List<FloorModel>> getSingleFloor(int id) async {
    try {
      final http.Response response =
          await http.get(Uri.parse(getSingleFloorUrl + id.toString()));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<FloorModel> allFloorList =
            body.map((e) => FloorModel.fromJson(e)).toList();

        return allFloorList;
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

  Future<FloorModel> createFloor(FloorModel floor) async {
    final http.Response response = await http.post(Uri.parse(postFloorUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(floor.toJson()));
    if (response.statusCode == 200) {
      return FloorModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create floor.');
    }
  }

  Future<FloorModel> updateFloor(
      {required int id, required FloorModel floor}) async {
    final http.Response response = await http.put(
      Uri.parse(putFloorUrl + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(floor.toJson()),
    );

    if (response.statusCode == 200) {
      return FloorModel.fromJson(jsonDecode(response.body));
    } else {
      print(Uri.parse(putFloorUrl + id.toString()));
      throw Exception('Failed to update floor.');
    }
  }

  Future<FloorModel> deleteFloor(int id) async {
    final http.Response response = await http.delete(
      Uri.parse(deleteFloorUrl + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return FloorModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete floor.');
    }
  }
}
