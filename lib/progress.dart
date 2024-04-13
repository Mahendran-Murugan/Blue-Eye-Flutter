import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  final Future<FirebaseApp> _fbaseApp = Firebase.initializeApp();
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('Sensor');

  int current = 0;
  int capacity = 0;
  double calculatedValue = 0;
  int percentage = 0;

  double calculateValue() {
    return (100 - ((current / capacity) * 100)) / 100;
  }

  void setOnce() {
    setState(() {
      capacity = current;
      _dbRef.child('max_val').set(capacity);
    });
  }

  @override
  Widget build(BuildContext context) {
    _dbRef.child("ultra_data").onValue.listen(
      (event) {
        setState(() {
          current = event.snapshot.value as int;
          calculatedValue = calculateValue();
          percentage = (calculatedValue * 100).toInt();
        });
      },
    );
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
        child: FutureBuilder(
          future: _fbaseApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text(
                "Connection Error..!",
                style: TextStyle(),
              );
            } else if (snapshot.hasData) {
              return (capacity != 0)
                  ? Column(
                      children: [
                        CircularPercentIndicator(
                          radius: 130,
                          lineWidth: 20,
                          percent:
                              (calculatedValue >= 0.0 && calculatedValue <= 1.0)
                                  ? calculatedValue
                                  : 0,
                          progressColor: Colors.blue,
                          backgroundColor: Colors.blue.shade200,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(
                            "${(percentage >= 0 && percentage <= 100) ? percentage : 0}%",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text("Current : $current"),
                        Text("Capacity : $capacity"),
                        Text("Calculated Value : $calculatedValue"),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () => setOnce(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[300],
                        padding: const EdgeInsets.all(18),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      child: Text(
                        "Set Maximum $current",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
