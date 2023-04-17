import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:forecaster/pages/Home.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GNav(
          onTabChange: (index) {
            if (index == 0) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            } else if (index == 1) {
              print("first");
            } else if (index == 2) {
              print("first");
            }
          },
          tabs: const [
            GButton(
              icon: Icons.home,
            ),
            GButton(icon: Icons.search),
            GButton(icon: Icons.location_pin)
          ]),
      body: SafeArea(child: Text("Hii")),
    );
  }
}
