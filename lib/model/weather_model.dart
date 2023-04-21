class Weather {
  late int id;
  late String main;
  late String description;
  late String icon;
  late double temp;
  late double feels_like;
  late double temp_min;
  late double temp_max;
  late String pressure;
  late String humidity;
  late double sea_level;
  late double grnd_level;
  late double visibility;
  late double speed;
  late double deg;
  late double gust;
  late int dt;
  late int sunrise;
  late int sunset;
  late String country;
  late String name;

  Weather(
      {required this.main,
      required this.description,
      required this.country,
      required this.icon,
      required this.name,
      required this.temp,
      required this.humidity,
      required this.pressure,
      required this.temp_min,
      required this.temp_max,
      required this.id});
}
