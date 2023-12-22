class Preference {
  int? id;
  String cityName;

  Preference({
    required this.cityName,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'city_name': cityName};
  }

  factory Preference.fromMap(Map<String, dynamic> map) {
    return Preference(
      cityName: map['city_name'],
    );
  }
}
