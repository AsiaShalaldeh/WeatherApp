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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Places'),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   image: const DecorationImage(
        //     image: AssetImage(
        //         "assets/images/cloud.jpg"), // Replace with your cloud image asset
        //     fit: BoxFit.cover,
        //   ),
        //   borderRadius:
        //       BorderRadius.circular(15.0), // Adjust the border radius as needed
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
                  Weather city = cityWeather[index];
                  return _buildCityCard(city);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCityCard(Weather city) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15.0), // Adjust the border radius as needed
      ),
      child: Container(
        height: 120.0,
        // decoration: BoxDecoration(
        //   image: const DecorationImage(
        //     image: AssetImage(
        //         "assets/images/cloud.jpg"), // Replace with your cloud image asset
        //     fit: BoxFit.cover,
        //   ),
        //   borderRadius:
        //       BorderRadius.circular(15.0), // Adjust the border radius as needed
        // ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    city.city.cityName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: Text(
                    '${city.temperature}°C\n${city.condition}',
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  leading: Image.network(
                    "http:${city.icon}",
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MoreInformationScreen(cityWeather: city),
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
