import 'package:flutter/material.dart';

class WeatherInfoTile extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String value;

  WeatherInfoTile({
    required this.iconData,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 100,
      width: 130,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Icon(
            iconData,
            size: 30.0,
            color: Colors.white,
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
