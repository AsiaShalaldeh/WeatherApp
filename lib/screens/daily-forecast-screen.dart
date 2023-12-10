import 'package:flutter/material.dart';

import '../models/day-weather.dart';
import '../services/weather_service.dart';
// import 'package:weatherapp/screens/weather_map_screen.dart';

class DailyForecastScreen extends StatefulWidget {
  final String cityName;

  const DailyForecastScreen({Key? key, required this.cityName})
      : super(key: key);

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
          await WeatherService().fetchDailyForecast(widget.cityName);

      final List<DayWeather> forecastData =
          (response['forecast']['forecastday'] as List)
              .map((dayData) => DayWeather.fromJson(dayData))
              .toList();

      return forecastData;
    } catch (e) {
      throw Exception('Failed to load daily forecast data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daily Forecast - ${widget.cityName}',
          style: const TextStyle(color: Colors.black),
        ),
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
            return _buildDailyForecastList(dailyForecast);
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
        return _buildDayForecastItem(dayForecast);
      },
    );
  }

  Widget _buildDayForecastItem(DayWeather dayForecast) {
    return ListTile(
      title: Text('${dayForecast.date}\n${dayForecast.condition}'),
      // Day #
      subtitle: Text('High: ${dayForecast.high}°C\nLow: ${dayForecast.low}°C'),
      leading: Image.network(
        "http:${dayForecast.icon}",
        height: 40.0,
        width: 40.0,
      ),
      trailing: ElevatedButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => WeatherMapScreen(cityName: widget.cityName),
          //   ),
          // );
        },
        child: const Text('Show on Map'),
      ),
    );
  }
}
