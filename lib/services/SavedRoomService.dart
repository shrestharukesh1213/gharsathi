import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SavedRoomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isRoomSaved(String roomId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return false;

    final savedRoomRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('savedRooms')
        .doc(roomId);

    final doc = await savedRoomRef.get();
    return doc.exists;
  }

  Future<void> toggleSaveRoom(String roomId, Map<String, dynamic> roomData, bool isSaved) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final savedRoomRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('savedRooms')
        .doc(roomId);

    if (isSaved) {
      await savedRoomRef.delete(); // Unsave the room
    } else {
      await savedRoomRef.set({
        ...roomData,
        'savedAt': Timestamp.now(),
      });
    }
  }
}