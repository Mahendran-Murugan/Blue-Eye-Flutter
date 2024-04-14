import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              Stack(
                children: [
                  Container(
                    height: size.height * 0.4,
                    width: size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black12.withOpacity(0.05),
                      ),
                      borderRadius: BorderRadius.circular(200),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 36,
                    child: Container(
                      height: size.height * 0.31,
                      width: size.width * 0.67,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.2,
                          color: Colors.black12.withOpacity(0.07),
                        ),
                        borderRadius: BorderRadius.circular(200),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 75,
                    left: 70,
                    child: Container(
                      height: size.height * 0.23,
                      width: size.width * 0.5,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.black12.withOpacity(0.09),
                        ),
                        borderRadius: BorderRadius.circular(200),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 130,
                    left: 110,
                    child: Container(
                      height: size.height * 0.14,
                      width: size.width * 0.3,
                      child: Column(
                        children: [
                          Image.asset(
                            'images/assets/tank.png',
                            height: size.height * 0.10,
                          ),
                          Text(
                            "BLUE EYE",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              color: Colors.cyan[200],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.25,
              ),
              GestureDetector(
                onTap: () => {},
                child: Container(
                  height: 65,
                  width: size.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                    color: Colors.cyan[300],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Get Started",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.arrow_forward),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
