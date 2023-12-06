import 'package:flutter/material.dart';
import 'package:weatherapp/models/detailed-city-weather.dart';

import '../models/city.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class MoreInformationScreen extends StatefulWidget {
  final Weather cityWeather;
  // final City city;

  const MoreInformationScreen({
    Key? key,
    required this.cityWeather,
    // required this.city
  }) : super(key: key);

  @override
  State<MoreInformationScreen> createState() => _MoreInformationScreenState();
}

class _MoreInformationScreenState extends State<MoreInformationScreen> {
  late Future<DetailedCityWeather> detailedCityWeather;

  @override
  void initState() {
    super.initState();
    detailedCityWeather = _fetchWeatherData(widget.cityWeather.city.cityName);
  }

  Future<DetailedCityWeather> _fetchWeatherData(String cityName) async {
    try {
      final response = await WeatherService().fetchWeatherData(cityName);
      final List<City> cities = await WeatherService().loadCities();
      final City city = cities.firstWhere((c) => c.cityName == cityName);
      return DetailedCityWeather.fromJson(response, city);
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text(widget.cityWeather.city.cityName),
      // ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: widget.cityWeather.city != null &&
                  widget.cityWeather.city.cityImage != null
              ? DecorationImage(
                  image: AssetImage(widget.cityWeather.city.cityImage!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: FutureBuilder<DetailedCityWeather>(
          future: detailedCityWeather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              DetailedCityWeather data = snapshot.data!;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.cityWeather.city.cityName,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Temperature: ${widget.cityWeather.temperature}°C',
                        style: const TextStyle(
                            fontSize: 18.0, color: Colors.white),
                      ),
                      Text(
                        'Condition: ${widget.cityWeather.condition}',
                        style: const TextStyle(
                            fontSize: 18.0, color: Colors.white),
                      ),
                      Text(
                        'Wind: ${data.windSpeed} km/h ${data.windDirection}',
                        style: const TextStyle(
                            fontSize: 18.0, color: Colors.white),
                      ),
                      Text(
                        'Pressure: ${data.pressure} mb',
                        style: const TextStyle(
                            fontSize: 18.0, color: Colors.white),
                      ),
                      const SizedBox(height: 16.0),
                      Image.network("http:${widget.cityWeather.icon}"),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Back'),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
