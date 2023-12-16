import 'package:flutter/material.dart';
import 'package:weatherapp/services/weather_service.dart';

import '../models/city.dart';
import '../models/hourly-weather.dart';
import '../widgets/back-arrow-button.dart';
import '../widgets/hourly-weather-tile.dart';

class HourlyForecastScreen extends StatelessWidget {
  final City city;

  const HourlyForecastScreen({Key? key, required this.city}) : super(key: key);

  Future<List<HourlyWeather>> _fetchHourlyForecastData() async {
    try {
      return WeatherService().fetchHourlyForecastData(city.cityName);
    } catch (e) {
      throw Exception('Failed to load hourly forecast data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  image: NetworkImage(
                      'https://i.pinimg.com/originals/9b/ef/ab/9befabec827afc46c5f9b95b9967de48.gif'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BuildHourlyForecastUI(context, hourlyForecast),
            );
          }
        },
      ),
    );
  }

  Widget BuildHourlyForecastUI(
      BuildContext context, List<HourlyWeather> hourlyForecast) {
    final HourlyWeather currentHourWeather = hourlyForecast
        .where((hourlyWeather) =>
            hourlyWeather.time.hour == hourlyWeather.currentTime.hour)
        .first;
    final int currentHour = currentHourWeather.time.hour;
    final List<HourlyWeather> upcomingForecast = hourlyForecast
        .where((hourlyWeather) => hourlyWeather.time.hour > currentHour)
        .toList();

    return Column(
      children: [
        BackArrowButton(onPressed: () {
          Navigator.pop(context);
        }),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              city.cityName,
              style: const TextStyle(color: Colors.white, fontSize: 40.0),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 5.0,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$currentHour:00",
                    style: const TextStyle(color: Colors.white, fontSize: 24.0),
                  ),
                  const SizedBox(height: 8.0),
                  Image.network("http:${currentHourWeather.icon}"),
                  Text(
                    '${currentHourWeather.temperature} °C',
                    style: const TextStyle(color: Colors.white, fontSize: 24.0),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 240.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: upcomingForecast.length,
              itemBuilder: (context, index) {
                HourlyWeather hourlyWeather = upcomingForecast[index];
                print(hourlyWeather.temperature);
                return HourlyWeatherTile(hourlyWeather: hourlyWeather);
              },
            ),
          ),
        ),
      ],
    );
  }
}
