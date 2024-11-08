class Rooms {
  String? roomTitle;
  String? posterUid;
  String? postedBy;
  String? location;
  String? price;
  String? description;
  List<dynamic> amenities;
  List<String?>? images;
  int isBooked;
  String? propertyType;

  Rooms(
      {required this.roomTitle,
      required this.postedBy,
      required this.posterUid,
      required this.location,
      required this.price,
      required this.description,
      required this.amenities,
      required this.images,
      required this.isBooked,
      required this.propertyType});

  // map to json
  Map<String, dynamic> toJson() {
    return {
      'name': roomTitle,
      'posterUid': posterUid,
      'postedBy': postedBy,
      'location': location,
      'price': price,
      'description': description,
      'amenities': amenities,
      'images': images,
      'isBooked': 0,
      'propertyType': propertyType
    };
  }
}
