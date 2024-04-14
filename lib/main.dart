import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:water_level_management_system/routes/constant.dart';
import 'package:water_level_management_system/views/progress.dart';
import 'package:water_level_management_system/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Level Management System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        splashRoute: (context) => const SplashScreen(),
        progressRoute: (context) => const Progress(),
      },
    );
  }
}
