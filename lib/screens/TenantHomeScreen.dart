import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/widgets/RoomCard.dart';

class Tenanthomescreen extends StatefulWidget {
  const Tenanthomescreen({super.key});

  @override
  State<Tenanthomescreen> createState() => _TenanthomescreenState();
}

class _TenanthomescreenState extends State<Tenanthomescreen> {
  String filterCategory = 'all';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rent a room'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<QuerySnapshot?>(
                future: filterCategory == "all"
                    ? FirebaseFirestore.instance.collection('rooms').get()
                    : FirebaseFirestore.instance
                        .collection('rooms')
                        .where("category", isEqualTo: filterCategory)
                        .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Failed to load data'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No data found'));
                  } else {
                    final data = snapshot.data!.docs;

                    return ListView.builder(
                        // crossAxisCount: 1,
                        // childAspectRatio: 0.5,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        // children: List.generate(data.length, (index)
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context, "/details",
                                // arguments: {
                                //   "roomTitle": data[index]['roomTitle'],
                                //   "location": data[index]['location'],
                                //   "price": data[index]['price'],
                                //   "description": data[index]['description'],
                                //   "images": data[index]['images'],
                                // },
                              );
                            },
                            child: Roomcard(
                              roomTitle: data[index]['name'],
                              location: data[index]['location'],
                              price: data[index]['price'],
                              description: data[index]['description'],
                              image: data[index]['images'][0],
                            ),
                          );
                        });
                  }
                })
          ],
        ),
      ),
    );
  }
}
