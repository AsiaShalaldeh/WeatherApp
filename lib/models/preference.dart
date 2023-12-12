class Preference {
  // int? id;
  int? selectedCityId;

  Preference({
    // this.id,
    this.selectedCityId,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'selected_city_id': selectedCityId,
    };
  }

  factory Preference.fromMap(Map<String, dynamic> map) {
    return Preference(
      // id: map['id'],
      selectedCityId: map['selected_city_id'],
    );
  }
}
