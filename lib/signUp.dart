import 'package:authtesting/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwwordController = TextEditingController();

  String dropdownVal = "Shop Owner";

  signupwithfirebase() async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwwordController.text.trim(),
      ).then(
        (value) {
          CollectionReference items =
              FirebaseFirestore.instance.collection('users');

          items
              .add({
                'userName': _nameController.text.trim(),
                'userEmail': _emailController.text.trim(),
                'role': dropdownVal,
                'date': DateTime.now()
              })
              .then((value) => print("User Added"))
              .catchError((error) => print("Failed to add User: $error"));

          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Login(),
          ));
          print("SuccessFully SignedUP");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('SuccessFully Signed Up'),
            ),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid Email or Password'),
        ),
      );
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
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
          Text("SignUp"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width / 2,
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: "Enter UserName"),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width / 2,
                child: TextField(
                  decoration: InputDecoration(hintText: "Confirm Password"),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          SizedBox(
            width: width / 2,
            child: DropdownButton(
                value: dropdownVal,
                items: [
                  DropdownMenuItem(
                    child: Text("Shop Owner"),
                    value: "Shop Owner",
                  ),
                  DropdownMenuItem(
                    child: Text("User"),
                    value: "User",
                  ),
                ],
                onChanged: (val) {
                  setState(() {
                    dropdownVal = val!;
                  });
                }),
          ),
          SizedBox(height: 10),
          SizedBox(
              width: width / 2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange),
                  onPressed: () {
                    signupwithfirebase();
                  },
                  child: Text(
                    "Signup",
                    style: TextStyle(color: Colors.white),
                  ))),
          SizedBox(height: 10),
          Text("Already have account"),
          InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Login(),
                ));
              },
              child: Text("Click here to login")),
        ],
      ),
    );
  }
}
