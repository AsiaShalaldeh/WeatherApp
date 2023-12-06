import 'city.dart';

class Weather {
  // final String cityName;
  final City city;
  final double temperature;
  final String condition;
  final String icon;

  Weather({
    // required this.cityName,
    required this.city,
    required this.temperature,
    required this.condition,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json, City city) {
    return Weather(
      // cityName: json['location']['name'],
      city: city,
      temperature: json['current']['temp_c'],
      condition: json['current']['condition']['text'],
      icon: json['current']['condition']['icon'],
    );
  }
}
