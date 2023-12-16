class HourlyWeather {
  final DateTime time;
  final DateTime currentTime;
  final double temperature;
  final String icon;

  HourlyWeather({
    required this.time,
    required this.currentTime,
    required this.temperature,
    required this.icon,
  });

  factory HourlyWeather.fromJson(
      Map<String, dynamic> json, String currentTime) {
    return HourlyWeather(
      time: DateTime.parse(json['time']),
      currentTime: DateTime.parse(currentTime),
      temperature: json['temp_c'],
      icon: json['condition']['icon'],
    );
  }
}
