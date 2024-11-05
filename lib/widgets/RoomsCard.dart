import 'package:flutter/material.dart';

class Roomscard extends StatelessWidget {
  final String roomTitle;
  final String postedBy;
  final String description;
  final String location;
  final String price;
  final String image;
  final List<dynamic> amenities;

  const Roomscard({
    Key? key,
    required this.roomTitle,
    required this.amenities,
    required this.postedBy,
    required this.description,
    required this.location,
    required this.price,
    required this.image,
  }) : super(key: key);

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
                    image,
                    width: double.infinity, // Full width of the card
                    height: 200, // Set height of the image
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: Text(
                    roomTitle,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.grey),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                  child: Text(
                    'NPR. $price',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Wrap(
                  spacing: 5,
                  children: amenities.map((amenity) {
                    return Chip(
                      label: Text(amenity),
                      labelStyle: const TextStyle(fontSize: 12),
                      backgroundColor: Colors.grey[200],
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
