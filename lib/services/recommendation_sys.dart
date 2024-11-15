import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gharsathi/model/Preferences.dart';

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
          location: data['location'],
          distance: data['distance'],
          priceRange: Map<String, int>.from(data['priceRange'] ?? []),
          propertyType: data['propertyType'],
          amenities: List<String>.from(data['amenities'] ?? []),
        );
      }
    } catch (e) {
      print(e.toString());
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
      double distance = await calculateDistance(
        userPreferences.location!,
        property['location'],
      );

      // Normalize distance score (closer = higher score)
      double maxDistance = userPreferences.distance ?? 50.0; // Default 50km
      double locationScore = 1.0 - (distance / maxDistance).clamp(0.0, 1.0);
      similarityScore += locationScore * featureWeights['location']!;
    }

    // Price range similarity
    if (userPreferences.priceRange != null && property['price'] != null) {
      int propertyPrice;
      if (property['price'] is String) {
        propertyPrice = int.tryParse(property['price']) ??
            0; // Default to 0 if parsing fails
      } else {
        propertyPrice = property['price'] as int;
      }
      double priceScore = calculatePriceScore(
        userPreferences.priceRange!,
        propertyPrice,
      );
      similarityScore += priceScore * featureWeights['price']!;
    }

    // Property type similarity
    if (userPreferences.propertyType != null &&
        property['propertyType'] != null) {
      double typeScore =
          userPreferences.propertyType == property['propertyType'] ? 1.0 : 0.0;
      similarityScore += typeScore * featureWeights['propertyType']!;
    }

    // Amenities similarity using Jaccard similarity
    if (userPreferences.amenities != null && property['amenities'] != null) {
      List<String> propertyAmenities = List<String>.from(property['amenities']);
      double amenitiesScore = calculateJaccardSimilarity(
        userPreferences.amenities!,
        propertyAmenities,
      );
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

    return intersection / union;
  }

  // Calculate price similarity score
  double calculatePriceScore(
      Map<String, int> preferredRange, int propertyPrice) {
    int minPrice = preferredRange['min'] ?? 0;
    int maxPrice = preferredRange['max'] ?? double.maxFinite.toInt();

    // If price is within range, give full score
    if (propertyPrice >= minPrice && propertyPrice <= maxPrice) {
      return 1.0;
    }

    // Calculate how far outside the range the price is
    double deviation;
    if (propertyPrice < minPrice) {
      deviation = (minPrice - propertyPrice) / minPrice;
    } else {
      deviation = (propertyPrice - maxPrice) / maxPrice;
    }

    // Convert deviation to a similarity score (1 - normalized deviation)
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

      //Only show rooms with Jaccard Similarity score greater than 0.5
      if (score > 0.6) {
        scoredProperties.add({
          'property': property,
          'score': score,
        });
      }
    }

    // Sort properties by similarity score
    scoredProperties.sort((a, b) => b['score'].compareTo(a['score']));

    // Return top N recommendations
    print(scoredProperties);
    return scoredProperties
        .take(limit)
        .map((item) => item['property'] as DocumentSnapshot)
        .toList();
  }

  //Method to calculate distance between two locations
  Future<double> calculateDistance(String location1, String location2) async {
    //Not implemented
    return 0.0;
  }
}
