import 'package:current_location/current_location.dart';
import 'package:current_location/model/location.dart';
import 'package:flutter/material.dart';
import 'package:weatherapp/screens/weather-map-screen.dart';
import 'package:weatherapp/widgets/weather-landing.dart';

import '../models/city.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../widgets/back-arrow-button.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  late Future<Weather> weatherData;
  late City currentCity;
  late double latitude;
  late double longitude;

  @override
  void initState() {
    super.initState();
    weatherData = _fetchWeatherData();
  }

  Future<Weather> _fetchWeatherData() async {
    try {
      final Location location = await UserLocation.getValue() as Location;
      final String regionName = location.regionName ?? '';
      setState(() {
        latitude = location.latitude ?? 0.0;
        longitude = location.longitude ?? 0.0;
      });
      if (regionName.isNotEmpty) {
        final response = await WeatherService().fetchWeatherData(regionName);
        final List<City> cities = await WeatherService().loadCities();
        currentCity = cities.firstWhere((c) => c.cityName == regionName);
        return Weather.fromJson(response, currentCity);
      } else {
        throw Exception('Region name is empty');
      }
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FutureBuilder<Weather>(
          future: weatherData,
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Colors.green,
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return Container(
                decoration: BoxDecoration(
                  image: snapshot.data!.city.cityImage != null
                      ? DecorationImage(
                          image: AssetImage(snapshot.data!.city.cityImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: Stack(
                  children: [
                    WeatherLanding(
                      weather: snapshot.data!,
                    ),
                    BackArrowButton(onPressed: () {
                      Navigator.pop(context);
                    }),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 120, right: 160),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WeatherMapScreen(
                                          longitude: longitude,
                                          latitude: latitude,
                                        )),
                              );
                            },
                            icon: const Icon(
                              Icons.map,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Text(
                'We Can not Return the Weather of your Location, Come Back Again!',
              );
            }
          },
        ),
      ),
    );
  }
}
