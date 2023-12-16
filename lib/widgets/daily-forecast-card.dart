import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/day-weather.dart';

class DailyForecastCard extends StatelessWidget {
  final DayWeather dailyForecast;
  final String cityName;

  DailyForecastCard(this.dailyForecast, this.cityName);

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(dailyForecast.date);
    String formattedDayName = DateFormat('EEEE').format(parsedDate);

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 350.0,
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
              cityName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              formattedDayName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Image.network(
              'http:${dailyForecast.icon}',
              height: 130.0,
              width: 130.0,
              fit: BoxFit.cover,
            ),
            Text(
              dailyForecast.condition,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${dailyForecast.high}',
              style: const TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
            Text(
              '${dailyForecast.low}',
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
