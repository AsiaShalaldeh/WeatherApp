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
    return Card(
      color: Colors.white,
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        height: 120.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
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
                    ),
                  ),
                  subtitle: Text(
                    '${widget.weatherOfCity.temperature}°C\n${widget.weatherOfCity.condition}',
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  leading: Image.network(
                    "http:${widget.weatherOfCity.icon}",
                    height: 40.0,
                    width: 40.0,
                  ),
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
                          : const Icon(Icons.star_border),
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
      ),
    );
  }
}
