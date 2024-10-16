class Bookroom {
  String? bookedBy;
  DateTime? bookDate;
  String? bookedHouse;
  String? bookerUid;
  String? roomId;

  Bookroom({
    required this.bookedBy,
    required this.bookDate,
    required this.bookedHouse,
    required this.bookerUid,
    required this.roomId,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookedBy': bookedBy,
      'bookDate': bookDate,
      'bookedHouse': bookedHouse,
      'bookerUid': bookerUid,
      'roomId': roomId,
    };
  }
}
