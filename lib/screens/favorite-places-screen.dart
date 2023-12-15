import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/city.dart';
import '../models/preference.dart';
import '../models/weather.dart';
import '../providers/database-provider.dart';
import '../providers/selected-city-provider.dart';
import '../services/weather_service.dart';
import 'more-info-screen.dart';

class FavoritePlacesScreen extends StatefulWidget {
  const FavoritePlacesScreen({Key? key}) : super(key: key);

  @override
  _FavoritePlacesScreenState createState() => _FavoritePlacesScreenState();
}

class _FavoritePlacesScreenState extends State<FavoritePlacesScreen> {
  late Future<List<City>> favoritePlaces;
  late Future<List<Weather>> cities;

  @override
  void initState() {
    super.initState();
    favoritePlaces = _loadFavoritePlaces();
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

  Future<List<City>> _loadFavoritePlaces() async {
    List<Preference> places =
        await DatabaseProvider.instance.getUserPreferences();
    final List<City> allCities = await WeatherService().loadCities();
    List<City> cities = [];
    for (int i = 0; i < places.length; i++) {
      cities.add(allCities.firstWhere((c) => c.cityName == places[i].cityName));
    }
    return cities;
  }

  Future<void> _addFavoritePlace(String cityName) async {
    await DatabaseProvider.instance
        .insertPreference(Preference(cityName: cityName));
    setState(() {
      favoritePlaces = _loadFavoritePlaces();
    });
  }

  Future<void> _deleteFavoritePlace(int id) async {
    // await DatabaseProvider.instance.deletePreference(id);
    setState(() {
      favoritePlaces = _loadFavoritePlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Favorite Places',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder(
        future: favoritePlaces,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return const Center(
              child: Text('No favorite places found.'),
            );
          } else {
            List<City> data = snapshot.data as List<City>;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(16.0),
                  height: 148.0,
                  decoration: BoxDecoration(
                    image: data[index].cityImage != null
                        ? DecorationImage(
                            image: AssetImage(data[index].cityImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        data[index].cityName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      FutureBuilder<List<Weather>>(
                        future: cities,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.green,
                                  strokeWidth: 1,
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            return ElevatedButton.icon(
                              onPressed: () {
                                String selectedCityName = data[index].cityName;
                                Weather selectedCityWeather =
                                    snapshot.data!.firstWhere(
                                  (weather) =>
                                      weather.city.cityName == selectedCityName,
                                  orElse: () =>
                                      Provider.of<SelectedCityProvider>(context,
                                              listen: false)
                                          .selectedCityWeather,
                                );
                                Provider.of<SelectedCityProvider>(context,
                                        listen: false)
                                    .updateSelectedCity(
                                  data[index].cityName,
                                  selectedCityWeather,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MoreInformationScreen(
                                      cityWeather: selectedCityWeather,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green.shade300,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                              ),
                              icon: const Icon(
                                Icons.cloud,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'More Info',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
