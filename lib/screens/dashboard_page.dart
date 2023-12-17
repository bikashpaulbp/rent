import 'package:bottom_nav_bar/bottom_nav_bar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/building_page.dart';
import 'package:rent_management/screens/count_page.dart';
import 'package:rent_management/screens/flat_page.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/screens/print_rent.dart';
import 'package:rent_management/screens/tenent_page.dart';

import 'floor_page.dart';
import 'monthly_rent_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String name = "";
  String email = "";
  int _currentIndex = 0;
  AuthStateManager authStateManager = AuthStateManager();
  UserModel? loggedInUser = UserModel();
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
  void initState() {
    fetchLoggedInUser();

    setState(() {
      refresh();
    });

    super.initState();
  }

  void refresh() {}

  Future<UserModel?> fetchLoggedInUser() async {
    return loggedInUser = await authStateManager.getLoggedInUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rent Managemet"),
        backgroundColor: const Color.fromARGB(255, 0, 179, 206),
      ),
      key: _scaffoldKey,
      body: SizedBox.expand(
        child: Container(
            height: MediaQuery.sizeOf(context).height * 1, child: _body()),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.045,
            ),
            Container(
              width: MediaQuery.sizeOf(context).width * 1,
              height: MediaQuery.sizeOf(context).height * 0.15,
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 218, 218, 218)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      FutureBuilder<UserModel?>(
                        future: fetchLoggedInUser(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else if (snapshot.hasData) {
                            UserModel? loggedInUser = snapshot.data;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Text(
                                    "Hi! ${loggedInUser!.name}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromARGB(255, 152, 152, 152),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "${loggedInUser.email}",
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 152, 152, 152),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const Text("No user data available.");
                          }
                        },
                      ),
                    ]),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    _closeDrawer();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BuildingPage()));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(children: [
                      Icon(
                        Icons.apartment,
                        color: Colors.amber,
                        size: 30,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Building",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 238, 155, 30),
                        ),
                      )
                    ]),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    _closeDrawer();
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => BuildingPage()));
                    Get.to(const PrintRent());
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(children: [
                      Icon(
                        Icons.print,
                        color: Color.fromARGB(255, 30, 238, 37),
                        size: 30,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Print Rent Receipt",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 30, 238, 37),
                        ),
                      )
                    ]),
                  )),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "You are done!",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 152, 152, 152)),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 90, 215, 232))),
                    onPressed: () async {
                      await authStateManager.removeBuildingId();
                      await authStateManager.removeBuildingName();
                      await authStateManager.removeLoggedInUser().then((_) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ChooseScreen(),
                        ));
                      });
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('Log Out'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawerEnableOpenDragGesture: false,
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  Widget _body() => SizedBox.expand(
        child: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            CountPage(),
            const FloorPage(),
            const TenentPage(),
            const FlatPage(),
            const MonthlyRent(),
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
                title: 'Tenent',
                icon: const Icon(Icons.people_alt),
                inactiveColor: Colors.black,
                activeColor: Colors.white,
                activeBackgroundColor: const Color.fromARGB(255, 102, 240, 109),
              ),
              BottomNavBarItem(
                title: 'Flat',
                icon: const Icon(Icons.home),
                activeColor: Colors.white,
                inactiveColor: Colors.black,
                activeBackgroundColor: const Color.fromARGB(255, 73, 173, 255),
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
