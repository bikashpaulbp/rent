import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rent_management/models/IncomeExpense.dart';
import 'dart:async';
import 'dart:convert';

class IncomeExpenseApiService {
  final getIncomeExpenseUrl =
      "http://103.197.204.163/RentMgtAPI/api/IncomeExpense/GetAllIncomeExpense";
  final postIncomeExpenseUrl =
      "http://103.197.204.163/RentMgtAPI/api/IncomeExpense/CreateIncomeExpense";
  final getSingleIncomeExpenseUrl =
      "http://103.197.204.163/RentMgtAPI/api/IncomeExpense/GetSingleIncomeExpense/";
  final putIncomeExpenseUrl =
      "http://103.197.204.163/RentMgtAPI/api/IncomeExpense/UpdateIncomeExpense/";
  final deleteIncomeExpenseUrl =
      "http://103.197.204.163/RentMgtAPI/api/IncomeExpense/DeleteIncomeExpense/";

  Future<List<IncomeExpenseModel>> getAllIncomeExpense() async {
    try {
      final http.Response response =
          await http.get(Uri.parse(getIncomeExpenseUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<IncomeExpenseModel> allIncomeExpenseList =
            body.map((e) => IncomeExpenseModel.fromJson(e)).toList();

        return allIncomeExpenseList;
      } else if (response.statusCode == 404) {
        print("Data not found (404)");
        return [];
      } else {
        throw "Request failed with status: ${response.statusCode}";
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<IncomeExpenseModel>> getSingleIncomeExpense(int id) async {
    try {
      final http.Response response =
          await http.get(Uri.parse(getSingleIncomeExpenseUrl + id.toString()));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<IncomeExpenseModel> allIncomeExpenseList =
            body.map((e) => IncomeExpenseModel.fromJson(e)).toList();

        return allIncomeExpenseList;
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

  Future<IncomeExpenseModel> createIncomeExpense(
      IncomeExpenseModel incomeExpense) async {
    final http.Response response =
        await http.post(Uri.parse(postIncomeExpenseUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(incomeExpense.toJson()));
    if (response.statusCode == 200) {
      return IncomeExpenseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create incomeExpense.');
    }
  }

  Future<IncomeExpenseModel> updateIncomeExpense(
      {required int id, required IncomeExpenseModel incomeExpense}) async {
    final http.Response response = await http.put(
      Uri.parse(putIncomeExpenseUrl + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(incomeExpense.toJson()),
    );

    if (response.statusCode == 200) {
      return IncomeExpenseModel.fromJson(jsonDecode(response.body));
    } else {
      print(Uri.parse(putIncomeExpenseUrl + id.toString()));
      throw Exception('Failed to update incomeExpense.');
    }
  }

  Future<IncomeExpenseModel> deleteIncomeExpense(int id) async {
    final http.Response response = await http.delete(
      Uri.parse(deleteIncomeExpenseUrl + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return IncomeExpenseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete incomeExpense.');
    }
  }
}
