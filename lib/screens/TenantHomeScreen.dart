import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/model/Preferences.dart';
import 'package:gharsathi/services/recommendation_sys.dart';
import 'package:gharsathi/utils/utils.dart';
import 'package:gharsathi/widgets/RecommendationCard.dart';
import 'package:gharsathi/widgets/RoomCard.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Tenanthomescreen extends StatefulWidget {
  const Tenanthomescreen({super.key});

  @override
  State<Tenanthomescreen> createState() => _TenanthomescreenState();
}

class _TenanthomescreenState extends State<Tenanthomescreen> {
  final SearchController searchController = SearchController();
  bool _isLoading = false;
  final Preferences userPreferences = Preferences();
  final RecommendationSys recommender = RecommendationSys();
  String filterCategory = 'all';

  Future<List<DocumentSnapshot>>? _postedRoomsFuture;

  String? getCurrentUserUid() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid; // Returns null if no user is signed in
  }

  Future<List<DocumentSnapshot>> _fetchRooms() async {
    try {
      final QuerySnapshot result =
          await FirebaseFirestore.instance.collection('rooms').get();
      return result.docs;
    } catch (e) {
      showSnackBar(context, "Error fetching rooms");
      return [];
    }
  }

  Future<List<DocumentSnapshot>> _searchItems(String query) async {
    if (query.isEmpty) return [];
    query = query.toLowerCase();

    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('rooms')
          .where('name', isGreaterThanOrEqualTo: query)
          .limit(10)
          .get();

      return result.docs;
    } catch (e) {
      showSnackBar(context, "Error performing Search");
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _postedRoomsFuture = _fetchRooms();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Rent a room'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchAnchor(
                builder:
                    (BuildContext context, SearchController searchController) {
                  return SearchBar(
                    controller: searchController,
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.all(6),
                    ),
                    onTap: () {
                      searchController.openView();
                    },
                    onChanged: (_) {
                      searchController.openView();
                    },
                    leading: const Icon(Icons.search),
                    hintText: "Search House/Room",
                  );
                },
                suggestionsBuilder: (BuildContext context,
                    SearchController searchController) async {
                  setState(() {
                    _isLoading = true;
                  });

                  final results = await _searchItems(searchController.text);

                  setState(() {
                    _isLoading = false;
                  });

                  return results.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    if (kDebugMode) {
                      print(data);
                    }

                    return ListTile(
                      title: Text(data['name'] ?? "No name"),
                      subtitle: Text(data['price'] ?? "No price"),
                      onTap: () {
                        searchController.closeView("");
                        Navigator.pushNamed(context, '/details', arguments: {
                          "roomTitle": data['name'] ?? "No name",
                          "location": data['location'] ?? "No location",
                          "postedBy": data['postedBy'] ?? "No poster",
                          "propertyType": data['propertyType'],
                          "price": data['price'] ?? "No price",
                          "description":
                              data['description'] ?? "No description",
                          "images": data['images'] is List
                              ? List<String>.from(data['images'])
                              : <String>[],
                          "amenities": data['amenities'] is List
                              ? List<String>.from(data['amenities'])
                              : <String>[],
                          "roomId": doc.id,
                        });
                      },
                    );
                  }).toList();
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                "Recommended for you",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: FutureBuilder<List<DocumentSnapshot>>(
                future: recommender.getRecommendations(getCurrentUserUid()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    print(snapshot);
                    return const Center(
                      child: Text('Error loading recommendations'),
                    );
                  }

                  final recommendations = snapshot.data ?? [];

                  if (recommendations.isEmpty) {
                    return const Center(
                      child: Text('No recommendations available'),
                    );
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: recommendations.length,
                    itemBuilder: (context, index) {
                      final data =
                          recommendations[index].data() as Map<String, dynamic>;
                      return RecommendationCard(
                        roomTitle: data['name'] ?? 'Unnamed Property',
                        postedBy: data['postedBy'] ?? 'Unknown',
                        propertyType: data['propertyType'] ?? "Unknown",
                        description: data['description'] ?? 'No description',
                        location: data['location'] ?? 'No location',
                        price:
                            data['price']?.toString() ?? 'Price not available',
                        image: data['images']?[0] ?? '',
                        amenities: data['amenities'] ?? [],
                        postDate: data['postDate'] ?? '',
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                "All Posted Rooms",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return FutureBuilder<List<DocumentSnapshot>>(
                  future: _postedRoomsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Failed to load data'),
                      );
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text('No data found'));
                    } else {
                      final data = snapshot.data!;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                "/details",
                                arguments: {
                                  "roomTitle": data[index]['name'],
                                  "postedBy": data[index]['postedBy'],
                                  "location": data[index]['location'],
                                  "price": data[index]['price'],
                                  "description": data[index]['description'],
                                  "images": data[index]['images'],
                                  "amenities": data[index]['amenities'],
                                  "roomId": data[index].id,
                                  "propertyType": data[index]['propertyType'],
                                  "postDate": data[index]['postDate']
                                },
                              );
                            },
                            child: Roomcard(
                              roomTitle: data[index]['name'],
                              postedBy: data[index]['postedBy'],
                              location: data[index]['location'],
                              price: data[index]['price'],
                              description: data[index]['description'],
                              image: data[index]['images'][0],
                              amenities: data[index]['amenities'],
                              propertyType: data[index]['propertyType'],
                              postDate: data[index]['postDate'],
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              },
              childCount: 1, // Ensuring we are just building once
            ),
          ),
        ],
      ),
    );
  }
}
