import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecommendationCard extends StatelessWidget {
  final String roomTitle;
  final String postedBy;
  final String propertyType;
  final String description;
  final String location;
  final double price;
  final String image;
  final List amenities;
  final String postDate;
  final String? posterUid;
  final String? postedByEmail;

  const RecommendationCard({
    super.key,
    required this.roomTitle,
    required this.propertyType,
    required this.postedBy,
    required this.description,
    required this.location,
    required this.price,
    required this.image,
    required this.amenities,
    required this.postDate,
    required this.posterUid,
    this.postedByEmail = '',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/details',
          arguments: {
            "roomTitle": roomTitle,
            "postedBy": postedBy,
            "location": location,
            "price": price,
            "propertyType": propertyType,
            "description": description,
            "images": [
              image
            ], // Wrapping single image in a list for consistency
            "amenities": amenities,
            "roomId": "",
            "postDate": postDate,
            "posterUid": posterUid,
            "postedByEmail": postedByEmail,
          },
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property Image
              AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child:
                          const Icon(Icons.home, size: 48, color: Colors.grey),
                    ),
                  )),

              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Property Title
                    Text(
                      roomTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Price
                    Text(
                      "Rs. $price",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    const SizedBox(height: 4),

                    // Location
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            location,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
