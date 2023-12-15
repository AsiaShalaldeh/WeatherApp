import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import 'package:intl/intl.dart';

import '../models/city.dart';
import '../models/day-weather.dart';
import '../services/weather_service.dart';

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
      appBar: AppBar(
        title: Text(
          widget.city.cityName,
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<DayWeather>>(
        future: dailyForecastData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<DayWeather> dailyForecast = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/images/mountain.jpg"),
                  fit: BoxFit.cover,
                ),
                color: Colors.black.withOpacity(0.1),
              ),
              child: _buildDailyForecastList(dailyForecast),
            );
            // FloatingActionButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => WeatherMapScreen(
            //           dayWeather: dailyForecast[0],
            //           city: widget.city,
            //         ),
            //       ),
            //     );
            //   },
            //   child: const Icon(Icons.map),
            // ),
          }
        },
      ),
    );
  }

  Widget _buildDailyForecastList(List<DayWeather> dailyForecast) {
    return ListView.builder(
      itemCount: dailyForecast.length,
      itemBuilder: (context, index) {
        DayWeather dayForecast = dailyForecast[index];
        DateTime parsedDate = DateTime.parse(dayForecast.date);
        String dayName = DateFormat('EEEE').format(parsedDate);
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 300.0,
          margin: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ListTile(
            subtitle: Column(
              children: [
                Text(
                  dayName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
                Image.network(
                  "http:${dayForecast.icon}",
                  height: 130.0,
                  width: 130.0,
                  fit: BoxFit.cover,
                ),
                Text(
                  dayForecast.condition,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${dayForecast.high}°C',
                  style: const TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${dayForecast.low}°C',
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
