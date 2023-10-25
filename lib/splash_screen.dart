import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rent_management/screens/dashboard_page.dart';
import 'package:rent_management/screens/google_signin.dart';
import 'package:rent_management/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ChooseScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        width: double.maxFinite,
        height: double.maxFinite,
        child:
            const Center(child: Image(image: AssetImage('assets/giphy.gif'))),
      ),
    );
  }
}
