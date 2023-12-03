class Weather {
  final String cityName;
  final double temperature;
  final String condition;
  final String icon;
  // final List<DayWeather> dailyForecast;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.icon,
    // required this.dailyForecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    // List<DayWeather> forecast = (json['forecast']['forecastday'] as List)
    //     .map((dayData) => DayWeather.fromJson(dayData['day']))
    //     .toList();

    return Weather(
      cityName: json['location']['name'],
      temperature: json['current']['temp_c'],
      condition: json['current']['condition']['text'],
      icon: json['current']['condition']['icon'],
      // dailyForecast: forecast,
    );
  }
}
