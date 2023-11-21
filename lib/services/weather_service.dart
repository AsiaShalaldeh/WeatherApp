import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = '8cc668fb0aa34a37b14112638232111';
  static const String city = 'London';

  Future<Map<String, dynamic>> fetchWeatherData() async {
    final response = await http.get(Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=8cc668fb0aa34a37b14112638232111&q=London&aqi=no'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
