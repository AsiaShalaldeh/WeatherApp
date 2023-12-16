import 'package:flutter/material.dart';

import '../models/hourly-weather.dart';

class HourlyWeatherTile extends StatelessWidget {
  final HourlyWeather hourlyWeather;

  const HourlyWeatherTile({Key? key, required this.hourlyWeather})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: 120.0,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.transparent,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        elevation: 5.0,
        color: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${hourlyWeather.time.hour}:${hourlyWeather.time.minute}0',
                style: const TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              const SizedBox(height: 8.0),
              Image.network(
                "http:${hourlyWeather.icon}",
                height: 50,
                width: 50,
              ),
              const SizedBox(height: 8.0),
              Text(
                '${hourlyWeather.temperature} °C',
                style: const TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
