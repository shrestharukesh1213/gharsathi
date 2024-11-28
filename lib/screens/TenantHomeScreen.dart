import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
  String searchQuery = '';

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
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align items to the start
                children: [
                  CupertinoSearchTextField(
                    placeholder: 'Search rooms',
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.trim(); // Update the search query
                      });
                    },
                  ),
                  if (searchQuery.isNotEmpty) ...[
                    SizedBox(height: 20), // Spacing between widgets
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("rooms")
                          .where("propertyType",
                              isGreaterThanOrEqualTo: searchQuery)
                          .where("propertyType",
                              isLessThanOrEqualTo: searchQuery + '\uf8ff')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CupertinoActivityIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading data'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No results found'));
                        } else {
                          final data = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: data.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/details",
                                    arguments: {
                                      "roomTitle": data[index]['name'],
                                      "postedBy": data[index]['postedBy'],
                                      "location": data[index]['location']
                                          ['address'],
                                      "price": data[index]['price'],
                                      "description": data[index]['description'],
                                      "images": data[index]['images'],
                                      "amenities": data[index]['amenities'],
                                      "roomId": data[index].id,
                                      "propertyType": data[index]
                                          ['propertyType'],
                                      "postDate": data[index]['postDate']
                                    },
                                  );
                                },
                                child: ListTile(
                                  leading: SizedBox(
                                    width: 50, // Set a fixed width
                                    height: 50, // Set a fixed height
                                    child: Image.network(
                                      data[index]['images'][0],
                                      fit: BoxFit
                                          .cover, // Ensure the image fits the box
                                    ),
                                  ),
                                  title: Text(data[index]['name']),
                                  subtitle: Text(data[index]['description']),
                                  trailing: Icon(Icons.arrow_forward_ios),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ],
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
                        location: data['location']['address'] ?? 'No location',
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
                                  "location": data[index]['location']
                                      ['address'],
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
                              location: data[index]['location']['address'],
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
