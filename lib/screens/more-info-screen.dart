import 'package:flutter/material.dart';
import 'package:weatherapp/models/detailed-city-weather.dart';

import '../models/city.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class MoreInformationScreen extends StatefulWidget {
  final Weather cityWeather;

  const MoreInformationScreen({
    Key? key,
    required this.cityWeather,
  }) : super(key: key);

  @override
  State<MoreInformationScreen> createState() => _MoreInformationScreenState();
}

class _MoreInformationScreenState extends State<MoreInformationScreen> {
  late Future<DetailedCityWeather> detailedCityWeather;

  @override
  void initState() {
    super.initState();
    detailedCityWeather = _fetchWeatherData();
  }

  Future<DetailedCityWeather> _fetchWeatherData() async {
    try {
      String cityName = widget.cityWeather.city.cityName;
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
                child: Container(
                  height: 340.0,
                  width: 260.0,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
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
                        Image.network("http:${widget.cityWeather.icon}"),
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
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 24.0,
                            ),
                          ),
                        ),
                      ],
                    ),
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
