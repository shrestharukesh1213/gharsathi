import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Roomdetails extends StatefulWidget {
  const Roomdetails({super.key});

  @override
  State<Roomdetails> createState() => _RoomdetailsState();
}

class _RoomdetailsState extends State<Roomdetails> {
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
    final String postedBy = data['postedBy'];
    final String location = data['location'];
    final String price = data['price'];
    final String description = data['description'];
    final List<String> images = List<String>.from(data['images']);
    final List<String> amenities =
        data['amenities'] != null ? List<String>.from(data['amenities']) : [];
    print("Room details data: $data");

    // Extract amenities

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
                  'Posted By: $postedBy',
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
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'No amenities to show.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),

              // Buttons for "Book Room" and "Contact Owner"

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                          textStyle:
                              WidgetStatePropertyAll(TextStyle(fontSize: 20))),
                      child: const Text("Book Room"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                          textStyle:
                              WidgetStatePropertyAll(TextStyle(fontSize: 20))),
                      child: const Text("Contact Owner"),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
