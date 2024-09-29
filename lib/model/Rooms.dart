class Rooms {
  String? roomTitle;
  String? posterUid;
  String? postedBy;
  String? location;
  String? price;
  String? description;
  List<dynamic> amenities;
  List<String?>? images;

  Rooms({
    this.roomTitle,
    this.postedBy,
    this.posterUid,
    this.location,
    this.price,
    this.description,
    required this.amenities,
    this.images,
  });

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
    };
  }
}
