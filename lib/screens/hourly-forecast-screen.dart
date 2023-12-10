import 'package:flutter/material.dart';
import 'package:weatherapp/services/weather_service.dart';

import '../models/city.dart';
import '../models/hourly-weather.dart';

class HourlyForecastScreen extends StatelessWidget {
  final City city;

  const HourlyForecastScreen({Key? key, required this.city}) : super(key: key);

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
          city.cityName,
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
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
            return Container(
                constraints: const BoxConstraints.expand(),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/london.jpg"),
                  fit: BoxFit.cover,
                )),
                child: _buildHourlyForecastUI(hourlyForecast));
          }
        },
      ),
    );
  }

  Widget _buildHourlyForecastUI(List<HourlyWeather> hourlyForecast) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: hourlyForecast.length,
      itemBuilder: (context, index) {
        HourlyWeather hourlyWeather = hourlyForecast[index];

        return Container(
          width: 160.0,
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
          ),
          child: Card(
            elevation: 5.0,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Today',
                      style: TextStyle(color: Colors.white, fontSize: 24.0)),
                  const SizedBox(height: 8.0),
                  Text(
                    '${hourlyWeather.time.hour}:${hourlyWeather.time.minute}0',
                    style: const TextStyle(color: Colors.white, fontSize: 24.0),
                  ),
                  const SizedBox(height: 8.0),
                  Image.network("http:${hourlyWeather.icon}"),
                  Text(
                    '${hourlyWeather.temperature} °C',
                    style: const TextStyle(color: Colors.white, fontSize: 24.0),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
