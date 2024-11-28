import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:gharsathi/model/Preferences.dart';

class PreferenceServices {
  Future<void> savePreferences(Preferences preferences) async {
    try {
      await FirebaseFirestore.instance
          .collection('userPreference')
          .doc(FirebaseAuth.instance.currentUser!
              .uid) // Use current user's ID as document ID
          .set(preferences.toJson()); // Save the preferences data
    } catch (e) {
      print(e);
    }
  }

  Future<Preferences?> getPreferences() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
            .instance
            .collection('userPreference')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          Map<String, dynamic>? data = doc.data()!;
          return Preferences(
            user: data['user'],
            uid: data['uid'],
            location: {
              'address': data['location']['address'],
              'latitude': data['location']['latitude'],
              'longitude': data['location']['location'],
            },
            distance: data['distance'],
            price: data['price'].toDouble(),
            propertyType: data['propertyType'],
            amenities:
                List<String>.from(data['amenities'] as Iterable<dynamic>),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('getPreferences Error: $e');
      }
    }
    return null;
  }
}
