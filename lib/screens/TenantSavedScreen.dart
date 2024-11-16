import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gharsathi/screens/RoomDetails.dart';

class TenantSavedScreen extends StatefulWidget {
  @override
  _TenantSavedScreenState createState() => _TenantSavedScreenState();
}

class _TenantSavedScreenState extends State<TenantSavedScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saved Rooms")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('savedRooms')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final savedRooms = snapshot.data!.docs;

          if (savedRooms.isEmpty) {
            return Center(
              child: Text("No saved rooms yet"),
            );
          }

          return ListView.builder(
            itemCount: savedRooms.length,
            itemBuilder: (context, index) {
              final room = savedRooms[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(room['roomTitle'] ?? 'No Title'),
                subtitle: Text(room['location'] ?? 'No Location'),
                trailing: Text('NPR. ${room['price'] ?? 'N/A'}'),
                leading: room['image'] != null
                    ? Image.network(
                        room['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.image, size: 50),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Roomdetails(),
                      settings: RouteSettings(
                        arguments: {
                          'roomTitle': room['roomTitle'] ?? 'No Title',
                          'postedBy': room['postedBy'] ?? 'Unknown',
                          'location': room['location'] ?? 'Unknown Location',
                          'price': room['price'] ?? 'N/A',
                          'description': room['description'] ?? 'No Description',
                          'images': List<String>.from(room['images'] ?? []),
                          'amenities': List<String>.from(room['amenities'] ?? []),
                          'roomId': room['roomId'] ?? '',
                          'propertyType': room['propertyType'] ?? 'Unknown',
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
