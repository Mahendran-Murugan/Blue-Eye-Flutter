import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:water_level_management_system/firebase_options.dart';

class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  final Future<FirebaseApp> _fbaseApp = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('Sensor');

  int current = 0;
  int capacity = 0;
  double calculatedValue = 0;
  double percentage = 0;
  bool motorStatus = false;
  bool isConfigured = false;

  double calculateValue() {
    return (100 - ((current / capacity) * 100)) / 100;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    _dbRef.child("ultra_data").onValue.listen(
      (event) {
        setState(() {
          current = event.snapshot.value as int;
          calculatedValue = calculateValue();
          percentage = (calculatedValue * 100);
        });
      },
    );

    _dbRef.child("max_val").onValue.listen(
      (event) {
        setState(() {
          capacity = event.snapshot.value as int;
        });
      },
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text(
          "Blue Eye",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Container(
        color: (percentage >= 90) ? Colors.red[400] : Colors.blue.shade100,
        alignment: Alignment.center,
        child: FutureBuilder(
          future: _fbaseApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text(
                "Connection Error..!",
                style: TextStyle(),
              );
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  SizedBox(
                    height: size.height * 0.07,
                  ),
                  const Text(
                    "Current Water Level",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  CircularPercentIndicator(
                    radius: 130,
                    lineWidth: 20,
                    percent: (calculatedValue >= 0.0 && calculatedValue <= 1.0)
                        ? calculatedValue
                        : 0,
                    progressColor: Colors.blue,
                    backgroundColor: Colors.blue.shade200,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      "${(percentage >= 0 && percentage <= 100) ? percentage.toStringAsFixed(0) : 0}%",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue.shade400.withOpacity(0.3),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "STATUS REPORT",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.04,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                "Current Level",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Text(
                                " : ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "$current",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                "Total Capacity",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Text(
                                " : ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "$capacity",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
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
