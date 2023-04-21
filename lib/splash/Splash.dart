import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:forecaster/pages/Home.dart';
import 'package:forecaster/pages/HomePage.dart';
// import 'package:forecaster/pages/Weather.dart';

// https://www.youtube.com/watch?v=Uw0T4ZIgFgs
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomePage())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text(
          "Forecaster",
          style: TextStyle(
              color: Colors.white, fontSize: 45, fontStyle: FontStyle.normal),
        ),
      ),
    );
  }
}
