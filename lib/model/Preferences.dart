class Preferences {
  String? user;
  String? uid;
  Map<String, dynamic>? location;
  double? distance;
  double? price;
  String? propertyType;
  List<String>? amenities;

  Preferences({
    this.user,
    this.uid,
    this.location,
    this.distance,
    this.price,
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
      'price': price,
      'propertyType': propertyType,
      'amenities': amenities,
    };
  }
}
