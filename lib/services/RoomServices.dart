import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:gharsathi/model/Rooms.dart';

class Roomservices {
  // upload each images to firebase storage
  Future<String?> uploadImage(File imageFile) async {
    try {
      // path to storage
      final path = 'rooms/${DateTime.now()}.png';
      final file = File(imageFile.path);
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> createRoom(Rooms room) async {
    try {
      await FirebaseFirestore.instance.collection('rooms').add(room.toJson());
    } catch (e) {
      print(e);
    }
  }
}
