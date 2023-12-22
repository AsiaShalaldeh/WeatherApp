import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:location/location.dart';
import 'package:weatherapp/screens/weather-map-screen.dart';
import 'package:weatherapp/services/location-service.dart';
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
  late Future<Weather>? weatherData = null;
  late City currentCity;
  late double latitude;
  late double longitude;
  LocationData? locationData;
  Address? address;
  String cityName = "";

  @override
  void initState() {
    super.initState();
    _getLocationAndFetchWeatherData();
  }

  Future<void> _getLocationAndFetchWeatherData() async {
    await _getLocation();
    setState(() {
      weatherData = _fetchWeatherData();
    });
  }

  Future<void> _getLocation() async {
    try {
      locationData = await LocationService().GetLocation();
      address = await LocationService().GetAddress(
        locationData?.latitude,
        locationData?.longitude,
      );
      setState(() {
        latitude = locationData!.latitude ?? 0.0;
        longitude = locationData!.longitude ?? 0.0;
        cityName = address?.city ?? "";
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<Weather> _fetchWeatherData() async {
    try {
      if (locationData != null && cityName.isNotEmpty) {
        final response = await WeatherService().fetchWeatherData(cityName);
        final List<City> cities = await WeatherService().loadCities();
        currentCity = cities.firstWhere((c) => c.cityName == cityName);
        return Weather.fromJson(response, currentCity);
      } else {
        throw Exception('Location data or city name is not available');
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
            if (snapshot.data == null ||
                snapshot.connectionState == ConnectionState.waiting) {
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
                        padding: const EdgeInsets.only(bottom: 120, right: 165),
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
                    Positioned(
                      top: 365,
                      left: 138,
                      child: Text(
                        '${address?.streetAddress}',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
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
