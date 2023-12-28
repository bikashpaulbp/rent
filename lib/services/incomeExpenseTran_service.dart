import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:rent_management/models/IncomeExpenseTransaction.dart';



class IncomeExpenseTransactionApiService {
  final getIncomeExpenseTransactionUrl =
      "http://103.197.204.163/RentMgtAPI/api/IncomeExpenseTransaction/GetAllIncomeExpenseTransaction";
  final postIncomeExpenseTransactionUrl =
      "http://103.197.204.163/RentMgtAPI/api/IncomeExpenseTransaction/CreateIncomeExpenseTransaction";
  final getSingleIncomeExpenseTransactionUrl =
      "http://103.197.204.163/RentMgtAPI/api/IncomeExpenseTransaction/GetSingleIncomeExpenseTransaction/";
  final putIncomeExpenseTransactionUrl =
      "http://103.197.204.163/RentMgtAPI/api/IncomeExpenseTransaction/UpdateIncomeExpenseTransaction/";
  final deleteIncomeExpenseTransactionUrl =
      "http://103.197.204.163/RentMgtAPI/api/IncomeExpenseTransaction/DeleteIncomeExpenseTransaction/";

  Future<List<IncomeExpenseTransactionModel>> getAllIncomeExpenseTransaction() async {
    try {
      final http.Response response = await http.get(Uri.parse(getIncomeExpenseTransactionUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<IncomeExpenseTransactionModel> allIncomeExpenseTransactionList =
            body.map((e) => IncomeExpenseTransactionModel.fromJson(e)).toList();
      
        return allIncomeExpenseTransactionList;
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

  Future<List<IncomeExpenseTransactionModel>> getSingleIncomeExpenseTransaction(int id) async {
    try {
      final http.Response response =
          await http.get(Uri.parse(getSingleIncomeExpenseTransactionUrl + id.toString()));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<IncomeExpenseTransactionModel> allIncomeExpenseTransactionList =
            body.map((e) => IncomeExpenseTransactionModel.fromJson(e)).toList();

        return allIncomeExpenseTransactionList;
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

  Future<IncomeExpenseTransactionModel> createIncomeExpenseTransaction(IncomeExpenseTransactionModel incomeExpenseTransaction) async {
    final http.Response response = await http.post(Uri.parse(postIncomeExpenseTransactionUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(incomeExpenseTransaction.toJson()));
    if (response.statusCode == 200) {
      return IncomeExpenseTransactionModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create incomeExpenseTransaction.');
    }
  }

  Future<IncomeExpenseTransactionModel> updateIncomeExpenseTransaction(
      {required int id, required IncomeExpenseTransactionModel incomeExpenseTransaction}) async {
    final http.Response response = await http.put(
      Uri.parse(putIncomeExpenseTransactionUrl + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(incomeExpenseTransaction.toJson()),
    );

    if (response.statusCode == 200) {
      return IncomeExpenseTransactionModel.fromJson(jsonDecode(response.body));
    } else {
      print(Uri.parse(putIncomeExpenseTransactionUrl + id.toString()));
      throw Exception('Failed to update incomeExpenseTransaction.');
    }
  }

  Future<IncomeExpenseTransactionModel> deleteIncomeExpenseTransaction(int id) async {
    final http.Response response = await http.delete(
      Uri.parse(deleteIncomeExpenseTransactionUrl + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return IncomeExpenseTransactionModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete incomeExpenseTransaction.');
    }
  }
}
