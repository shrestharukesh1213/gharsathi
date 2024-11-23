import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/screens/RegisterScreen.dart';
import 'package:gharsathi/services/SavedRoomService.dart';

class Roomcard extends StatefulWidget {
  final String roomTitle;
  final String postedBy;
  final String description;
  final String location;
  final String price;
  final String image;
  final List<dynamic> amenities;
  final String propertyType;
  final String postDate;

  const Roomcard({
    required this.roomTitle,
    required this.amenities,
    required this.postedBy,
    required this.description,
    required this.location,
    required this.price,
    required this.image,
    required this.propertyType,
    required this.postDate,
    super.key,
  });

  @override
  State<Roomcard> createState() => _RoomcardState();
}

class _RoomcardState extends State<Roomcard> {
  final SavedRoomService _savedRoomService = SavedRoomService();
  bool isSaved = false;
  bool _disposed = false;
  String? userType;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
    getUserType();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  User? user = FirebaseAuth.instance.currentUser;

  Future<void> getUserType() async {
    late final String? userId;

    if (user != null) {
      userId = user!.uid;
    }

    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    setState(() {
      userType = doc['usertype'];
    });
  }

  void _checkIfSaved() async {
    final saved = await _savedRoomService.isRoomSaved(widget.roomTitle);
    if (!_disposed && mounted) {
      setState(() {
        isSaved = saved;
      });
    }
  }

  void _toggleSave() async {
    final roomData = {
      'roomTitle': widget.roomTitle,
      'postedBy': widget.postedBy,
      'amenities': widget.amenities,
      'description': widget.description,
      'location': widget.location,
      'price': widget.price,
      'images': widget.image,
      'propertyType': widget.propertyType,
      'postDate': widget.postDate
    };

    await _savedRoomService.toggleSaveRoom(widget.roomTitle, roomData, isSaved);

    if (!_disposed && mounted) {
      setState(() {
        isSaved = !isSaved;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
      child: SizedBox(
        width: 300,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.image,
                    width: 400,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 8.0, bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.roomTitle,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined),
                          Text(
                            widget.location,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(widget.description),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'NPR.${widget.price}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (userType == "Tenant")
                        IconButton(
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: isSaved ? Colors.blue : Colors.black,
                          ),
                          onPressed: _toggleSave,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
