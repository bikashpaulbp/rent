import 'package:bottom_nav_bar/bottom_nav_bar.dart';

import 'package:flutter/material.dart';
import 'package:rent_management/screens/count_page.dart';
import 'package:rent_management/screens/flat_page.dart';
import 'package:rent_management/screens/login_screen.dart';
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
  AuthStateManager authStateManager = AuthStateManager();
  // var tapColor = const Color.fromARGB(255, 121, 121, 121);
  // var tapIconColor = const Color.fromARGB(255, 255, 255, 255);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rent Managemet"),
        backgroundColor: Color.fromARGB(255, 0, 179, 206),
      ),
      key: _scaffoldKey,

      body: Container(
          height: MediaQuery.sizeOf(context).height * 1.0, child: _body()),
      drawer: Drawer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('This is the Drawer'),
              ElevatedButton(
                onPressed: () {
                  authStateManager.removeLoggedInUser().then((_) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ChooseScreen(),
                    ));
                  });
                },
                child: const Text('Log Out'),
              ),
            ],
          ),
        ),
      ),
      // Disable opening the drawer with a swipe gesture.
      drawerEnableOpenDragGesture: false,

      bottomNavigationBar: _bottomNavBar(),
    );
  }

  Widget _body() => SizedBox.expand(
        child: IndexedStack(
          index: _currentIndex,
          children: const <Widget>[
            CountPage(),
            FloorPage(),
            FlatPage(),
            TenentPage(),
            MonthlyRent(),
          ],
        ),
      );

  Widget _bottomNavBar() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: 500,
          height: 60,
          child: BottomNavBar(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            itemCornerRadius: 15,
            backgroundColor: const Color.fromARGB(255, 168, 172, 255),
            containerPadding: const EdgeInsets.all(3),
            curve: Curves.easeInOutCubicEmphasized,
            showElevation: true,
            selectedIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() => _currentIndex = index);
            },
            items: <BottomNavBarItem>[
              BottomNavBarItem(
                title: 'Dashboard',
                icon: const Icon(Icons.dashboard),
                activeColor: Colors.white,
                inactiveColor: Colors.black,
                activeBackgroundColor: const Color.fromARGB(217, 74, 54, 255),
              ),
              BottomNavBarItem(
                title: 'Floor',
                icon: const Icon(Icons.stairs),
                activeColor: Colors.white,
                inactiveColor: Colors.black,
                activeBackgroundColor: const Color.fromARGB(255, 224, 108, 62),
              ),
              BottomNavBarItem(
                title: 'Flat',
                icon: const Icon(Icons.home),
                activeColor: Colors.white,
                inactiveColor: Colors.black,
                activeBackgroundColor: const Color.fromARGB(255, 73, 173, 255),
              ),
              BottomNavBarItem(
                title: 'Tenent',
                icon: const Icon(Icons.people_alt),
                inactiveColor: Colors.black,
                activeColor: Colors.white,
                activeBackgroundColor: const Color.fromARGB(255, 102, 240, 109),
              ),
              BottomNavBarItem(
                title: 'Rent',
                icon: const Icon(Icons.monetization_on),
                inactiveColor: Colors.black,
                activeColor: const Color.fromARGB(255, 255, 255, 255),
                activeBackgroundColor: const Color.fromARGB(255, 232, 215, 62),
              ),
            ],
          ),
        ),
      );
}
