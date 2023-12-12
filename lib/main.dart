// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

import 'package:rent_management/shared_data/building_provider.dart';
import 'package:rent_management/shared_data/deposit_data.dart';
import 'package:rent_management/shared_data/flat_data.dart';
import 'package:rent_management/shared_data/floor_data.dart';
import 'package:rent_management/shared_data/local_info_provider.dart';
import 'package:rent_management/shared_data/rent_data.dart';
import 'package:rent_management/shared_data/tenent_data.dart';

import 'package:rent_management/splash_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => FloorData()),
      ChangeNotifierProvider(create: (context) => FlatData()),
      ChangeNotifierProvider(create: (context) => TenantData()),
      ChangeNotifierProvider(create: (context) => RentData()),
      ChangeNotifierProvider(create: (context) => DepositData()),
      ChangeNotifierProvider(create: (context) => BuildingProvider()),
      ChangeNotifierProvider(create: (context) => LocalData()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rent Management - For Ashek Mahmud',
        home: SplashScreen());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var tapColor = const Color.fromARGB(255, 64, 175, 255);
  var tapIconColor = const Color.fromARGB(255, 255, 255, 255);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 93, 93, 93),
          title: const Text('Rent Management - For Ashek Mahmud'),
        ),
        body: Container());
  }
}
