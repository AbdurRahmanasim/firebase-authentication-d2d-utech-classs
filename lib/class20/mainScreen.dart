import 'dart:convert';

import 'package:authtesting/class20/screens/analytics.dart';
import 'package:authtesting/class20/screens/dashboard.dart';
import 'package:authtesting/class20/screens/home.dart';
import 'package:authtesting/class20/screens/profile.dart';
import 'package:authtesting/class20/screens/reviews.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> screens = const [
    Home(),
    Dashboard(),
    Analytics(),
    Profile(),
    Reviews()
  ];

  final List<IconData> icons = const [
    Icons.home,
    Icons.dashboard,
    Icons.analytics,
    Icons.person,
    Icons.reviews
  ];

  final List<String> screenNames = const [
    "Home",
    "Dashboard",
    "Analytics",
    "Profile",
    "Reviews"
  ];

  final Map permissions = {
    "User": [0, 1, 3, 4],
    "Shop Owner": [0, 1, 4],
    "Admin": [0, 1, 2, 3, 4],
  };

  int activeScreen = 0;
  // final scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  Future getuserData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var getData = json.decode(_prefs.getString("userDetail") ?? "");
    print(getData.runtimeType);

    return getData;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent,
        title: Text("MainScreen"),
      ),
      drawer: FutureBuilder(
        future: getuserData(),
        builder: (context, snapshot) {
          return SidebarX(
            controller: _controller,
            theme: SidebarXTheme(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: canvasColor,
                borderRadius: BorderRadius.circular(20),
              ),
              hoverColor: scaffoldBackgroundColor,
              textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
              selectedTextStyle: const TextStyle(color: Colors.white),
              itemTextPadding: const EdgeInsets.only(left: 30),
              selectedItemTextPadding: const EdgeInsets.only(left: 30),
              itemDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: canvasColor),
              ),
              selectedItemDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: actionColor.withOpacity(0.37),
                ),
                gradient: const LinearGradient(
                  colors: [accentCanvasColor, canvasColor],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 120, 62, 124),
                    blurRadius: 30,
                  )
                ],
              ),
              iconTheme: IconThemeData(
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              selectedIconTheme: const IconThemeData(
                color: Colors.white,
                size: 20,
              ),
            ),
            extendedTheme: const SidebarXTheme(
              width: 200,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 53, 1, 51),
              ),
            ),
            footerDivider: divider,
            headerBuilder: (context, extended) {
              return SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Image.asset(
                    "assets/logo5.png",
                    color: Colors.white,
                  ),
                ),
              );
            },
            items: [
              for (int i = 0;
                  i < permissions[snapshot.data['role']].length;
                  i++)
                SidebarXItem(
                  icon: icons[permissions[snapshot.data['role']][i]],
                  label: screenNames[permissions[snapshot.data['role']][i]],
                  onTap: () {
                    activeScreen = permissions[snapshot.data['role']][i];
                    setState(() {});
                  },
                )
              // SidebarXItem(
              //   icon: Icons.dashboard,
              //   label: 'Dashboard',
              //   onTap: () {
              //     activeScreen = 1;
              //     setState(() {});
              //   },
              // ),
              // SidebarXItem(
              //   icon: Icons.dashboard,
              //   label: 'Analytics',
              //   onTap: () {
              //     activeScreen = 2;
              //     setState(() {});
              //   },
              // ),
              // SidebarXItem(
              //   icon: Icons.person,
              //   label: 'Profile',
              //   onTap: () {
              //     activeScreen = 3;
              //     setState(() {});
              //   },
              // ),
            ],
          );
        },
      ),
      body: SafeArea(
        child: screens[activeScreen],
      ),
    );
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color.fromARGB(255, 53, 0, 50);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color.fromARGB(255, 124, 68, 124);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);
