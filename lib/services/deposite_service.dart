import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:rent_management/models/deposit_model.dart';

class DepositeApiService {
  final getDepositesUrl =
      "http://103.197.204.163/RentMgtAPI/api/Deposite/GetAllDeposite";
  final postDepositeUrl =
      "http://103.197.204.163/RentMgtAPI/api/Deposite/CreateDeposite";
  final getSingleDepositeUrl =
      "http://103.197.204.163/RentMgtAPI/api/Deposite/GetSingleDeposite/";
  final putDepositeUrl =
      "http://103.197.204.163/RentMgtAPI/api/Deposite/UpdateDeposite/";
  final deleteDepositeUrl =
      "http://103.197.204.163/RentMgtAPI/api/Deposite/DeleteDeposite/";

  Future<List<DepositeModel>> getAllDeposites() async {
    try {
      final http.Response response = await http.get(Uri.parse(getDepositesUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<DepositeModel> allDepositeList =
            body.map((e) => DepositeModel.fromJson(e)).toList();
        print(response.statusCode);
        return allDepositeList;
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

  Future<List<DepositeModel>> getSingleDeposite(int id) async {
    try {
      final http.Response response =
          await http.get(Uri.parse(getSingleDepositeUrl + id.toString()));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<DepositeModel> allDepositeList =
            body.map((e) => DepositeModel.fromJson(e)).toList();

        return allDepositeList;
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

  Future<DepositeModel> createDeposite(DepositeModel deposite) async {
    try {
      final http.Response response = await http.post(Uri.parse(postDepositeUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(deposite.toJson()));

      if (response.statusCode == 200) {
        return DepositeModel.fromJson(jsonDecode(response.body));
      } else {
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
        throw Exception('Failed to create deposite.');
      }
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<DepositeModel> updateDeposite(
      {required int id, required DepositeModel deposite}) async {
    final http.Response response = await http.put(
      Uri.parse(putDepositeUrl + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(deposite.toJson()),
    );

    if (response.statusCode == 200) {
      return DepositeModel.fromJson(jsonDecode(response.body));
    } else {
      print(Uri.parse(putDepositeUrl + id.toString()));
      throw Exception('Failed to update deposite.');
    }
  }

  Future<DepositeModel> deleteDeposite(int id) async {
    final http.Response response = await http.delete(
      Uri.parse(deleteDepositeUrl + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return DepositeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete deposite.');
    }
  }
}
