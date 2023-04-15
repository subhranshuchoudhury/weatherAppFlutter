class Weather {
  late String main;
  late String description;
  late String icon;
  late String country;
  late String name;
  late double temp;

  Weather(
      {required this.main,
      required this.description,
      required this.country,
      required this.icon,
      required this.name,
      required this.temp});
}
