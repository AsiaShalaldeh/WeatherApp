import 'package:flutter/material.dart';
import 'package:weatherapp/screens/more-info-screen.dart';

import '../models/weather.dart';
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
      appBar: AppBar(
        title:
            const Text('City Weather', style: TextStyle(color: Colors.black)),
      ),
      body: FutureBuilder<List<Weather>>(
        future: cities,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          } else {
            List<Weather> cityWeather = snapshot.data!;
            return ListView.builder(
              itemCount: cityWeather.length,
              itemBuilder: (context, index) {
                Weather city = cityWeather[index];
                return _buildCityItem(city);
              },
            );
          }
        },
      ),
    );
  }

  // should be added in a seperate widget file
  Widget _buildCityItem(Weather city) {
    return ListTile(
      tileColor: Colors.white70,
      title: Text(city.cityName),
      subtitle: Text('${city.temperature}°C\n${city.condition}'),
      leading: Image.network("http:${city.icon}",
          // fit: BoxFit.cover,
          height: 40.0,
          width: 40.0),
      trailing: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoreInformationScreen(cityWeather: city),
            ),
          );
        },
        child: const Text('More Info'),
      ),
    );
  }
}
