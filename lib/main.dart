import 'package:flutter/material.dart';
// import 'package:forecaster/pages/Home.dart';
import 'package:forecaster/splash/Splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Forecaster",
      // no splash screen as i assigned home route
      home: Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}
