import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../model/weather_model.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  // declaring variables
  List<Weather> forecastData = [];
  late Weather weather;
  bool forecastLoading = true;

  // get the weather information from the API
  getWeatherInfo({String city = "cuttack"}) async {
    setState(() {
      forecastLoading = true;
      forecastData = [];
    });
    try {
      var response = await http.get(Uri.parse(
          "http://api.openweathermap.org/data/2.5/forecast?q=$city&appid=ac244764e38460bdd143f804ed1840f8"));

      var decodedJson = await jsonDecode(response.body);
      int len = decodedJson["list"].length;
      for (int i = 0; i < len; i++) {
        forecastData.add(
          Weather(
            main: decodedJson["list"][i]["weather"][0]["main"],
            description: decodedJson["list"][i]["weather"][0]["description"],
            icon: decodedJson["list"][i]["weather"][0]["icon"],
            country: "N/A",
            name: decodedJson["city"]["name"],
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

      Fluttertoast.showToast(
        msg: "Done",
      );

      setState(() {
        forecastLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Something went wrong!",
        backgroundColor: Colors.red.shade400,
      );
      Fluttertoast.cancel();
    }
  }

  String dateStringFT(int timestamp) {
    DateTime dateStamp = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String dateTime =
        "${dateStamp.year}/${dateStamp.month}/${dateStamp.day} ${dateStamp.hour > 12 ? dateStamp.hour - 12 : dateStamp.hour}:${dateStamp.minute} ${dateStamp.hour > 12 ? 'PM' : 'AM'}";
    return dateTime;
  }

  // color change according to API data

  @override
  void initState() {
    getWeatherInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Forecast by City"),
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
        body: forecastLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: forecastData.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(
                      bottom: 5,
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blue.shade300,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'City : ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              (forecastData[index].name),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Forecast : ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              dateStringFT(forecastData[index].dt),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Weather : ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              forecastData[index].main,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Description : ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              forecastData[index].description,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Temprature : ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "${(forecastData[index].temp - 273).toInt()} °C",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ));
  }
}

class CustomSearch extends SearchDelegate {
  List<String> allData = ['Cuttack', 'Bhubaneswar', 'Jajpur'];

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
