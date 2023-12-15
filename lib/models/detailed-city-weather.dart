import 'package:weatherapp/models/weather.dart';

import 'city.dart';

class DetailedCityWeather extends Weather {
  final String windDirection;
  final int windDegree;
  final String pressure;
  final double windSpeed;
  final int humidity;
  final double feelsLike;

  DetailedCityWeather({
    required this.windDirection,
    required this.pressure,
    required this.windSpeed,
    required this.humidity,
    required this.windDegree,
    required this.feelsLike,
    required City city,
    required double temperature,
    required String condition,
    required String icon,
  }) : super(
          city: city,
          temperature: temperature,
          condition: condition,
          icon: icon,
        );

  factory DetailedCityWeather.fromJson(Map<String, dynamic> json, City city) {
    return DetailedCityWeather(
      windDirection: json['current']['wind_dir'],
      pressure: json['current']['pressure_mb'].toString(),
      windSpeed: json['current']['wind_kph'],
      windDegree: json['current']['wind_degree'],
      humidity: json["current"]["humidity"] ?? 0,
      feelsLike: json['current']['feelslike_c'],
      city: city,
      temperature: json['current']['temp_c'],
      condition: json['current']['condition']['text'],
      icon: json['current']['condition']['icon'],
    );
  }
}
