import 'package:flutter/material.dart';

class SelectedCityProvider extends ChangeNotifier {
  String _selectedCity = 'London';

  String get selectedCity => _selectedCity;

  void updateSelectedCity(String newCity) {
    _selectedCity = newCity;
    notifyListeners();
  }
}
