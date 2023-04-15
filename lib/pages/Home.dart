import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:forecaster/model/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:weather_icons/weather_icons.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Weather weather;
  bool loading = true;
  // String weatherCode = "f014";
  @override
  void initState() {
    getLocationInfo();
    super.initState();
  }

  getWeatherInfo(long, lat) async {
    var response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${long}&appid=30bc1dae9d219aaa107f75ba1682a80c"));

    var decodedJson = await jsonDecode(response.body);

    weather = Weather(
        main: decodedJson["weather"][0]["main"],
        description: decodedJson["weather"][0]["description"],
        country: decodedJson["sys"]["country"],
        icon: decodedJson["weather"][0]["icon"],
        name: decodedJson["name"],
        temp: decodedJson["main"]["temp"]);
    setState(() {
      loading = false;
      print("API Fetching Done!");
    });
  }

  getLocationInfo() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    getWeatherInfo(position.longitude.toString(), position.latitude.toString());
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: Center(
                child: Text("${weather.name}, ${weather.country}"),
              ),
            ),
            body: Center(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${(weather.temp - 275).truncate()}°",
                        style: const TextStyle(
                            fontSize: 130,
                            fontStyle: FontStyle.normal,
                            color: Colors.blue),
                      ),
                      // const Text(
                      //   "C",
                      //   style: TextStyle(
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    weather.main,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(
                        Icons.arrow_upward,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'High: 75°F',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(width: 20),
                      Icon(
                        Icons.arrow_downward,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Low: 65°F',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          onPressed: getLocationInfo,
                          child: const Text("Get Location"))
                    ],
                  )
                ],
              ),
            ),
          );
  }
}

/*

SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text("Cloud"),
            )
          ],
        ),
      )
*/ 
