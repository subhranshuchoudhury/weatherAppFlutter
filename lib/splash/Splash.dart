import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forecaster/pages/Home.dart';

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
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home())));
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
