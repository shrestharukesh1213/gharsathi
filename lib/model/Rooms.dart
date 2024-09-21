class Rooms {
  String? roomTitle;
  String? location;
  String? price;
  String? description;
  List<String?>? images;

  Rooms({
    this.roomTitle,
    this.location,
    this.price,
    this.description,
    this.images,
  });

  // map to json
  Map<String, dynamic> toJson() {
    return {
      'name': roomTitle,
      'location': location,
      'price': price,
      'description': description,
      'images': images,
    };
  }
}
