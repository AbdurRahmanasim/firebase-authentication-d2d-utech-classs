import 'dart:convert';

import 'package:authtesting/class20/screens/subScreens/postReview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reviews extends StatefulWidget {
  const Reviews({super.key});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  final Stream<QuerySnapshot> _reviewsStream = FirebaseFirestore.instance
      .collection('reviews')
      .orderBy('date', descending: true)
      .snapshots();

  Future getuserData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var getData = json.decode(_prefs.getString("userDetail") ?? "");
    print(getData.runtimeType);

    return getData;
  }

  updateItem(docID) async {
    CollectionReference items =
        FirebaseFirestore.instance.collection('reviews');

    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var getData = json.decode(_prefs.getString("userDetail") ?? "");
    print(getData.runtimeType);
    items.doc(docID).update({
      'email': getData['email'],
      'name': getData['name'],
      'rating': activeStars,
      "role": getData['role'],
      "review": _reviewController.text.trim(),
      "date": DateTime.now(),
    }).then((value) {
      print("Item Updated");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('SuccessFully Updated Review'),
        ),
      );
      Navigator.of(context).pop();
    }).catchError((error) {
      print("Failed to Update Item: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Update Review'),
        ),
      );
      Navigator.of(context).pop();
    });
  }

  deleteReview(docId) {
    CollectionReference items =
        FirebaseFirestore.instance.collection('reviews');

    items.doc(docId).delete();
  }

  TextEditingController _reviewController = TextEditingController();
  int activeStars = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PostReview(),
          ));
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Text(
                "ALL REVIEWS",
                style: TextStyle(fontSize: 35),
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
                future: getuserData(),
                builder: (context, snapshot0) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: _reviewsStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      return ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 239, 234, 234),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: width / 1.3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(data['review']),
                                            Text("From : " + data['email']),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    data['rating'] > 0
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    size: width / 40,
                                                    color: const Color.fromARGB(
                                                        255, 189, 167, 0),
                                                  ),
                                                  Icon(
                                                    data['rating'] > 1
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    size: width / 40,
                                                    color: const Color.fromARGB(
                                                        255, 189, 167, 0),
                                                  ),
                                                  Icon(
                                                    data['rating'] > 2
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    size: width / 40,
                                                    color: const Color.fromARGB(
                                                        255, 189, 167, 0),
                                                  ),
                                                  Icon(
                                                    data['rating'] > 3
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    size: width / 40,
                                                    color: const Color.fromARGB(
                                                        255, 189, 167, 0),
                                                  ),
                                                  Icon(
                                                    data['rating'] > 4
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    size: width / 40,
                                                    color: const Color.fromARGB(
                                                        255, 189, 167, 0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  snapshot0.data["email"] == data['email']
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Update Item Data"),
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const SizedBox(
                                                                height: 10),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          activeStars =
                                                                              1;
                                                                        });
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        activeStars >
                                                                                0
                                                                            ? Icons.star
                                                                            : Icons.star_border,
                                                                        size: width /
                                                                            25,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            189,
                                                                            167,
                                                                            0),
                                                                      )),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          activeStars =
                                                                              2;
                                                                        });
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        activeStars >
                                                                                1
                                                                            ? Icons.star
                                                                            : Icons.star_border,
                                                                        size: width /
                                                                            25,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            189,
                                                                            167,
                                                                            0),
                                                                      )),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          activeStars =
                                                                              3;
                                                                        });
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        activeStars >
                                                                                2
                                                                            ? Icons.star
                                                                            : Icons.star_border,
                                                                        size: width /
                                                                            25,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            189,
                                                                            167,
                                                                            0),
                                                                      )),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          activeStars =
                                                                              4;
                                                                        });
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        activeStars >
                                                                                3
                                                                            ? Icons.star
                                                                            : Icons.star_border,
                                                                        size: width /
                                                                            25,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            189,
                                                                            167,
                                                                            0),
                                                                      )),
                                                                  IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          activeStars =
                                                                              5;
                                                                        });
                                                                      },
                                                                      icon:
                                                                          Icon(
                                                                        activeStars >
                                                                                4
                                                                            ? Icons.star
                                                                            : Icons.star_border,
                                                                        size: width /
                                                                            25,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            189,
                                                                            167,
                                                                            0),
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width: width /
                                                                      1.4,
                                                                  child:
                                                                      TextField(
                                                                    maxLines: 4,
                                                                    controller:
                                                                        _reviewController,
                                                                    decoration: InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        hintText:
                                                                            "Enter Review"),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            SizedBox(
                                                                width:
                                                                    width / 2,
                                                                child:
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Colors
                                                                                .deepOrange),
                                                                        onPressed:
                                                                            () {
                                                                          updateItem(
                                                                              document.id);
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Update Review",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ))),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: Colors.blue,
                                                )),
                                            IconButton(
                                                onPressed: () {
                                                  deleteReview(document.id);
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
