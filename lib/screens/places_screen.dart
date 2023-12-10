import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/screens/more-info-screen.dart';

import '../models/weather.dart';
import '../providers/selected-city-provider.dart';
import '../services/weather_service.dart';

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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(""),
            fit: BoxFit.cover,
          ),
        ),
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
                  return _buildCityCard(weatherOfCity);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCityCard(Weather weatherOfCity) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        height: 120.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    weatherOfCity.city.cityName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: Text(
                    '${weatherOfCity.temperature}°C\n${weatherOfCity.condition}',
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  leading: Image.network(
                    "http:${weatherOfCity.icon}",
                    height: 40.0,
                    width: 40.0,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 8.0,
              right: 8.0,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<SelectedCityProvider>(context, listen: false)
                      .updateSelectedCity(weatherOfCity.city.cityName);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MoreInformationScreen(cityWeather: weatherOfCity),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green.shade300,
                ),
                child:
                    const Text('More Info', style: TextStyle(fontSize: 12.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
