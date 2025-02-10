import 'package:authtesting/class20/screens/subScreens/postReview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
            StreamBuilder<QuerySnapshot>(
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
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 239, 234, 234),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        padding: const EdgeInsets.all(8.0),
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
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    )),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
