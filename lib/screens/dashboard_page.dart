import 'dart:async';
import 'package:bottom_nav_bar/bottom_nav_bar.dart';

import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:rent_management/screens/flat_page.dart';
import 'package:rent_management/screens/tenent_page.dart';

import 'floor_page.dart';
import 'monthly_rent_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  // var tapColor = const Color.fromARGB(255, 121, 121, 121);
  // var tapIconColor = const Color.fromARGB(255, 255, 255, 255);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      bottomNavigationBar: _bottomNavBar(),
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 125, 125, 125),
      //   centerTitle: true,
      //   title: const Center(
      //     child: Text(
      //       'Dashboard',
      //       style: TextStyle(fontSize: 20),
      //     ),
      //   ),
      // ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Container(
      //         height: 100,
      //         child: SingleChildScrollView(
      //           scrollDirection: Axis.horizontal,
      //           child: Row(
      //             children: [
      //               Column(
      //                 mainAxisAlignment: MainAxisAlignment.start,
      //                 crossAxisAlignment: CrossAxisAlignment.center,
      //                 children: [
      //                   AnimatedIconButton(
      //                     size: 40,
      //                     onPressed: () {
      //                       setState(() {
      //                         tapColor =
      //                             const Color.fromARGB(255, 255, 255, 255);
      //                         tapIconColor =
      //                             const Color.fromARGB(255, 203, 203, 203);
      //                         Timer(const Duration(milliseconds: 500), () {
      //                           Navigator.push(
      //                               context,
      //                               MaterialPageRoute(
      //                                   builder: (context) =>
      //                                       const FloorPage()));
      //                         });
      //                       });
      //                     },
      //                     duration: const Duration(milliseconds: 500),
      //                     splashRadius: 30,
      //                     splashColor: Colors.transparent,
      //                     icons: const <AnimatedIconItem>[
      //                       AnimatedIconItem(
      //                         icon: Icon(Icons.stairs,
      //                             color: Color.fromARGB(255, 159, 168, 183)),
      //                       ),
      //                     ],
      //                   ),
      //                   const Text(
      //                     'Floor',
      //                     style: TextStyle(fontSize: 14),
      //                   ),
      //                 ],
      //               ),
      //               Column(
      //                 mainAxisAlignment: MainAxisAlignment.start,
      //                 crossAxisAlignment: CrossAxisAlignment.center,
      //                 children: [
      //                   AnimatedIconButton(
      //                     size: 40,
      //                     onPressed: () {
      //                       setState(() {
      //                         tapColor =
      //                             const Color.fromARGB(255, 255, 255, 255);
      //                         tapIconColor =
      //                             const Color.fromARGB(255, 203, 203, 203);

      //                         Timer(const Duration(milliseconds: 500), () {
      //                           Navigator.push(
      //                               context,
      //                               MaterialPageRoute(
      //                                   builder: (context) =>
      //                                       const FlatPage()));
      //                         });
      //                       });
      //                     },
      //                     duration: const Duration(milliseconds: 500),
      //                     splashColor: Colors.transparent,
      //                     splashRadius: 30,
      //                     icons: const <AnimatedIconItem>[
      //                       AnimatedIconItem(
      //                         icon: Icon(Icons.home,
      //                             color: Color.fromARGB(255, 159, 168, 183)),
      //                       ),
      //                     ],
      //                   ),
      //                   const Text(
      //                     'Flat',
      //                     style: TextStyle(fontSize: 14),
      //                   ),
      //                 ],
      //               ),
      //               Column(
      //                 mainAxisAlignment: MainAxisAlignment.start,
      //                 crossAxisAlignment: CrossAxisAlignment.center,
      //                 children: [
      //                   AnimatedIconButton(
      //                     size: 40,
      //                     onPressed: () {
      //                       setState(() {
      //                         tapColor =
      //                             const Color.fromARGB(255, 255, 255, 255);
      //                         tapIconColor =
      //                             const Color.fromARGB(255, 203, 203, 203);

      //                         Timer(const Duration(milliseconds: 500), () {
      //                           Navigator.push(
      //                               context,
      //                               MaterialPageRoute(
      //                                   builder: (context) => TenentPage()));
      //                         });
      //                       });
      //                     },
      //                     duration: const Duration(milliseconds: 500),
      //                     splashColor: Colors.transparent,
      //                     splashRadius: 30,
      //                     icons: const <AnimatedIconItem>[
      //                       AnimatedIconItem(
      //                         icon: Icon(Icons.people_alt,
      //                             color: Color.fromARGB(255, 159, 168, 183)),
      //                       ),
      //                     ],
      //                   ),
      //                   const Text(
      //                     'Tenent',
      //                     style: TextStyle(fontSize: 14),
      //                   ),
      //                 ],
      //               ),
      //               Column(
      //                 mainAxisAlignment: MainAxisAlignment.start,
      //                 crossAxisAlignment: CrossAxisAlignment.center,
      //                 children: [
      //                   AnimatedIconButton(
      //                     size: 40,
      //                     onPressed: () {
      //                       setState(() {
      //                         tapColor =
      //                             const Color.fromARGB(255, 255, 255, 255);
      //                         tapIconColor =
      //                             const Color.fromARGB(255, 203, 203, 203);

      //                         Timer(const Duration(milliseconds: 500), () {
      //                           Navigator.push(
      //                               context,
      //                               MaterialPageRoute(
      //                                   builder: (context) => MonthlyRent()));
      //                         });
      //                       });
      //                     },
      //                     duration: const Duration(milliseconds: 500),
      //                     splashColor: Colors.transparent,
      //                     splashRadius: 30,
      //                     icons: const <AnimatedIconItem>[
      //                       AnimatedIconItem(
      //                         icon: Icon(Icons.monetization_on,
      //                             color: Color.fromARGB(255, 159, 168, 183)),
      //                       ),
      //                     ],
      //                   ),
      //                   const Text(
      //                     'Rent',
      //                     style: TextStyle(fontSize: 14),
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(20.0),
      //         child: Center(
      //           child: Container(
      //             decoration: BoxDecoration(
      //                 color: const Color.fromARGB(255, 230, 230, 230),
      //                 borderRadius: BorderRadius.circular(10),
      //                 boxShadow: [
      //                   BoxShadow(
      //                     color: const Color.fromARGB(255, 180, 180, 180)
      //                         .withOpacity(0.5),
      //                     spreadRadius: 5,
      //                     blurRadius: 7,
      //                     offset: const Offset(0, 3),
      //                   ),
      //                 ]),
      //             width: 500,
      //             height: 400,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _body() => SizedBox.expand(
        child: IndexedStack(
          index: _currentIndex,
          children: const <Widget>[
            FloorPage(),
            FlatPage(),
            TenentPage(),
            MonthlyRent(),
          ],
        ),
      );

  Widget _bottomNavBar() => BottomNavBar(
        itemCornerRadius: 15,
        backgroundColor: const Color.fromARGB(157, 255, 193, 7),
        containerPadding: EdgeInsets.all(2),
        curve: Curves.easeInOutCubicEmphasized,
        showElevation: true,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
        },
        items: <BottomNavBarItem>[
          BottomNavBarItem(
            title: 'Floor',
            icon: const Icon(Icons.stairs),
            activeColor: Colors.white,
            inactiveColor: Colors.black,
            activeBackgroundColor: const Color.fromARGB(255, 229, 115, 115),
          ),
          BottomNavBarItem(
            title: 'Flat',
            icon: const Icon(Icons.home),
            activeColor: Colors.white,
            inactiveColor: Colors.black,
            activeBackgroundColor: Colors.blue.shade300,
          ),
          BottomNavBarItem(
            title: 'Tenent',
            icon: const Icon(Icons.people_alt),
            inactiveColor: Colors.black,
            activeColor: Colors.white,
            activeBackgroundColor: Colors.green.shade300,
          ),
          BottomNavBarItem(
            title: 'Rent',
            icon: const Icon(Icons.monetization_on),
            inactiveColor: Colors.black,
            activeColor: Colors.black,
            activeBackgroundColor: Colors.yellow.shade300,
          ),
        ],
      );
}
