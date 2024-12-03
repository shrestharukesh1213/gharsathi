import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;

class PropertyFiltering {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> filterProperties(
      {double? latitude,
      double? longitude,
      double? maxDistKm,
      double? minPrice,
      double? maxPrice,
      String? propertyType}) async {
    Query query = _firestore.collection("rooms");

    try {
      if (minPrice != null) {
        query = query.where("price", isGreaterThanOrEqualTo: minPrice);
      }

      if (maxPrice != null) {
        query = query.where("price", isLessThanOrEqualTo: maxPrice);
      }

      if (propertyType != null) {
        query = query.where("propertyType", isEqualTo: propertyType);
      }

      QuerySnapshot querySnapshot = await query.get();

      List<Map<String, dynamic>> results = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      if (latitude != null && longitude != null && maxDistKm != null) {
        final filteredResults = results.where((property) {
          if (property['location'] != null &&
              property['location']['latitude'] != null &&
              property['location']['longitude'] != null) {
            final double propertyLat = property['location']['latitude'];
            final double propertyLong = property['location']['longitude'];
            final double distance = calculateDistance(
                latitude, longitude, propertyLat, propertyLong);

            return distance <= maxDistKm;
          }
          return false;
        }).toList();

        return filteredResults;
      }

      return results;
    } catch (e) {
      print("Error filtering properties: $e");
      return [];
    }
  }

  //Haversine algorithm to calculate distance between user and properties
  double calculateDistance(
      double lat1, double long1, double lat2, double long2) {
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
    // print("distance: $distance");
    return distance;
  }
}
