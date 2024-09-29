class Preferences {
  String? user;
  String? uid;
  String? location;
  double? distance;
  Map<String, int>? priceRange;
  String? propertyType;
  List<String>? amenities;

  Preferences({
    this.user,
    this.uid,
    this.location,
    this.distance,
    this.priceRange,
    this.propertyType,
    this.amenities,
  });

  // Convert preferences data to JSON format
  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'uid': uid,
      'location': location,
      'distance': distance,
      'priceRange': priceRange,
      'propertyType': propertyType,
      'amenities': amenities,
    };
  }
}
