import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:gharsathi/model/Preferences.dart';
import 'dart:math' as math;

class RecommendationSys {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Weights for different features
  static const Map<String, double> featureWeights = {
    'location': 0.4,
    'price': 0.3,
    'propertyType': 0.15,
    'amenities': 0.15,
  };

  Future<Preferences?> getUserPreferences(String? uid) async {
    try {
      DocumentSnapshot userPreferencesSnapshot =
          await _firestore.collection('userPreference').doc(uid).get();

      if (userPreferencesSnapshot.exists) {
        Map<String, dynamic> data =
            userPreferencesSnapshot.data() as Map<String, dynamic>;

        return Preferences(
          location: data['location'] is Map
              ? {
                  'address': data['location']['address'],
                  'latitude': data['location']['latitude'],
                  'longitude': data['location']['longitude'],
                }
              : null,
          distance: data['distance'],
          price: data['price'],
          propertyType: data['propertyType'],
          amenities: List<String>.from(data['amenities'] ?? []),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }

  // Calculate similarity score between user preferences and a property
  Future<double> calculateSimilarityScore(
    Preferences userPreferences,
    DocumentSnapshot property,
  ) async {
    double similarityScore = 0.0;

    // Location similarity using distance calculation
    // Location choosing on the map is not implemented so default of 0.0 is set for now
    if (userPreferences.location != null && property['location'] != null) {
      try {
        // Extract coordinates from location
        Map<String, dynamic> userLocation = userPreferences.location!;
        Map<String, dynamic> propertyLocation = property['location'];

        // Ensure we have valid coordinate lists with at least 2 elements
        if (userLocation['latitude'] != null &&
            userLocation['longitude'] != null &&
            propertyLocation['latitude'] != null &&
            propertyLocation['longitude'] != null) {
          //Send user and property coordinates to calculateDistance function and
          //receive the distance between properties
          double distance = await calculateDistance(
              userLocation['latitude'],
              userLocation['longitude'],
              propertyLocation['latitude'],
              propertyLocation['longitude']);

          //Print latitudes and longitudes for debugging
          // if (kDebugMode) {
          //   print("user lat: ${userLocation['latitude']}");
          //   print("user long: ${userLocation['longitude']}");
          //   print("prop lat ${propertyLocation['latitude']}");
          //   print("prop long ${propertyLocation['longitude']}");
          // }

          // Set maximum distance threshold from user preferences
          double maxDistance = userPreferences.distance ?? 50.0;

          // Calculate location score
          double locationScore = 1.0 - (distance / maxDistance).clamp(0.0, 1.0);
          similarityScore += locationScore * featureWeights['location']!;

          if (kDebugMode) {
            // print('Distance: ${distance.toStringAsFixed(2)} km');
            // print('Location Score: ${locationScore.toStringAsFixed(2)}');
          }
        } else {
          // Handle incomplete location data
          print('Incomplete location coordinates');
        }
      } catch (e) {
        print('Location scoring error: $e');
      }
    }

    // Price range similarity
    if (userPreferences.price != null && property['price'] != null) {
      double propertyPrice = (property['price'] as num).toDouble();
      double priceScore = calculatePriceScore(
        userPreferences.price!,
        propertyPrice,
      );
      //print("Price Score: $priceScore");
      similarityScore += priceScore * featureWeights['price']!;
    }

    // Property type similarity
    if (userPreferences.propertyType != null &&
        property['propertyType'] != null) {
      double typeScore =
          userPreferences.propertyType == property['propertyType'] ? 1.0 : 0.0;
      similarityScore += typeScore * featureWeights['propertyType']!;
      //print("Type Score: $typeScore");
    }

    // Amenities similarity using Jaccard similarity
    if (userPreferences.amenities != null && property['amenities'] != null) {
      List<String> propertyAmenities = List<String>.from(property['amenities']);
      double amenitiesScore = calculateJaccardSimilarity(
        userPreferences.amenities!,
        propertyAmenities,
      );
      //print("Amenities Score: $amenitiesScore");
      similarityScore += amenitiesScore * featureWeights['amenities']!;
    }

    return similarityScore;
  }

  // Calculate Jaccard similarity between two lists of amenities
  double calculateJaccardSimilarity(List<String> list1, List<String> list2) {
    Set<String> set1 = list1.toSet();
    Set<String> set2 = list2.toSet();

    double intersection = set1.intersection(set2).length.toDouble();
    double union = set1.union(set2).length.toDouble();
    //print("Jaccard Score:${intersection / union}");
    return intersection / union;
  }

  // Calculate price similarity score
  double calculatePriceScore(double price, double propertyPrice) {
    // Calculate the deviation as the absolute difference between userPrice and propertyPrice
    double deviation = (price - propertyPrice).abs() / price;

    // Convert the deviation into a similarity score (1 - normalized deviation)
    return (1 - deviation.clamp(0.0, 1.0));
  }

  // Get property recommendations for a user
  Future<List<DocumentSnapshot>> getRecommendations(String? uid,
      {int limit = 10}) async {
    // Fetch User Preferences
    Preferences? userPreferences = await getUserPreferences(uid);
    if (userPreferences == null) {
      //print("No user preferences found for uid: $uid");
      return [];
    }
    QuerySnapshot propertiesSnapshot =
        await _firestore.collection('rooms').get();

    List<Map<String, dynamic>> scoredProperties = [];

    //Calculate Jaccard Similarity score for properties
    for (var property in propertiesSnapshot.docs) {
      double score = await calculateSimilarityScore(userPreferences, property);
      // print("Score: $score");

      //Only show rooms with Weighted Similarity score greater than 0.3
      if (score > 0.3) {
        scoredProperties.add({
          'property': property,
          'score': score,
        });
      }
    }

    // Sort properties by similarity score
    scoredProperties.sort((a, b) => b['score'].compareTo(a['score']));

    // Return top N recommendations
    return scoredProperties
        .take(limit)
        .map((item) => item['property'] as DocumentSnapshot)
        .toList();
  }

  //Method to calculate distance between two locations using Haversine formula
  Future<double> calculateDistance(
      double lat1, double long1, double lat2, double long2) async {
    //Calc distance between latitudes and longitudes
    double dLat = (lat2 - lat1) * math.pi / 180.0;
    double dLon = (long2 - long1) * math.pi / 180.0;

    lat1 = (lat1) * math.pi / 180.0;
    lat2 = (lat2) * math.pi / 180.0;

    double value = math.pow(math.sin(dLat / 2), 2) +
        math.pow(math.sin(dLon / 2), 2) * math.cos(lat1) * math.cos(lat2);

    double rad = 6371;
    double value2 = 2 * math.asin(math.sqrt(value));
    double distance = rad * value2;
    return distance;
  }
}
