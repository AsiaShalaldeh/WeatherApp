import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/models/city.dart';
import 'package:weatherapp/models/weather.dart';
import 'package:weatherapp/screens/hourly-forecast-screen.dart';
import 'package:weatherapp/screens/places_screen.dart';
import 'package:weatherapp/services/weather_service.dart';

import '../providers/database-provider.dart';
import '../providers/selected-city-provider.dart';
import 'daily-forecast-screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Weather> weatherData;
  late String selectedCityName;
  late City selectedCity;

  @override
  void initState() {
    super.initState();
    weatherData = _fetchWeatherData();
  }

  Future<Weather> _fetchWeatherData() async {
    try {
      selectedCityName =
          Provider.of<SelectedCityProvider>(context).selectedCity;

      final response =
          await WeatherService().fetchWeatherData(selectedCityName);
      // final List<City> cities = await WeatherService().loadCities();
      final List<City> cities = await DatabaseProvider.instance.getAllCities();
      selectedCity = cities.firstWhere((c) => c.cityName == selectedCityName);
      return Weather.fromJson(response, selectedCity);
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App', style: TextStyle(color: Colors.black)),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/sky.jpg"),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: Text('',
                    style: TextStyle(color: Colors.white, fontSize: 24))),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.grey),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time, color: Colors.grey),
              title: const Text('Hourly Forecast'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HourlyForecastScreen(city: selectedCity)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.grey),
              title: const Text('Daily Forecast'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DailyForecastScreen(city: selectedCity)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_city, color: Colors.grey),
              title: const Text('Places'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PlacesScreen()));
              },
            ),
          ],
        ),
      ),
      body: Consumer<SelectedCityProvider>(
        builder: (context, selectedCityProvider, child) {
          final selectedCity = selectedCityProvider.selectedCity;
          return FutureBuilder<Weather>(
            future: _fetchWeatherData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final Weather weather = snapshot.data!;
                final City city = weather.city;

                return Container(
                  constraints: const BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    image: city.cityImage != null
                        ? DecorationImage(
                            image: AssetImage(city.cityImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: Colors.black.withOpacity(0.1),
                  ),
                  child: _buildWeatherUI(weather),
                );
              } else {
                return const Center(child: Text('No data available.'));
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildWeatherUI(Weather weather) {
    return Container(
      margin: const EdgeInsets.all(48.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weather.city.cityName,
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            Image.network(
              "http:${weather.icon}",
              height: 48.0,
              width: 48.0,
            ),
            const SizedBox(height: 8.0),
            Text(
              '${weather.temperature} °C',
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            Text(
              weather.condition,
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
