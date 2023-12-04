class HourlyWeather {
  final DateTime time;
  final double temperature;
  final String icon;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.icon,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: DateTime.parse(json['time']),
      temperature: json['temp_c'],
      icon: json['condition']['icon'],
    );
  }
}
