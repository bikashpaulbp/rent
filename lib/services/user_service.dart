import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:rent_management/models/user_model.dart';

class UserApiService {
  final getUsersUrl = "http://103.197.204.163/RentMgtAPI/api/User/GetAllUser";
  final postUserUrl = "http://103.197.204.163/RentMgtAPI/api/User/CreateUser";
  final getSingleUserUrl =
      "http://103.197.204.163/RentMgtAPI/api/User/GetSingleUser/";
  final putUserUrl = "http://103.197.204.163/RentMgtAPI/api/User/UpdateUser/";
  final loginUserUrl = "http://103.197.204.163/RentMgtAPI/api/User/Login/";
  final deleteUserUrl =
      "http://103.197.204.163/RentMgtAPI/api/User/DeleteUser/";
  bool isLoggedIn = false;
  Future<List<UserModel>> getAllUsers() async {
    try {
      final http.Response response = await http.get(Uri.parse(getUsersUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<UserModel> allUserList =
            body.map((e) => UserModel.fromJson(e)).toList();
        print(response.statusCode);
        return allUserList;
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

  Future<List<UserModel>> getSingleUser(int id) async {
    try {
      final http.Response response =
          await http.get(Uri.parse(getSingleUserUrl + id.toString()));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> body = json['data'];
        List<UserModel> allUserList =
            body.map((e) => UserModel.fromJson(e)).toList();

        return allUserList;
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

  Future<UserModel> createUser(UserModel user) async {
    final http.Response response = await http.post(Uri.parse(postUserUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()));
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future<UserModel> loginUser(
      {required String email, required String password}) async {
    try {
      final Map<String, dynamic> data = {
        'email': email,
        'password': password,
      };

      final response = await http.post(
        Uri.parse(loginUserUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        dynamic userJson = json['data'];
        UserModel loggedInUser = UserModel.fromJson(userJson);
        return loggedInUser;
      } else if (response.statusCode == 404) {
        print("Data not found (404)");
        return UserModel();
      } else {
        throw "Request failed with status: ${response.statusCode}";
      }
    } catch (e) {
      if (e is SocketException) {
        print("Network error: ${e.message}");
        return UserModel();
      } else {
        print("Error: $e");
        rethrow;
      }
    }
  }
  // Future<UserModel> loginUser(UserModel user) async {
  //   final http.Response response = await http.post(Uri.parse(loginUserUrl),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(user.toJson()));
  //   final data = json.decode(response.body);
  //   // Check if the response body contains email and password.
  //   if (data.containsKey('email') && data.containsKey('password')) {
  //     isLoggedIn = true;
  //   } else {
  //     isLoggedIn = false;
  //   }
  //   return json.decode(response.body);
  // }

  Future<UserModel> updateUser(
      {required int id, required UserModel user}) async {
    final http.Response response = await http.put(
      Uri.parse(putUserUrl + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      print(Uri.parse(putUserUrl + id.toString()));
      throw Exception('Failed to update user.');
    }
  }

  Future<UserModel> deleteUser(int id) async {
    final http.Response response = await http.delete(
      Uri.parse(deleteUserUrl + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete user.');
    }
  }
}
