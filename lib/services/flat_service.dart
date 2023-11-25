import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:rent_management/models/flat_model.dart';

class FlatApiService {
  final getFlatsUrl = "http://103.197.204.163/RentMgtAPI/api/Flat/GetAllFlat";
  final postFlatUrl = "http://103.197.204.163/RentMgtAPI/api/Flat/CreateFlat";
  final getSingleFlatUrl =
      "http://103.197.204.163/RentMgtAPI/api/Flat/GetSingleFlat/";
  final putFlatUrl = "http://103.197.204.163/RentMgtAPI/api/Flat/UpdateFlat/";
  final deleteFlatUrl =
      "http://103.197.204.163/RentMgtAPI/api/Flat/DeleteFlat/";

  Future<List<FlatModel>> getAllFlats() async {
    try {
      final http.Response response = await http.get(Uri.parse(getFlatsUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<FlatModel> allFlatList =
            body.map((e) => FlatModel.fromJson(e)).toList();
      
        return allFlatList;
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

  Future<List<FlatModel>> getSingleFlat(int id) async {
    try {
      final http.Response response =
          await http.get(Uri.parse(getSingleFlatUrl + id.toString()));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<FlatModel> allFlatList =
            body.map((e) => FlatModel.fromJson(e)).toList();

        return allFlatList;
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

  Future<FlatModel> createFlat(FlatModel flat) async {
    final http.Response response = await http.post(Uri.parse(postFlatUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(flat.toJson()));
    if (response.statusCode == 200) {
      return FlatModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create flat.');
    }
  }

  Future<FlatModel> updateFlat(
      {required int id, required FlatModel flat}) async {
    final http.Response response = await http.put(
      Uri.parse(putFlatUrl + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(flat.toJson()),
    );

    if (response.statusCode == 200) {
      return FlatModel.fromJson(jsonDecode(response.body));
    } else {
      print(Uri.parse(putFlatUrl + id.toString()));
      throw Exception('Failed to update flat.');
    }
  }

  Future<FlatModel> deleteFlat(int id) async {
    final http.Response response = await http.delete(
      Uri.parse(deleteFlatUrl + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return FlatModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete flat.');
    }
  }
}
