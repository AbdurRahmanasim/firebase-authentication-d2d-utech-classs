import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future getuserData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var getData = json.decode(_prefs.getString("userDetail") ?? "");
    print(getData.runtimeType);

    return getData;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Center(
            child: Text(
              "Profile Page",
              style: TextStyle(fontSize: 40),
            ),
          ),
          FutureBuilder(
            future: getuserData(),
            builder: (context, snapshot) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      "User name : ${snapshot.data["name"]}",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Center(
                    child: Text(
                      "User Email : ${snapshot.data["email"]}",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Center(
                    child: Text(
                      "User Role : ${snapshot.data["role"]}",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
