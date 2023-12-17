import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/models/city.dart';
import 'package:weatherapp/models/weather.dart';
import 'package:weatherapp/screens/hourly-forecast-screen.dart';
import 'package:weatherapp/screens/places_screen.dart';
import 'package:weatherapp/services/weather_service.dart';

import '../providers/selected-city-provider.dart';
import '../widgets/menu-button.dart';
import '../widgets/weather-landing.dart';
import 'current-location-screen.dart';
import 'daily-forecast-screen.dart';
import 'favorite-places-screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      final List<City> cities = await WeatherService().loadCities();
      selectedCity = cities.firstWhere((c) => c.cityName == selectedCityName);
      return Weather.fromJson(response, selectedCity);
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            ListTile(
              leading: const Icon(Icons.star, color: Colors.yellow),
              title: const Text('Favorite Places'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoritePlacesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_pin),
              title: const Text('Current Location'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CurrentLocationScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Consumer<SelectedCityProvider>(
        builder: (context, selectedCityProvider, child) {
          return FutureBuilder<Weather>(
            future: _fetchWeatherData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final Weather weather = snapshot.data!;
                final City city = weather.city;

                return Container(
                  decoration: BoxDecoration(
                    image: city.cityImage != null
                        ? DecorationImage(
                            image: AssetImage(city.cityImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: Stack(
                    children: [
                      WeatherLanding(weather: weather),
                      MenuButton(
                        scaffoldKey: _scaffoldKey,
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('No Data Available!'));
              }
            },
          );
        },
      ),
    );
  }
}
