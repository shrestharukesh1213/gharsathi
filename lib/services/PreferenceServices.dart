import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gharsathi/model/Preferences.dart';

class PreferenceServices {
  Future<void> savePreferences(Preferences preferences) async {
    try {
      // Assuming you store preferences in a separate 'userPreference' collection
      await FirebaseFirestore.instance
          .collection('userPreference')
          .doc(FirebaseAuth.instance.currentUser!.uid) // Use current user's ID as document ID
          .set(preferences.toJson()); // Save the preferences data
    } catch (e) {
      print(e);
    }
  }
}
