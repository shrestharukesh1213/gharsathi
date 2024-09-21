import 'package:flutter/material.dart';

class Roomcard extends StatefulWidget {
  final String roomTitle;
  final String description;
  final String location;
  final String price;
  final String image;

  const Roomcard(
      {required this.roomTitle,
      required this.description,
      required this.location,
      required this.price,
      required this.image,
      super.key});

  @override
  State<Roomcard> createState() => _RoomcardState();
}

class _RoomcardState extends State<Roomcard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(
                  widget.image,
                  width: 400, // Set width of the image
                  height: 200, // Set height of the image
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                'widget.roomTitle',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(Icons.location_on_outlined),
                  Text(widget.location),
                ],
              ),
              Text(widget.description),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('NPR.${widget.price}'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
