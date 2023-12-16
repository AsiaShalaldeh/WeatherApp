import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/preference.dart';
import '../models/weather.dart';
import '../providers/database-provider.dart';
import '../providers/selected-city-provider.dart';
import '../screens/more-info-screen.dart';

class CityCard extends StatefulWidget {
  final Weather weatherOfCity;

  CityCard({Key? key, required this.weatherOfCity}) : super(key: key);

  @override
  State<CityCard> createState() => _CityCardState();
}

class _CityCardState extends State<CityCard> {
  Future<void> _deleteFavorite() async {
    await DatabaseProvider.instance.deletePreference(
      widget.weatherOfCity.city.cityName,
    );
  }

  Future<void> _addFavorite() async {
    await DatabaseProvider.instance.insertPreference(
      Preference(
        cityName: widget.weatherOfCity.city.cityName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.0,
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      margin: const EdgeInsets.all(16.0),
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
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  widget.weatherOfCity.city.cityName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.white),
                ),
                subtitle: Text(
                  '${widget.weatherOfCity.temperature}°C\n${widget.weatherOfCity.condition}',
                  style: const TextStyle(fontSize: 14.0, color: Colors.white),
                ),
                leading: Image.network("http:${widget.weatherOfCity.icon}",
                    height: 40.0, width: 40.0),
              ),
            ],
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: FutureBuilder<bool>(
              future: DatabaseProvider.instance
                  .isFavorite(widget.weatherOfCity.city.cityName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    color: Colors.green,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final isFavorite = snapshot.data ?? false;
                  return IconButton(
                    icon: isFavorite
                        ? const Icon(Icons.star, color: Colors.yellow)
                        : const Icon(Icons.star_border, color: Colors.white),
                    onPressed: () async {
                      if (isFavorite) {
                        await _deleteFavorite();
                      } else {
                        await _addFavorite();
                      }
                      setState(() {});
                    },
                  );
                }
              },
            ),
          ),
          Positioned(
            bottom: 8.0,
            right: 8.0,
            child: ElevatedButton(
              onPressed: () {
                Provider.of<SelectedCityProvider>(context, listen: false)
                    .updateSelectedCity(widget.weatherOfCity.city.cityName,
                        widget.weatherOfCity);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoreInformationScreen(
                      cityWeather: widget.weatherOfCity,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green.shade300,
              ),
              child: const Text('More Info',
                  style: TextStyle(fontSize: 14.0, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
