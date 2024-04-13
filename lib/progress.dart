import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text(
          "B L U E     E Y E",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.blue[100],
        child: CircularPercentIndicator(
          radius: 130,
          lineWidth: 20,
          percent: 0.1,
          progressColor: Colors.blue,
          backgroundColor: Colors.blue.shade200,
          circularStrokeCap: CircularStrokeCap.round,
          center: const Text(
            "10%",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
