import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _itemController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  addItem() {
    CollectionReference items = FirebaseFirestore.instance.collection('items');

    items
        .add({
          'itemName': _itemController.text.trim(),
          'price': int.parse(_priceController.text.trim()),
        })
        .then((value) => print("Item Added"))
        .catchError((error) => print("Failed to add Item: $error"));
  }

  final Stream<QuerySnapshot> _itemsStream =
      FirebaseFirestore.instance.collection('items').snapshots();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME PAGE"),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Text("HOME PAGE"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width / 2,
                  child: TextField(
                    controller: _itemController,
                    decoration: InputDecoration(hintText: "Enter ItemName"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width / 2,
                  child: TextField(
                    controller: _priceController,
                    decoration: InputDecoration(hintText: "Enter Price"),
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
                      addItem();
                    },
                    child: Text(
                      "Add Item",
                      style: TextStyle(color: Colors.white),
                    ))),
            SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: _itemsStream,
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
                    return ListTile(
                      title: Text(
                        data['itemName'],
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        data['price'].toString(),
                        style: TextStyle(color: Colors.black),
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
