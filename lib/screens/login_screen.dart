import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/dashboard_page.dart';
import 'package:rent_management/services/user_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthStateManager {
  bool isLoggedIn = false;

  Future<void> saveBuildingId(int id, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('buildingId', id);
    await prefs.setString('buildingName', name);
  }

  Future<String?> getBuildingName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('buildingName');
  }

  Future<int?> getBuildingId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('buildingId');
  }

  Future<void> removeBuildingName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('buildingName');
  }

  Future<void> removeBuildingId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('buildingId');
  }

  Future<void> setIsLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    this.isLoggedIn = true;
  }

  Future<void> removeIsLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    this.isLoggedIn = false;
  }

  Future<bool> getIsLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> saveLoggedInUser(UserModel loggedInUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(loggedInUser.toJson());
    await prefs.setString('loggedInUser', userJson);
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
    await prefs.remove('loggedInUser');
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
  AuthStateManager authStateManager = AuthStateManager();
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: authStateManager.getIsLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          isLoggedIn = snapshot.data ?? false;
          if (isLoggedIn) {
            return const Dashboard();
          } else {
            return const LoginAndRegisterScreen();
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
        title: const Text('Login'),
        backgroundColor: const Color.fromARGB(255, 0, 179, 206),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
        child: Column(
          children: [
            inputField('email'),
            inputField('password'),
            !loginScreenVisible ? const SizedBox() : forgotPassword(),
            loginRegisterButton(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("New user?"),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const SignUp(),
                      ));
                    },
                    child: const Text("Sign Up"))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget inputField(fieldType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(255, 121, 121, 121))),
            hintText:
                fieldType == 'email' ? 'Enter email...' : 'Enter password...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
      ),
    );
  }

  /// Forgot password ///
  Widget forgotPassword() {
    return const Align(
        alignment: Alignment.centerRight,
        child: Text(
          'Contact Your Admin If You Forgot Password',
          style: TextStyle(
              color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 13),
        ));
  }

  /// Login  Button
  Widget loginRegisterButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 31, bottom: 21),
      child: MaterialButton(
          onPressed: email.isEmpty || password.isEmpty
              ? null
              : () async {
                  setState(() {});
                  showLoading = true;
                  if (loginScreenVisible) {
                    try {
                      UserModel loggedInUser = await userApiService.loginUser(
                          email: email, password: password);

                      if (loggedInUser.password!.isNotEmpty) {
                        await authStateManager
                            .saveLoggedInUser(loggedInUser)
                            .then((_) {
                          print(loggedInUser.name);
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const Dashboard(),
                          ));
                        });
                      }

                      print(loggedInUser.email);
                    } catch (e) {
                      if (userApiService.isLoggedIn == false) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Invalid email or password')));
                      }
                    }
                    setState(() {
                      showLoading = false;
                    });
                  }
                },
          padding: const EdgeInsets.symmetric(vertical: 13),
          minWidth: double.infinity,
          color: const Color.fromARGB(255, 11, 172, 197),
          disabledColor: Colors.grey.shade300,
          textColor: Colors.white,
          child: showLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : const Text('Login')),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "";
  String name = "";
  String password = "";
  String confirmPassword = "";
  String mobile = "";
  UserApiService userApiService = UserApiService();
  List<UserModel> userList = [];

  bool showLoading = false;

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
        title: const Text('Signup'),
        backgroundColor: const Color.fromARGB(255, 0, 179, 206),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
        child: Column(
          children: [
            const Text("Create New User"),
            const SizedBox(
              height: 20,
            ),
            inputField('name'),
            inputField('email'),
            inputField('password'),
            inputField('confirmPassword'),
            inputField('mobile'),
            signUpButton(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Already registered?"),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginAndRegisterScreen(),
                      ));
                    },
                    child: const Text("Login"))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget inputField(fieldType) {
    hintText() {
      if (fieldType == 'name') {
        return "Enter name...";
      } else if (fieldType == 'email') {
        return "Enter email...";
      } else if (fieldType == 'password') {
        return "Enter password...";
      } else if (fieldType == 'confirmPassword') {
        return "Confirm password...";
      } else if (fieldType == 'mobile') {
        return "Enter mobile...";
      }
    }

    hidePassword() {
      if (fieldType == 'password') {
        return true;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        onChanged: (value) {
          setState(() {
            if (fieldType == 'email') {
              email = value;
            }
            if (fieldType == 'password') {
              password = value;
            }
            if (fieldType == 'name') {
              name = value;
            }
            if (fieldType == 'mobile') {
              mobile = value;
            }
            if (fieldType == 'confirmPassword') {
              confirmPassword = value;
            }
          });
        },
        cursorColor: const Color.fromARGB(255, 144, 144, 144),
        decoration: InputDecoration(
            semanticCounterText: "*",
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(255, 121, 121, 121))),
            hintText: hintText(),
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
      ),
    );
  }

  Widget signUpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 31, bottom: 21),
      child: MaterialButton(
          onPressed: email.isEmpty || password.isEmpty
              ? null
              : () async {
                  setState(() {});
                  showLoading = true;

                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('confirm password mismatch')));
                    setState(() {
                      showLoading = false;
                    });
                  } else if (name.isEmpty ||
                      email.isEmpty ||
                      password.isEmpty ||
                      confirmPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('User registered successfully')),
                    );
                    setState(() {
                      showLoading = false;
                    });
                  } else {
                    if (name.isNotEmpty &&
                        email.isNotEmpty &&
                        password.isNotEmpty &&
                        confirmPassword.isNotEmpty) {
                      String? checkEmail;
                      try {
                        userList = await userApiService.getAllUsers();
                        checkEmail =
                            userList.firstWhere((e) => e.email == email).email;
                      } catch (_) {}
                      if (checkEmail == null || checkEmail.isEmpty) {
                        await userApiService
                            .createUser(UserModel(
                          email: email,
                          password: password,
                          mobileNo: mobile,
                          name: name,
                        ))
                            .then((_) {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginAndRegisterScreen(),
                          ));
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('User registered successfully')),
                        );
                        setState(() {
                          showLoading = false;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User already exists')),
                        );
                        setState(() {
                          showLoading = false;
                        });
                      }
                    }
                  }
                },
          padding: const EdgeInsets.symmetric(vertical: 13),
          minWidth: double.infinity,
          color: const Color.fromARGB(255, 11, 172, 197),
          disabledColor: Colors.grey.shade300,
          textColor: Colors.white,
          child: showLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : const Text('Sign Up')),
    );
  }
}
