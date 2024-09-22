import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Roomdetails extends StatefulWidget {
  const Roomdetails({super.key});

  @override
  State<Roomdetails> createState() => _RoomdetailsState();
}

class _RoomdetailsState extends State<Roomdetails> {
  final List<String> images = [
    'https://media.designcafe.com/wp-content/uploads/2020/02/21010931/black-bedroom-wooden-panel-stripes.jpg',
    'https://api.gharpedia.com/wp-content/uploads/2020/05/Contemporary-Dark-Kitchen-02-0503070022.jpg',
    'https://img.freepik.com/premium-photo/modern-living-room-filled-with-furniture-large-window-modern-gray-dark-theme-ai-generation_295714-7099.jpg',
    'https://img.freepik.com/free-photo/minimalist-black-interior-with-black-sofa_1268-31786.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Screen '),
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
        ],
      ),
    );
  }
}
