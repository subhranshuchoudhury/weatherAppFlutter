import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:forecaster/model/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // declaring the variables.
  List<Weather> forecastData = [];
  late Weather weather;
  bool loading = true;
  bool forecastLoading = true;
  bool locationLoading = false;
  String weatherIcons = "assets/images/location-off.png";
  var weatherAccentColor = const Color.fromARGB(255, 238, 65, 52);

  // forecast information

  late String date;

  @override
  void initState() {
    getLocationInfo();
    super.initState();
  }

  String dateStringFT(int timestamp) {
    DateTime dateStamp = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String dateTime =
        "${dateStamp.year}/${dateStamp.month}/${dateStamp.day} ${dateStamp.hour > 12 ? dateStamp.hour - 12 : dateStamp.hour}:${dateStamp.minute} ${dateStamp.hour > 12 ? 'PM' : 'AM'}";
    return dateTime;
  }

  getWeatherInfo({double long = 86.42, double lat = 20.49}) async {
    try {
      var response = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=${lat.toString()}&lon=${long.toString()}&appid=ac244764e38460bdd143f804ed1840f8"));
      var decodedJson = await jsonDecode(response.body);

      weather = Weather(
          main: decodedJson["weather"][0]["main"],
          description: decodedJson["weather"][0]["description"],
          country: decodedJson["sys"]["country"],
          icon: decodedJson["weather"][0]["icon"],
          name: decodedJson["name"],
          dt: 0,
          id: decodedJson["weather"][0]["id"],
          humidity: decodedJson["main"]["humidity"].toString(),
          pressure: decodedJson["main"]["pressure"].toString(),
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

  getForecastInfo({double long = 86.42, double lat = 20.49}) async {
    // http://api.openweathermap.org/data/2.5/forecast?lat=40.3&lon=45.3&appid=ac244764e38460bdd143f804ed1840f8

    var response = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/forecast?lat=${lat.toString()}&lon=${long.toString()}&appid=ac244764e38460bdd143f804ed1840f8"));

    var decodedJson = await jsonDecode(response.body);
    print(decodedJson["list"].length);
    int len = decodedJson["list"].length;
    for (int i = 0; i < len; i++) {
      forecastData.add(
        Weather(
          main: decodedJson["list"][i]["weather"][0]["main"],
          description: decodedJson["list"][i]["weather"][0]["description"],
          icon: decodedJson["list"][i]["weather"][0]["icon"],
          country: "N/A",
          name: "N/A",
          id: decodedJson["list"][i]["weather"][0]["id"],
          humidity: decodedJson["list"][i]["main"]["humidity"].toString(),
          pressure: decodedJson["list"][i]["main"]["pressure"].toString(),
          temp_max: decodedJson["list"][i]["main"]["temp_max"],
          dt: decodedJson["list"][i]["dt"],
          temp_min: decodedJson["list"][i]["main"]["temp_min"],
          temp: decodedJson["list"][i]["main"]["temp"],
        ),
      );
    }
    setState(() {
      forecastLoading = false;
    });

    // print("Forecast " + decodedJson.toString());

    try {} catch (e) {
      print(e.toString());
    }
  }

  getLocationInfo() async {
    locationLoading = true;

    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    getWeatherInfo(long: position.longitude, lat: position.latitude);
    getForecastInfo(long: position.longitude, lat: position.latitude);
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
                  weather.name,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 39, 55, 96),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
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
                      LineIcons.thermometerFull,
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
                      LineIcons.thermometerEmpty,
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
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.scale,
                      size: 30,
                      color: Color.fromARGB(255, 51, 109, 255),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${weather.pressure} P',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 2, 22, 201)),
                    ),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.water_drop_rounded,
                      size: 30,
                      color: Color.fromARGB(255, 51, 109, 255),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${weather.humidity} H',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 2, 22, 201)),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: forecastLoading
                      ? const CircularProgressIndicator()
                      : Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(
                            bottom: 5,
                            top: 10,
                            left: 10,
                            right: 10,
                          ),
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dateStringFT(forecastData[0].dt),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 100,
                                  ),
                                  Text(
                                    forecastData[0].main,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Description: ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 100,
                                  ),
                                  Text(
                                    forecastData[0].description,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: const [
                                  SizedBox(
                                    height: 30,
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dateStringFT(forecastData[1].dt),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 100,
                                  ),
                                  Text(
                                    forecastData[1].main,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Description: ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 100,
                                  ),
                                  Text(
                                    forecastData[1].description,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                )
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
