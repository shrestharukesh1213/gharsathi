import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/model/bookroom.dart';
import 'package:gharsathi/services/BookRoomService.dart';
import 'package:gharsathi/widgets/Esnackbar.dart';

class Roomdetails extends StatefulWidget {
  const Roomdetails({super.key});

  @override
  State<Roomdetails> createState() => _RoomdetailsState();
}

class _RoomdetailsState extends State<Roomdetails> {
  // Define a map to associate each amenity with its icon
  final Map<String, IconData> _amenityIcons = {
    'Gym': Icons.fitness_center,
    'School': Icons.school,
    'Hospital': Icons.local_hospital,
    'Swimming Pool': Icons.pool,
    'Supermarkets': Icons.shopping_cart,
    'Restaurants': Icons.restaurant,
    'Healthcare': Icons.health_and_safety,
    'Parks': Icons.park,
    'Banks': Icons.account_balance,
    'Coffee Shops': Icons.coffee,
  };

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    // Safely extract data with fallbacks for null values
    final String roomTitle = data['roomTitle'] ?? 'Unknown Room';
    final String postedBy = data['postedBy'] ?? 'Unknown';
    final String location = data['location'] ?? 'Unknown Location';
    final String price = data['price'] ?? 'N/A';
    final String description = data['description'] ?? 'No Description';
    final List<String> images = List<String>.from(data['images'] ?? []);
    final List<String> amenities =
        data['amenities'] != null ? List<String>.from(data['amenities']) : [];
    final String roomUid = data['roomId'] ?? '';
    final String propertyType = data['propertyType'] ?? 'Unknown';

    void Book() async {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Esnackbar.show(context, "User not logged in");
        return;
      }

      String? bookedBy = currentUser.displayName;
      DateTime bookDate = DateTime.now();
      String bookedHouse = roomTitle;
      String bookerUid = currentUser.uid;
      String roomId = roomUid;

      try {
        QuerySnapshot existingBooking = await FirebaseFirestore.instance
            .collection("bookingList")
            .where("bookerUid", isEqualTo: bookerUid)
            .where("bookedHouse", isEqualTo: bookedHouse)
            .get();

        if (existingBooking.docs.isNotEmpty) {
          Esnackbar.show(context, "You have already booked this room");
          return;
        }

        final booking = Bookroom(
          bookedBy: bookedBy,
          bookDate: bookDate,
          bookedHouse: bookedHouse,
          bookerUid: bookerUid,
          roomId: roomId,
        );

        await Bookroomservice().Booking(booking);

        Esnackbar.show(context, "Room Booked Successfully");
      } catch (e) {
        Esnackbar.show(
            context, "Failed to book room. ERROR CODE: ${e.toString()}");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(roomTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Image Carousel Section
          images.isNotEmpty
              ? CarouselSlider.builder(
                  itemCount: images.length,
                  options: CarouselOptions(
                    autoPlay: false,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  itemBuilder: (context, index, realIdx) {
                    return Container(
                      child: Center(
                          child: Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        width: 1000,
                      )),
                    );
                  },
                )
              : const Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No images available for this room.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),

          // Room Details Section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailText('Location: $location'),
                  _buildDetailText('Posted By: $postedBy'),
                  _buildDetailText('Price: Rs. $price'),
                  _buildDetailText('Property Type: $propertyType'),
                  _buildDetailText('Description:\n$description',
                      textAlign: TextAlign.justify),
                  amenities.isNotEmpty
                      ? Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children:
                              List<Widget>.generate(amenities.length, (index) {
                            return Chip(
                              avatar: Icon(
                                _amenityIcons[amenities[index]],
                                size: 20,
                              ),
                              label: Text(amenities[index]),
                            );
                          }),
                        )
                      : const Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'No amenities to show.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),

                  // Buttons for Booking and Contact
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: Book,
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        child: const Text("Book Room"),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Implement contact owner functionality here
                        },
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        child: const Text("Contact Owner"),
                      ),
                    ],
                  ),

                  // Room UID (for debugging or info display)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Room ID: $roomUid',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailText(String text,
      {TextAlign textAlign = TextAlign.start}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: textAlign,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
      ),
    );
  }
}