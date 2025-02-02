class Rooms {
  String? roomTitle;
  String? posterUid;
  String? postedBy;
  String? postedByEmail;
  Map<String, dynamic>? location;
  double? price;
  String? description;
  List<dynamic> amenities;
  List<String?>? images;
  int isBooked;
  String? propertyType;
  String postDate;

  Rooms(
      {required this.roomTitle,
      required this.postedBy,
      required this.posterUid,
      this.postedByEmail = '',
      required this.location,
      required this.price,
      required this.description,
      required this.amenities,
      required this.images,
      required this.isBooked,
      required this.propertyType,
      required this.postDate});

  // map to json
  Map<String, dynamic> toJson() {
    return {
      'name': roomTitle,
      'posterUid': posterUid,
      'postedBy': postedBy,
      'postedByEmail': postedByEmail,
      'location': location,
      'price': price,
      'description': description,
      'amenities': amenities,
      'images': images,
      'isBooked': 0,
      'propertyType': propertyType,
      'postDate': postDate
    };
  }
}
