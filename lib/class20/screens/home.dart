import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String dropdownVal = "Item 1";
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          width: width / 2,
          child: DropdownButton(
            
              value: dropdownVal,
              items: [
                DropdownMenuItem(
                  child: Text("Item 1"),
                  value: "Item 1",
                ),
                DropdownMenuItem(
                  child: Text("Item 2"),
                  value: "Item 2",
                ),
              ],
              onChanged: (val) {
                setState(() {
                  dropdownVal = val!;
                });
              }),
        ),
        Center(
          child: Text(
            "Home",
            style: TextStyle(fontSize: 40),
          ),
        ),
      ],
    );
  }
}
