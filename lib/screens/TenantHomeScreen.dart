import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/services/RoomRecommendation.dart';
import 'package:gharsathi/widgets/RoomCard.dart';
import 'package:gharsathi/widgets/RoomsCard.dart';

class Tenanthomescreen extends StatefulWidget {
  const Tenanthomescreen({super.key});

  @override
  State<Tenanthomescreen> createState() => _TenanthomescreenState();
}

class _TenanthomescreenState extends State<Tenanthomescreen> {
  String filterCategory = 'all';
  List<Map<String, dynamic>> recommendedRooms = [];
  bool isLoadingRecommendations = true;

  @override
  void initState() {
    super.initState();
    fetchRecommendedRooms();
  }

  Future<void> fetchRecommendedRooms() async {
    try {
      // Get the current user's UID
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uid = user.uid;
        // Fetch recommended rooms based on the UID
        recommendedRooms = await RoomRecommendation().getRecommendedRooms(uid);
      } else {
        print("User is not logged in");
      }
    } catch (e) {
      print("Error fetching recommended rooms: $e");
    }
    setState(() {
      isLoadingRecommendations = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Rent a room'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLoadingRecommendations)
              Center(child: CircularProgressIndicator())
            else if (recommendedRooms.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Recommended for You",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: recommendedRooms.map((room) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/details",
                                arguments: {
                                  "roomTitle": room['name'],
                                  "postedBy": room['postedBy'],
                                  "location": room['location'],
                                  "price": room['price'],
                                  "description": room['description'],
                                  "images": room['images'],
                                  "amenities": room['amenities']
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Roomscard(
                              roomTitle: room['name'],
                              postedBy: room['postedBy'],
                              location: room['location'],
                              price: room['price'],
                              description: room['description'],
                              image: room['images'][0],
                              amenities: room['amenities'],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

            // Fetch and display posted rooms
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
                                  "amenities": data[index]['amenities']
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
    );
  }
}
