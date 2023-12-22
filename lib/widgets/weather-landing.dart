import 'package:flutter/material.dart';
import 'package:weatherapp/models/weather.dart';

class WeatherLanding extends StatelessWidget {
  final Weather weather;

  const WeatherLanding({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                weather.city.cityName,
                style: const TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24.0),
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
      ),
    );
  }
}
