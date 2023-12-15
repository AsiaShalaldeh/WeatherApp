import 'package:flutter/material.dart';

import '../models/weather.dart';

class SelectedCityProvider extends ChangeNotifier {
  String _selectedCity = 'London';
  late Weather _cityWeather;

  String get selectedCity => _selectedCity;
  Weather get selectedCityWeather => _cityWeather;

  void updateSelectedCity(String newCity, Weather cityWeather) {
    _selectedCity = newCity;
    _cityWeather = cityWeather;
    notifyListeners();
  }
}
