import 'package:flutter/material.dart';
import 'package:weatherapp/services/weather_service.dart';

import '../models/hourly-weather.dart';

class HourlyForecastScreen extends StatelessWidget {
  final String cityName;

  const HourlyForecastScreen({Key? key, required this.cityName})
      : super(key: key);

  Future<List<HourlyWeather>> _fetchHourlyForecastData() async {
    try {
      return WeatherService().fetchHourlyForecastData();
    } catch (e) {
      throw Exception('Failed to load hourly forecast data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hourly Forecast - $cityName',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder<List<HourlyWeather>>(
        future: _fetchHourlyForecastData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<HourlyWeather> hourlyForecast = snapshot.data!;
            return _buildHourlyForecastUI(hourlyForecast);
          }
        },
      ),
    );
  }

  Widget _buildHourlyForecastUI(List<HourlyWeather> hourlyForecast) {
    return ListView.builder(
      scrollDirection:
          Axis.horizontal, // Set the scroll direction to horizontal
      itemCount: hourlyForecast.length,
      itemBuilder: (context, index) {
        HourlyWeather hourlyWeather = hourlyForecast[index];

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  '${hourlyWeather.time.day}-${hourlyWeather.time.month}-${hourlyWeather.time.year}'
                  '\n${hourlyWeather.time.hour}:${hourlyWeather.time.minute}',
                ),
                const SizedBox(height: 8.0),
                Text('${hourlyWeather.temperature} °C'),
                const SizedBox(height: 8.0),
                Image.network("http:${hourlyWeather.icon}"),
              ],
            ),
          ),
        );
      },
    );
  }
}
