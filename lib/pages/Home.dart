import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:forecaster/model/weather_model.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:weather_icons/weather_icons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // declaring the variables.

  late Weather weather;
  bool loading = true;
  bool locationLoading = false;
  String weatherIcons = "assets/images/location-off.png";
  var weatherAccentColor = const Color.fromARGB(255, 238, 65, 52);

  @override
  void initState() {
    getLocationInfo();
    super.initState();
  }

  getWeatherInfo({double long = 86.42, double lat = 20.49}) async {
    try {
      var response = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=${lat.toString()}&lon=${long.toString()}&appid=30bc1dae9d219aaa107f75ba1682a80c"));
      var decodedJson = await jsonDecode(response.body);

      weather = Weather(
          main: decodedJson["weather"][0]["main"],
          description: decodedJson["weather"][0]["description"],
          country: decodedJson["sys"]["country"],
          icon: decodedJson["weather"][0]["icon"],
          name: decodedJson["name"],
          id: decodedJson["weather"][0]["id"],
          temp_max: decodedJson["main"]["temp_max"],
          temp_min: decodedJson["main"]["temp_min"],
          temp: decodedJson["main"]["temp"]);
      Fluttertoast.showToast(
        msg: "Done",
        backgroundColor: Colors.grey,
      );

      setState(() {
        loading = false;
        locationLoading = false;
        setWeatherCode(weather.id);
        // Fluttertoast.cancel();
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Something went wrong!",
        backgroundColor: Colors.red.shade400,
      );
      Fluttertoast.cancel();
    }
  }

  getForecastInfo() async {}

  getLocationInfo() async {
    locationLoading = true;

    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    getWeatherInfo(long: position.longitude, lat: position.latitude);
  }

  setWeatherCode(int code) {
    if (code == 800) {
      weatherIcons = "assets/images/sun.png";
      weatherAccentColor = const Color.fromARGB(255, 239, 211, 34);
    } else {
      switch (code ~/ 100) {
        case 8:
          weatherIcons = "assets/images/clouds.png";
          weatherAccentColor = const Color.fromARGB(255, 6, 129, 252);
          break;
        case 7:
          weatherIcons = "assets/images/haze.png";
          weatherAccentColor = const Color.fromARGB(255, 39, 55, 96);
          break;
        case 6:
          weatherIcons = "assets/images/snowflake.png";
          weatherAccentColor = const Color.fromARGB(255, 145, 174, 245);
          break;
        case 5:
          weatherAccentColor = const Color.fromARGB(255, 195, 172, 1);
          weatherIcons = "assets/images/cloudy.png";
          break;
        case 3:
          weatherIcons = "assets/images/rain.png";
          weatherAccentColor = const Color.fromARGB(255, 47, 61, 255);

          break;
        case 2:
          weatherIcons = "assets/images/storm.png";
          weatherAccentColor = const Color.fromARGB(255, 5, 1, 1);
          break;
        default:
          weatherIcons = "assets/images/location-off.png";
          weatherAccentColor = const Color.fromARGB(255, 238, 65, 52);
      }
    }
  }

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
      // appBar: AppBar(
      //   backgroundColor: weatherAccentColor,
      //   title: Center(
      //     child: Text("${weather.name}, ${weather.country}"),
      //   ),
      // ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      weatherIcons,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Text(
                      "${(weather.temp - 275).truncate()}°",
                      style: TextStyle(
                          fontSize: 130,
                          fontStyle: FontStyle.normal,
                          color: weatherAccentColor),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  weather.main,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 39, 55, 96),
                    fontSize: 30,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  weather.description,
                  style: const TextStyle(
                    color: Colors.black38,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.thermostat,
                      size: 30,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${(weather.temp_max - 275).truncate()} °C",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 39, 55, 96)),
                    ),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.thermostat,
                      size: 30,
                      color: Color.fromARGB(255, 51, 109, 255),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${(weather.temp_min - 275).truncate()} °C',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 39, 55, 96)),
                    ),
                  ],
                ),
              ],
            ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: () {
            Fluttertoast.showToast(
              msg: 'Loading...',
              backgroundColor: Colors.grey,
            );
            getLocationInfo();
          },
          backgroundColor: weatherAccentColor,
          child: locationLoading
              ? const Icon(Icons.hourglass_bottom)
              : const Icon(Icons.location_pin),
        ),
      ),
    );
  }
}
