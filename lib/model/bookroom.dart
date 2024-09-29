class Bookroom {
  String? bookedBy;
  DateTime? bookDate;
  String? bookedHouse;
  String? bookerUid;

  Bookroom({
    required this.bookedBy,
    required this.bookDate,
    required this.bookedHouse,
    required this.bookerUid,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookedBy': bookedBy,
      'bookDate': bookDate,
      'bookedHouse': bookedHouse,
      'bookerUid': bookerUid,
    };
  }
}
