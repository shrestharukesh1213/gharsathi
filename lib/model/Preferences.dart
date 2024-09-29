class Preferences {
  String? location;
  double? distance;
  Map<String, int>? priceRange;
  String? propertyType;
  List<String>? amenities;

  Preferences({
    this.location,
    this.distance,
    this.priceRange,
    this.propertyType,
    this.amenities,
  });

  // Convert preferences data to JSON format
  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'distance': distance,
      'priceRange': priceRange,
      'propertyType': propertyType,
      'amenities': amenities,
    };
  }
}
