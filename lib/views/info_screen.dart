import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:water_level_management_system/routes/constant.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final Future<FirebaseApp> _fbaseApp = Firebase.initializeApp();
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

  void setOnce() {
    setState(() {
      capacity = current;
      _dbRef.child('max_val').set(capacity);
    });
    Navigator.of(context).pushNamed(progressRoute);
  }

  @override
  Widget build(BuildContext context) {
    _dbRef.child("ultra_data").onValue.listen(
      (event) {
        setState(() {
          current = event.snapshot.value as int;
          calculatedValue = calculateValue();
          percentage = (calculatedValue * 100);
        });
        log("Current is : $current\nCalculated Value is: $calculatedValue\nPercentage is: $percentage\nCapacity is: $capacity");
      },
    );
    _dbRef.child("motor_status").onValue.listen(
      (event) {
        setState(() {
          motorStatus = event.snapshot.value as bool;
        });
      },
    );
    _dbRef.child("configured").onValue.listen(
      (event) {
        setState(() {
          isConfigured = event.snapshot.value as bool;
        });
      },
    );

    Size size = MediaQuery.of(context).size;

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
              return Container(
                height: size.height * 0.6,
                width: size.width * 0.65,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "STATUS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Image.asset(
                      'images/assets/tank_animated.png',
                      width: size.width * 0.46,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Moto Status: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Switch.adaptive(
                          value: motorStatus,
                          onChanged: (value) {
                            motorStatus = value;
                            _dbRef.child("motor_status").set(motorStatus);
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "Configured : ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          isConfigured ? "Yes" : "No",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    (capacity != 0)
                        ? ElevatedButton(
                            onPressed: () => {
                              Navigator.of(context).pushNamed(progressRoute)
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[300],
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              "View Details",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () => setOnce(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[300],
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text(
                              "Set Capacity",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                  ],
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
