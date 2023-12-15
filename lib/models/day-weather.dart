class DayWeather {
  final String date;
  final double high;
  final double low;
  final String icon;
  final String condition;
  final double longitude;
  final double latitude;

  DayWeather({
    required this.date,
    required this.high,
    required this.low,
    required this.icon,
    required this.condition,
    required this.latitude,
    required this.longitude,
  });

  factory DayWeather.fromJson(
      Map<String, dynamic> json, double lon, double lat) {
    return DayWeather(
      date: json['date'],
      high: json['day']['maxtemp_c'],
      low: json['day']['mintemp_c'],
      condition: json['day']['condition']['text'],
      icon: json['day']['condition']['icon'],
      longitude: lon,
      latitude: lat,
    );
  }
}
