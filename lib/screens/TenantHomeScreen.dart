import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/utils/utils.dart';
import 'package:gharsathi/widgets/Esnackbar.dart';
import 'package:gharsathi/widgets/RoomCard.dart';

class Tenanthomescreen extends StatefulWidget {
  const Tenanthomescreen({super.key});

  @override
  State<Tenanthomescreen> createState() => _TenanthomescreenState();
}

class _TenanthomescreenState extends State<Tenanthomescreen> {
  final SearchController searchController = SearchController();
  bool _isLoading = false;

  Future<List<DocumentSnapshot>> _searchItems(String query) async {
    if (query.isEmpty) return [];

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

  String filterCategory = 'all';

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchAnchor(builder:
                (BuildContext context, SearchController searchController) {
              return SearchBar(
                controller: searchController,
                padding:
                    const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(6)),
                onTap: () {
                  searchController.openView();
                },
                onChanged: (_) {
                  searchController.openView();
                },
                leading: const Icon(Icons.search),
                hintText: "Search House/Room",
              );
            }, suggestionsBuilder: (BuildContext context,
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

                return ListTile(
                  title: Text(data['name'] ?? "No name"),
                  subtitle: Text(data['price'] ?? "No price"),
                  onTap: () {
                    searchController.closeView("");
                    Navigator.pushNamed(context, '/details', arguments: {
                      "roomTitle": data['name']?.toString() ?? "No name",
                      "location": data['location']?.toString() ?? "No location",
                      "postedBy": data['postedBy']?.toString() ?? "No poster",
                      "price": data['price']?.toString() ?? "No price",
                      "description":
                          data['description']?.toString() ?? "No description",
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
            }),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<QuerySnapshot?>(
                    future: filterCategory == "all"
                        ? FirebaseFirestore.instance.collection('rooms').get()
                        : FirebaseFirestore.instance
                            .collection('rooms')
                            .where("category", isEqualTo: filterCategory)
                            .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('Failed to load data'));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text('No data found'));
                      } else {
                        final data = snapshot.data!.docs;

                        return ListView.builder(
                            // crossAxisCount: 1,
                            // childAspectRatio: 0.5,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            // children: List.generate(data.length, (index)
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
                                    amenities: data[index]['amenities']),
                              );
                            });
                      }
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
