import 'dart:convert';

import 'package:authtesting/class20/mainScreen.dart';
import 'package:authtesting/home.dart';
import 'package:authtesting/signUp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwwordController = TextEditingController();

  loginwithfirebase() async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwwordController.text.trim())
          .then(
        (value) async {
          final _db = FirebaseFirestore.instance;
          final snapshot = await _db.collection('users').get();
          print(snapshot.docs.map((e) async {
            if (e.data()['userEmail'] == _emailController.text.trim()) {
              SharedPreferences _prefs = await SharedPreferences.getInstance();

              Map userData = {
                "email": e.data()['userEmail'],
                "name": e.data()['userName'],
                "role": e.data()['role']
              };
              _prefs.setString("userDetail", json.encode(userData));

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => MainScreen(),
              ));

              print("SuccessFully Logged In");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('SuccessFully Logged In'),
                ),
              );
            }
          }));
        },
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect email or Password'),
        ),
      );
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Login"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width / 2,
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: "Enter Email"),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width / 2,
                child: TextField(
                  controller: _passwwordController,
                  decoration: InputDecoration(hintText: "Enter Password"),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          SizedBox(
              width: width / 2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange),
                  onPressed: () {
                    loginwithfirebase();
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ))),
          SizedBox(height: 10),
          Text("New User "),
          InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Signup(),
                ));
              },
              child: Text("Click here to Signup")),
        ],
      ),
    );
  }
}
