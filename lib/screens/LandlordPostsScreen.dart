import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/RoomCard.dart';

class Landlordpostsscreen extends StatefulWidget {
  const Landlordpostsscreen({super.key});

  @override
  State<Landlordpostsscreen> createState() => _LandlordpostsscreenState();
}

class _LandlordpostsscreenState extends State<Landlordpostsscreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    String filterCategory = currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot?>(
                stream: FirebaseFirestore.instance
                    .collection('rooms')
                    .where("posterUid", isEqualTo: filterCategory)
                    .snapshots(),
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
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                "/landlordroomdetails",
                                arguments: {
                                  "roomTitle": data[index]['name'],
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
