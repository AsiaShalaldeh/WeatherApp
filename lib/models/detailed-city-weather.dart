import 'package:weatherapp/models/weather.dart';

import 'city.dart';

class DetailedCityWeather extends Weather {
  final String windDirection;
  final String pressure;
  final String windSpeed;

  DetailedCityWeather({
    required this.windDirection,
    required this.pressure,
    required this.windSpeed,
    // required String cityName,
    required City city,
    required double temperature,
    required String condition,
    required String icon,
    // required List<DayWeather> dailyForecast,
  }) : super(
          // cityName: cityName,
          city: city,
          temperature: temperature,
          condition: condition,
          icon: icon,
          // dailyForecast: dailyForecast,
        );

  factory DetailedCityWeather.fromJson(Map<String, dynamic> json, City city) {
    return DetailedCityWeather(
      windDirection: json['current']['wind_dir'],
      pressure: json['current']['pressure_mb'].toString(),
      windSpeed: json['current']['wind_kph'].toString(),
      city: city,
      temperature: json['current']['temp_c'],
      condition: json['current']['condition']['text'],
      icon: json['current']['condition']['icon'],
    );
  }
}
