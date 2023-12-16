import 'package:flutter/material.dart';
import 'package:weatherapp/widgets/back-arrow-button.dart';

import '../models/city.dart';
import '../models/day-weather.dart';
import '../services/weather_service.dart';
import '../widgets/daily-forecast-card.dart';

class DailyForecastScreen extends StatefulWidget {
  final City city;

  const DailyForecastScreen({Key? key, required this.city}) : super(key: key);

  @override
  State<DailyForecastScreen> createState() => _DailyForecastScreenState();
}

class _DailyForecastScreenState extends State<DailyForecastScreen> {
  late Future<List<DayWeather>> dailyForecastData;

  @override
  void initState() {
    super.initState();
    dailyForecastData = _fetchDailyForecastData();
  }

  Future<List<DayWeather>> _fetchDailyForecastData() async {
    try {
      final response =
          await WeatherService().fetchDailyForecast(widget.city.cityName);

      final double latitude = response['location']['lat'];
      final double longitude = response['location']['lon'];

      final List<DayWeather> forecastData = (response['forecast']['forecastday']
              as List)
          .map((dayData) => DayWeather.fromJson(dayData, longitude, latitude))
          .toList();

      return forecastData;
    } catch (e) {
      throw Exception('Failed to load daily forecast data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<DayWeather>>(
        future: dailyForecastData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<DayWeather> dailyForecast = snapshot.data!;
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/images/mountain.jpg"),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.black.withOpacity(0.1),
                  ),
                  child: ListView.builder(
                    itemCount: dailyForecast.length,
                    itemBuilder: (context, index) {
                      DayWeather dayForecast = dailyForecast[index];
                      return DailyForecastCard(
                          dayForecast, widget.city.cityName);
                    },
                  ),
                ),
                BackArrowButton(onPressed: () {
                  Navigator.pop(context);
                }),
              ],
            );
          }
        },
      ),
    );
  }
}
