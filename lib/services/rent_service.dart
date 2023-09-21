import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:rent_management/models/rent_model.dart';

class RentApiService {
  final getRentsUrl = "http://103.197.204.163/RentMgtAPI/api/Rent/GetAllRent";
  final postRentUrl = "http://103.197.204.163/RentMgtAPI/api/Rent/CreateRent";
  final getSingleRentUrl =
      "http://103.197.204.163/RentMgtAPI/api/Rent/GetSingleRent/";
  final putRentUrl = "http://103.197.204.163/RentMgtAPI/api/Rent/UpdateRent/";
  final deleteRentUrl =
      "http://103.197.204.163/RentMgtAPI/api/Rent/DeleteRent/";

  Future<List<RentModel>> getAllRents() async {
    try {
      final http.Response response = await http.get(Uri.parse(getRentsUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<RentModel> allRentList =
            body.map((e) => RentModel.fromJson(e)).toList();
        print(response.statusCode);
        return allRentList;
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

  Future<List<RentModel>> getSingleRent(int id) async {
    try {
      final http.Response response =
          await http.get(Uri.parse(getSingleRentUrl + id.toString()));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<RentModel> allRentList =
            body.map((e) => RentModel.fromJson(e)).toList();

        return allRentList;
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

  Future<RentModel> createRent(RentModel rent) async {
    final http.Response response = await http.post(Uri.parse(postRentUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(rent.toJson()));
    if (response.statusCode == 200) {
      return RentModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create rent.');
    }
  }

  Future<RentModel> updateRent(
      {required int id, required RentModel rent}) async {
    try {
      final http.Response response = await http.put(
        Uri.parse(putRentUrl + id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(rent.toJson()),
      );

      if (response.statusCode == 200) {
        return RentModel.fromJson(jsonDecode(response.body));
      } else {
        print('Request URL: ${Uri.parse(putRentUrl + id.toString())}');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception(
            'Failed to update rent. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<RentModel> deleteRent(int id) async {
    final http.Response response = await http.delete(
      Uri.parse(deleteRentUrl + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return RentModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete rent.');
    }
  }
}
