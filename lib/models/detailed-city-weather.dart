import 'package:weatherapp/models/weather.dart';

class DetailedCityWeather extends Weather {
  final String windDirection;
  final String pressure;
  final String windSpeed;

  DetailedCityWeather({
    required this.windDirection,
    required this.pressure,
    required this.windSpeed,
    required String cityName,
    required double temperature,
    required String condition,
    required String icon,
  }) : super(
          cityName: cityName,
          temperature: temperature,
          condition: condition,
          icon: icon,
        );

  factory DetailedCityWeather.fromJson(Map<String, dynamic> json) {
    return DetailedCityWeather(
      windDirection: json['current']['wind_dir'],
      pressure: json['current']['pressure_mb'].toString(),
      windSpeed: json['current']['wind_kph'].toString(),
      cityName: json['location']['name'],
      temperature: json['current']['temp_c'],
      condition: json['current']['condition']['text'],
      icon: json['current']['condition']['icon'],
    );
  }
}
