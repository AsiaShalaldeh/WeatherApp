class City {
  final String cityName;
  final String cityImage;

  City({
    required this.cityName,
    required this.cityImage,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityName: json['name'],
      cityImage: json['image'],
    );
  }
}
