import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/services/property_filtering.dart';

class PropertyFilterDialog extends StatefulWidget {
  const PropertyFilterDialog({super.key});

  @override
  State<PropertyFilterDialog> createState() => _PropertyFilterDialogState();
}

class _PropertyFilterDialogState extends State<PropertyFilterDialog> {
  String? filterPropertyValue;
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  TextEditingController distanceController = TextEditingController();

  PropertyFiltering propertyFiltering = PropertyFiltering();
  Map<String, dynamic>? location;
  double? latitude;
  double? longitude;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> getUserLatLong(String? uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        if (userData.containsKey('location')) {
          location = userData['location'];
          if (location != null) {
            latitude = location?['latitude'];
            longitude = location?['longitude'];
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Set your current location from profile screen first")));
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }
    }
  }

  @override
  void initState() {
    if (currentUser != null) {
      getUserLatLong(currentUser!.uid);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: minPriceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: "Min Price"),
              ),
              TextField(
                controller: maxPriceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: "Max Price"),
              ),
              TextField(
                controller: distanceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: "Max Distance"),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Property Type",
                style: TextStyle(fontSize: 16),
              ),
              DropdownButton(
                style: TextStyle(fontSize: 14, color: Colors.black),
                hint: const Text('Select property type'),
                items: const [
                  DropdownMenuItem(
                      value: 'Apartment', child: Text('Apartment')),
                  DropdownMenuItem(value: 'House', child: Text('House')),
                  DropdownMenuItem(value: 'Room', child: Text('Room')),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    filterPropertyValue = newValue!;
                  });
                },
                value: filterPropertyValue,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () async {
                          if (double.parse(minPriceController.text) >
                              double.parse(maxPriceController.text)) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            "Max Price can't be lesser than Min Price"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Ok"))
                                      ],
                                    ),
                                  );
                                });
                          }
                          propertyFiltering.filterProperties(
                              latitude: latitude,
                              longitude: longitude,
                              maxDistKm: double.parse(distanceController.text),
                              minPrice: double.parse(minPriceController.text),
                              maxPrice: double.parse(maxPriceController.text),
                              propertyType: filterPropertyValue);
                        },
                        child: Text("Filter")),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
