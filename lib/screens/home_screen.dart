import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Weather> weatherData;

  @override
  void initState() {
    super.initState();
    weatherData = _fetchWeatherData();
  }

  Future<Weather> _fetchWeatherData() async {
    try {
      final response = await WeatherService().fetchWeatherData('London');
      return Weather.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Weather App', style: TextStyle(color: Colors.black)),
      ),
      body: FutureBuilder<Weather>(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final Weather weather = snapshot.data!;
            return _buildWeatherUI(weather);
          }
        },
      ),
    );
  }

  Widget _buildWeatherUI(Weather weather) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weather.cityName,
            style: const TextStyle(fontSize: 24.0),
          ),
          const SizedBox(height: 16.0),
          Image.network(
            "http:${weather.icon}",
            height: 64.0,
            width: 64.0,
          ),
          const SizedBox(height: 16.0),
          Text(
            '${weather.temperature} °C',
            style: const TextStyle(fontSize: 24.0),
          ),
          const SizedBox(height: 16.0),
          Text(
            weather.condition,
            style: const TextStyle(fontSize: 24.0),
          ),
        ],
      ),
    );
  }
}
