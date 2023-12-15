class City {
  final int id;
  final String cityName;
  final String cityImage;
  String? longitude;
  String? latitude;

  City(
      {required this.cityName,
      required this.cityImage,
      required this.id,
      this.longitude,
      this.latitude});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      cityName: json['name'],
      cityImage: json['image'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city_name': cityName,
      'city_image': cityImage,
    };
  }

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: map['id'],
      cityName: map['city_name'],
      cityImage: map['city_image'],
    );
  }
}
