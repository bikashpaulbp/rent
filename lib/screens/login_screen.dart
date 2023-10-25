import 'dart:convert';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/dashboard_page.dart';
import 'package:rent_management/services/user_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthStateManager {
  bool isLoggedIn = false;

  Future<void> setIsLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    this.isLoggedIn = true;
  }

  Future<void> removeIsLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    this.isLoggedIn = false;
  }

  Future<bool> getIsLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> saveLoggedInUser(UserModel loggedInUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(loggedInUser.toJson());
    prefs.setString('loggedInUser', userJson);
    setIsLoggedIn(isLoggedIn);
  }

  Future<UserModel?> getLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('loggedInUser');
    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      return UserModel.fromJson(userMap);
    } else {
      return null;
    }
  }

  Future<void> removeLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('loggedInUser');
    removeIsLoggedIn(isLoggedIn);
  }

  UserModel loggedInUser = UserModel();
}

class ChooseScreen extends StatefulWidget {
  const ChooseScreen({Key? key}) : super(key: key);

  @override
  _ChooseScreenState createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  Future<void> checkInternetConnection() async {
    bool isConnected = await DataConnectionChecker().hasConnection;
    if (!isConnected) {
      ScaffoldMessenger.of(context as BuildContext)
          .showSnackBar(SnackBar(content: Text("No internet connection")));
    }
  }

  AuthStateManager authStateManager = AuthStateManager();
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: authStateManager.getIsLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          isLoggedIn = snapshot.data ?? false;
          if (isLoggedIn) {
            return Dashboard();
          } else {
            return LoginAndRegisterScreen();
          }
        }
      },
    );
  }
}

class LoginAndRegisterScreen extends StatefulWidget {
  const LoginAndRegisterScreen({super.key});
  @override
  State<LoginAndRegisterScreen> createState() => _LoginAndRegisterScreenState();
}

class _LoginAndRegisterScreenState extends State<LoginAndRegisterScreen> {
  AuthStateManager authStateManager = AuthStateManager();
  bool loginScreenVisible = true;
  bool showLoading = false;
  String email = '';
  String password = '';

  UserApiService userApiService = UserApiService();
  List<UserModel> userList = [];

  @override
  void initState() {
    getAllUser();
    super.initState();
  }

  Future<void> getAllUser() async {
    userList = await userApiService.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(loginScreenVisible ? 'Login' : 'Signup'),
        backgroundColor: Color.fromARGB(255, 0, 179, 206),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 200),
        child: Column(
          children: [
            inputField('email'),
            inputField('password'),
            !loginScreenVisible ? SizedBox() : forgotPassword(),
            loginRegisterButton(context),
          ],
        ),
      ),
    );
  }

  Widget inputField(fieldType) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        onChanged: (value) {
          setState(() {
            if (fieldType == 'email') {
              email = value;
            }
            if (fieldType == 'password') {
              password = value;
            }
          });
        },
        cursorColor: const Color.fromARGB(255, 144, 144, 144),
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: const Color.fromARGB(255, 121, 121, 121))),
            hintText:
                fieldType == 'email' ? 'Enter email...' : 'Enter password...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
      ),
    );
  }

  /// Forgot password ///
  Widget forgotPassword() {
    return Align(
        alignment: Alignment.centerRight,
        child: Text(
          'Contact Your Admin If You Forgot Password',
          style: TextStyle(
              color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 13),
        ));
  }

  /// Login and Register Button
  Widget loginRegisterButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 31, bottom: 21),
      child: MaterialButton(
          onPressed: email.isEmpty || password.isEmpty
              ? null
              : () async {
                  setState(() {});
                  showLoading = true;
                  if (loginScreenVisible) {
                    try {
                      print('get it now');
                      UserModel loggedInUser = await userApiService.loginUser(
                          email: email, password: password);

                      if (loggedInUser.password!.isNotEmpty) {
                        await authStateManager
                            .saveLoggedInUser(loggedInUser)
                            .then((_) {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => Dashboard(),
                          ));
                        });
                      }

                      print(loggedInUser.password);
                      print('get it');
                    } catch (e) {
                      if (userApiService.isLoggedIn == false) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Invalid email or password')));
                      }
                    }
                    setState(() {
                      showLoading = false;
                    });
                  }
                  if (!loginScreenVisible) {
                    String? checkEmail;
                    try {
                      checkEmail =
                          userList.firstWhere((e) => e.email == email).email;
                    } catch (e) {}
                    if (checkEmail == null || checkEmail.isEmpty) {
                      await userApiService.createUser(UserModel(
                          email: email,
                          password: password,
                          isActive: true,
                          isLoggedIn: true,
                          isAdmin: true,
                          isRegularUser: false,
                          mobileNo: "",
                          name: "",
                          propertyInfoId: 5));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('User registered successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User already exists')),
                      );
                    }
                    setState(() {
                      showLoading = false;
                    });
                  }
                },
          padding: EdgeInsets.symmetric(vertical: 13),
          minWidth: double.infinity,
          color: const Color.fromARGB(255, 139, 139, 139),
          disabledColor: Colors.grey.shade300,
          textColor: Colors.white,
          child: showLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Text('Login')),
    );
  }
}
