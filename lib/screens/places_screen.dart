import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../services/weather_service.dart';
import '../widgets/city-card.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  late Future<List<Weather>> cities;

  @override
  void initState() {
    super.initState();
    cities = _fetchCitiesData();
  }

  Future<List<Weather>> _fetchCitiesData() async {
    try {
      final citiesData = await WeatherService().fetchWeatherForCities();
      return citiesData;
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(""),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: FutureBuilder<List<Weather>>(
          future: cities,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available.'));
            } else {
              List<Weather> cityWeather = snapshot.data!;
              return ListView.builder(
                itemCount: cityWeather.length,
                itemBuilder: (context, index) {
                  Weather weatherOfCity = cityWeather[index];
                  // return _buildCityCard(weatherOfCity);
                  return CityCard(weatherOfCity: weatherOfCity);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
