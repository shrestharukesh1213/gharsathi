import 'package:flutter/material.dart';

class Roomcard extends StatefulWidget {
  final String roomTitle;
  final String postedBy;
  final String description;
  final String location;
  final String price;
  final String image;
  final List<dynamic> amenities;
  final String propertyType;

  //Roomcard structure
  const Roomcard({
    required this.roomTitle,
    required this.amenities,
    required this.postedBy,
    required this.description,
    required this.location,
    required this.price,
    required this.image,
    required this.propertyType,
    super.key,
  });

  @override
  State<Roomcard> createState() => _RoomcardState();
}

class _RoomcardState extends State<Roomcard> {
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.image,
                    width: 400, // Set width of the image
                    height: 200, // Set height of the image
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
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 0.0, bottom: 0.0),
                  child: Text(widget.description),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'NPR.${widget.price}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
