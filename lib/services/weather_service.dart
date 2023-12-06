import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/models/weather.dart';

import '../models/city.dart';
import '../models/hourly-weather.dart';

class WeatherService {
  static const String apiKey = '8cc668fb0aa34a37b14112638232111';
  static const String city = 'Jerusalem';

  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    final response = await http.get(Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&aqi=no'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<City>> loadCities() async {
    try {
      // Load the JSON file from the assets
      final String jsonString =
          await rootBundle.loadString("assets/cities.json");

      // Parse the JSON string
      final List<dynamic> jsonList = json.decode(jsonString);

      // Convert the list of dynamic to List<City>
      final List<City> cities =
          jsonList.map((json) => City.fromJson(json)).toList();

      return cities;
    } catch (e) {
      throw Exception('Failed to load cities: $e');
    }
  }

  Future<List<Weather>> fetchWeatherForCities() async {
    try {
      final List<City> cities = await loadCities();
      final List<Weather> weatherDataList = [];

      for (final city in cities) {
        final response = await fetchWeatherData(city.cityName);
        weatherDataList.add(Weather.fromJson(response, city));
      }

      return weatherDataList;
    } catch (e) {
      throw Exception('Failed to Fetch weather for cities: $e');
    }
  }

  Future<Map<String, dynamic>> fetchDailyForecast(String cityName) async {
    final response = await http.get(Uri.parse(
        'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$cityName&days=7'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch daily forecast data');
    }
  }

  Future<List<HourlyWeather>> fetchHourlyForecastData() async {
    try {
      final response = await fetchDailyForecast(city);
      final List<HourlyWeather> hourlyForecast =
          (response['forecast']['forecastday'][0]['hour'] as List)
              .map((hourData) => HourlyWeather.fromJson(hourData))
              .toList();

      return hourlyForecast;
    } catch (e) {
      throw Exception('Failed to load hourly forecast data: $e');
    }
  }
}
