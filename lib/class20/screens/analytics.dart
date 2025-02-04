import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Analytics",
        style: TextStyle(fontSize: 40),
      ),
    );
  }
}
