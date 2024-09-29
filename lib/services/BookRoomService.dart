import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gharsathi/model/bookroom.dart';

class Bookroomservice {
  Future<void> Booking(Bookroom bookroom) async {
    try {
      FirebaseFirestore.instance
          .collection('bookingList')
          .add(bookroom.toJson());
    } catch (e) {}
  }
}
