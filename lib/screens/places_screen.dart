import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../services/weather_service.dart';
import '../widgets/back-arrow-button.dart';
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
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/images/mountain1.jpg"),
            fit: BoxFit.cover,
          ),
          color: Colors.black.withOpacity(0.1),
        ),
        child: FutureBuilder<List<Weather>>(
          future: cities,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No Data Available'));
            } else {
              List<Weather> cityWeather = snapshot.data!;
              return Stack(
                children: [
                  ListView.builder(
                    itemCount: cityWeather.length,
                    itemBuilder: (context, index) {
                      Weather weatherOfCity = cityWeather[index];
                      // return _buildCityCard(weatherOfCity);
                      return CityCard(weatherOfCity: weatherOfCity);
                    },
                  ),
                  BackArrowButton(onPressed: () {
                    Navigator.pop(context);
                  }),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
