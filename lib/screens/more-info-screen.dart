import 'package:flutter/material.dart';
import 'package:weatherapp/models/detailed-city-weather.dart';

import '../models/city.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../widgets/weather-info-tile.dart';

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
  late Weather weather;

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
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.green,
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              DetailedCityWeather data = snapshot.data!;
              return Center(
                child: Container(
                  height: 700.0,
                  width: 350.0,
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
                        // const SizedBox(height: 16.0),
                        Image.network(
                          "http:${widget.cityWeather.icon}",
                          height: 80,
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            WeatherInfoTile(
                              iconData: Icons.thermostat,
                              label: 'Temperature',
                              value: '${widget.cityWeather.temperature}°C',
                            ),
                            WeatherInfoTile(
                              iconData: Icons.waves,
                              label: 'Condition',
                              value: widget.cityWeather.condition,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            WeatherInfoTile(
                              iconData: Icons.air,
                              label: 'Wind',
                              value:
                                  '${data.windSpeed} km/h ${data.windDirection}',
                            ),
                            WeatherInfoTile(
                              iconData: Icons.compress,
                              label: 'Pressure',
                              value: '${data.pressure} mb',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            WeatherInfoTile(
                              iconData: Icons.water,
                              label: 'Humidity',
                              value: '${data.humidity}%',
                            ),
                            WeatherInfoTile(
                              iconData: Icons.whatshot,
                              label: 'Feels Like',
                              value: '${data.feelsLike}°C',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            WeatherInfoTile(
                              iconData: Icons.navigation,
                              label: 'Wind Direction',
                              value: data.windDirection,
                            ),
                            WeatherInfoTile(
                              iconData: Icons.swap_calls,
                              label: 'Wind Degree',
                              value: '${data.windDegree}°',
                            ),
                          ],
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
