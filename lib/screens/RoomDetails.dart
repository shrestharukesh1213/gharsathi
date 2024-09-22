import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Roomdetails extends StatefulWidget {
  const Roomdetails({super.key});

  @override
  State<Roomdetails> createState() => _RoomdetailsState();
}

class _RoomdetailsState extends State<Roomdetails> {
  final List<String> images = [];
  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final String roomTitle = data['roomTitle'];
    final String location = data['location'];
    final String price = data['price'];
    final String description = data['description'];
    final List<String> images = List<String>.from(data['images']);

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
                  'Description:\n $description',
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
