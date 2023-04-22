import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../model/weather_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // declaring variables
  late Weather weather;
  bool loading = true;
  bool forecastLoading = true;
  String weatherIcons = "assets/images/location-off.png";
  var weatherAccentColor = const Color.fromARGB(255, 238, 65, 52);

  // String get msg => "null";

  // get the weather information from the API
  getWeatherInfo({String city = "cuttack"}) async {
    try {
      var response = await http.get(Uri.parse(
          "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=ac244764e38460bdd143f804ed1840f8"));

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
        setWeatherCode(weather.id);
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Something went wrong!",
        backgroundColor: Colors.red.shade400,
      );
      Fluttertoast.cancel();
    }
  }
  // Test function

  test(String msg) {
    print("Test Success..... $msg");
  }

  // color change according to API data

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
  void initState() {
    getWeatherInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather by City"),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context, delegate: CustomSearch(getWeatherInfo));
            },
            icon: const Icon(Icons.search_outlined),
          ),
        ],
      ),
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
                )
              ],
            ),
    );
  }
}

class CustomSearch extends SearchDelegate {
  List<String> allData = ['Cuttack', 'Bhubaneswar', 'Kendrapara'];

  dynamic getWeatherInfo;

  CustomSearch(this.getWeatherInfo);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in allData) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    if (matchQuery.isEmpty) {
      matchQuery.add(query);
    }

    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
            onTap: () {
              getWeatherInfo(city: result.toString());
              close(context, null); // it used to close the context.
            },
          );
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = ["#@"];
    for (var item in allData) {
      if (item.toLowerCase().contains(
            query.toLowerCase(),
          )) {
        matchQuery.add(item);
      } else {
        matchQuery[0] = query;
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(query),
          onTap: () {
            getWeatherInfo(
              city: query.toString(),
            );

            close(context, null);
          },
        );
      },
    );
  }
}
