class Preference {
  int? id;
  String cityName;
  // int? selectedCityId;

  Preference({
    // required this.id,
    required this.cityName,
    // this.selectedCityId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city_name': cityName
      // 'selected_city_id': selectedCityId,
    };
  }

  factory Preference.fromMap(Map<String, dynamic> map) {
    return Preference(
      // id: map['id'],
      cityName: map['city_name'],
      // selectedCityId: map['selected_city_id'],
    );
  }
}
