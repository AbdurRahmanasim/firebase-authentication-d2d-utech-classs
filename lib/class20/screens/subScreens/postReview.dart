import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostReview extends StatefulWidget {
  const PostReview({super.key});

  @override
  State<PostReview> createState() => _PostReviewState();
}

class _PostReviewState extends State<PostReview> {
  TextEditingController _reviewController = TextEditingController();

  int activeStars = 5;

  postReview() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var getData = json.decode(_prefs.getString("userDetail") ?? "");
    print(getData.runtimeType);

    CollectionReference review =
        FirebaseFirestore.instance.collection('reviews');

    review.add({
      'email': getData['email'],
      'name': getData['name'],
      'rating': activeStars,
      "role": getData['role'],
      "review": _reviewController.text.trim(),
      "date": DateTime.now(),
    }).then((value) {
      print("Item Added");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('SuccessFully Posted Review'),
        ),
      );
      Navigator.of(context).pop();
    }).catchError((error) {
      print("Failed to add Item: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Post Review'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Review"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Text(
                "POST REVIEW",
                style: TextStyle(fontSize: 35),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          activeStars = 1;
                        });
                      },
                      icon: Icon(
                        activeStars > 0 ? Icons.star : Icons.star_border,
                        size: width / 12,
                        color: const Color.fromARGB(255, 189, 167, 0),
                      )),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          activeStars = 2;
                        });
                      },
                      icon: Icon(
                        activeStars > 1 ? Icons.star : Icons.star_border,
                        size: width / 12,
                        color: const Color.fromARGB(255, 189, 167, 0),
                      )),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          activeStars = 3;
                        });
                      },
                      icon: Icon(
                        activeStars > 2 ? Icons.star : Icons.star_border,
                        size: width / 12,
                        color: const Color.fromARGB(255, 189, 167, 0),
                      )),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          activeStars = 4;
                        });
                      },
                      icon: Icon(
                        activeStars > 3 ? Icons.star : Icons.star_border,
                        size: width / 12,
                        color: const Color.fromARGB(255, 189, 167, 0),
                      )),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          activeStars = 5;
                        });
                      },
                      icon: Icon(
                        activeStars > 4 ? Icons.star : Icons.star_border,
                        size: width / 12,
                        color: const Color.fromARGB(255, 189, 167, 0),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width / 1.1,
                  child: TextField(
                    maxLines: 4,
                    controller: _reviewController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Enter Review"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
                width: width / 1.1,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange),
                    onPressed: () async {
                      postReview();
                    },
                    child: Text(
                      "ADD REVIEW",
                      style: TextStyle(color: Colors.white),
                    ))),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
