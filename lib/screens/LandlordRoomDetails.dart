import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Landlordroomdetails extends StatefulWidget {
  const Landlordroomdetails({super.key});

  @override
  State<Landlordroomdetails> createState() => _LandlordroomdetailsState();
}

class _LandlordroomdetailsState extends State<Landlordroomdetails> {
  final List<String> images = [];
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

    final String roomTitle = data['roomTitle'];
    final String location = data['location'];
    final String price = data['price'];
    final String propertyType = data['propertyType'] ?? "Not found";
    print(propertyType);
    final String description = data['description'];
    final List<String> images = List<String>.from(data['images']);
    // Extract amenities
    final List<String> amenities =
        data['amenities'] != null ? List<String>.from(data['amenities']) : [];
    final roomUid = data['roomId'];

    return Scaffold(
      appBar: AppBar(
        title: Text(roomTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
              child: CarouselSlider.builder(
            itemCount: images.length,
            options: CarouselOptions(
              autoPlay: false,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
            ),
            itemBuilder: (context, index, realIdx) {
              return Container(
                child: Center(
                    child: Image.network(images[index],
                        fit: BoxFit.cover, width: 1000)),
              );
            },
          )),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Location: $location',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Price: Rs.$price',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Property Type: $propertyType',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Description:\n $description',
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              amenities.isNotEmpty
                  ? Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children:
                          List<Widget>.generate(amenities.length, (int index) {
                        return Chip(
                          avatar: Icon(
                            _amenityIcons[
                                amenities[index]], // Get icon based on amenity
                            size: 20,
                          ),
                          label: Text(amenities[index]),
                        );
                      }),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'No amenities to show.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
              // Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Text("Room booked"),
              // )
            ],
          ),
          SizedBox.fromSize(
            size: const Size(100, 100),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder<QuerySnapshot?>(
                  future: FirebaseFirestore.instance
                      .collection("bookingList")
                      .where('roomId', isEqualTo: roomUid)
                      .limit(1)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Error: ${snapshot.error}"),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("Booked by:"),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(),
                            )
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("No Booking Data"),
                      );
                    } else {
                      final data = snapshot.data!.docs.first.data()
                          as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Booked By: ${data['bookedBy'] ?? "Not Booked"}\nBooker Id: ${data['bookerUid'] ?? "Not Booked"}",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                        ),
                      );
                    }
                  })
            ],
          )
        ],
      ),
    );
  }
}
