import 'package:cloud_firestore/cloud_firestore.dart';

class RoomRecommendation {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getRecommendedRooms(String userId) async {
    // Fetch user's preferences
    DocumentSnapshot userPrefSnapshot =
        await _firestore.collection('userPreference').doc(userId).get();
    if (!userPrefSnapshot.exists) {
      throw Exception('User preferences not found.');
    }

    Map<String, dynamic> userPreferences =
        userPrefSnapshot.data() as Map<String, dynamic>;

    // Fetch all rooms
    QuerySnapshot roomsSnapshot = await _firestore.collection('rooms').get();
    List<Map<String, dynamic>> rooms = roomsSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    // Calculate similarity score for each room based on user preferences
    List<Map<String, dynamic>> scoredRooms = rooms.map((room) {
      double score = _calculateSimilarityScore(userPreferences, room);
      return {...room, 'score': score};
    }).toList();

    // Sort rooms by score in descending order for recommendation
    scoredRooms.sort((a, b) => b['score'].compareTo(a['score']));

    // Return top 5 recommended rooms (or you can modify this number)
    return scoredRooms.take(5).toList();
  }

  double _calculateSimilarityScore(
      Map<String, dynamic> userPreferences, Map<String, dynamic> room) {
    double score = 0.0;

    // Match amenities (assuming both userPreferences and room contain a list of amenities)
    List<String> userAmenities =
        List<String>.from(userPreferences['amenities']);
    List<String> roomAmenities = List<String>.from(room['amenities']);
    int matchingAmenities = userAmenities
        .where((amenity) => roomAmenities.contains(amenity))
        .length;
    score += (matchingAmenities / userAmenities.length) *
        0.4; // 40% weight for amenities

    // Match location (assuming exact match for simplicity, customize as needed)
    if (userPreferences['location'] == room['location']) {
      score += 0.3; // 30% weight for location
    }

    // Match price range (within a certain tolerance)
    int userMaxPrice = userPreferences['maxPrice'];
    int userMinPrice = userPreferences['minPrice'];
    int roomPrice = room['price'];
    if (roomPrice >= userMinPrice && roomPrice <= userMaxPrice) {
      score += 0.3; // 30% weight for price range match
    }

    return score;
  }
}
