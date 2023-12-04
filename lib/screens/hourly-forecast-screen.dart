import 'package:flutter/material.dart';
import 'package:weatherapp/services/weather_service.dart';

import '../models/hourly-weather.dart';

class HourlyForecastScreen extends StatelessWidget {
  final String cityName;

  const HourlyForecastScreen({Key? key, required this.cityName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hourly Forecast - $cityName',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder<List<HourlyWeather>>(
        future: _fetchHourlyForecastData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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

  Future<List<HourlyWeather>> _fetchHourlyForecastData() async {
    try {
      return WeatherService().fetchHourlyForecastData();
    } catch (e) {
      throw Exception('Failed to load hourly forecast data: $e');
    }
  }

  Widget _buildHourlyForecastUI(List<HourlyWeather> hourlyForecast) {
    return ListView.builder(
      itemCount: hourlyForecast.length,
      itemBuilder: (context, index) {
        HourlyWeather hourlyWeather = hourlyForecast[index];

        return ListTile(
          title: Text(
              '${hourlyWeather.time.day}-${hourlyWeather.time.month}-${hourlyWeather.time.year}'
              '\n${hourlyWeather.time.hour}:${hourlyWeather.time.minute}'),
          subtitle: Text('${hourlyWeather.temperature} °C'),
          leading: Image.network("http:${hourlyWeather.icon}"),
        );
      },
    );
  }
}
