import 'package:flutter/material.dart';
import 'package:weatherapp/models/detailed-city-weather.dart';

import '../models/weather.dart';
import '../services/weather_service.dart';

class MoreInformationScreen extends StatefulWidget {
  final Weather cityWeather;

  const MoreInformationScreen({Key? key, required this.cityWeather})
      : super(key: key);

  @override
  State<MoreInformationScreen> createState() => _MoreInformationScreenState();
}

class _MoreInformationScreenState extends State<MoreInformationScreen> {
  late Future<DetailedCityWeather> detailedCityWeather;

  @override
  void initState() {
    super.initState();
    detailedCityWeather = _fetchWeatherData(widget.cityWeather.cityName);
  }

  Future<DetailedCityWeather> _fetchWeatherData(String cityName) async {
    try {
      final response = await WeatherService().fetchWeatherData(cityName);
      return DetailedCityWeather.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('City Details'),
      ),
      body: FutureBuilder<DetailedCityWeather>(
        future: detailedCityWeather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            DetailedCityWeather data = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.cityWeather.cityName),
                  Text('${widget.cityWeather.temperature}°C'),
                  Text(widget.cityWeather.condition),
                  Text('Wind: ${data.windSpeed} km/h ${data.windDirection}'),
                  Text('Pressure: ${data.pressure} mb'),
                  Image.network("http:${widget.cityWeather.icon}"),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
