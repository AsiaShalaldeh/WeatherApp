class Weather {
  final String cityName;
  final double temperature;
  final String condition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['location']['name'],
      temperature: json['current']['temp_c'],
      condition: json['current']['condition']['text'],
    );
  }

  String getWeatherIcon() {
    return condition.toLowerCase().contains('rain')
        ? 'images/rain.png'
        : 'images/sun.png';
  }
}
