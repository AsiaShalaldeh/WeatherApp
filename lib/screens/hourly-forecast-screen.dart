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
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(city.cityImage),
                  fit: BoxFit.cover,
                )),
                child: _buildHourlyForecastUI(hourlyForecast));
          }
        },
      ),
    );
  }

  Widget _buildHourlyForecastUI(List<HourlyWeather> hourlyForecast) {
    // Get the current hour
    final DateTime now = DateTime.now();
    final int currentHour = now.hour;
    // Filter the forecast data to get the current hour's weather and the following hours
    final List<HourlyWeather> upcomingForecast = hourlyForecast
        .where((hourlyWeather) => hourlyWeather.time.hour > currentHour)
        .toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
          ),
          child: Card(
            elevation: 5.0,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8.0),
                  Text(
                    '${hourlyForecast.first.time.hour}:${hourlyForecast.first.time.minute}0',
                    style: const TextStyle(color: Colors.white, fontSize: 24.0),
                  ),
                  const SizedBox(height: 8.0),
                  Image.network("http:${hourlyForecast.first.icon}"),
                  Text(
                    '${hourlyForecast.first.temperature} °C',
                    style: const TextStyle(color: Colors.white, fontSize: 24.0),
                  ),
                ],
              ),
            ),
          ),
        ),
        // ListView of coming hours
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: upcomingForecast.length,
            itemBuilder: (context, index) {
              HourlyWeather hourlyWeather = upcomingForecast[index];

              return Container(
                width: 200.0,
                height: 50.0,
                // padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                ),
                child: Card(
                  elevation: 5.0,
                  color: Colors.transparent,
                  // margin: const EdgeInsets.only(
                  //     left: 0.0, top: 24.0, right: 0.0, bottom: 24.0),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(40.0),
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${hourlyWeather.time.hour}:${hourlyWeather.time.minute}0',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24.0),
                        ),
                        const SizedBox(height: 8.0),
                        Image.network(
                          "http:${hourlyWeather.icon}",
                          height: 60,
                          width: 60,
                        ),
                        Text(
                          '${hourlyWeather.temperature} °C',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24.0),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
