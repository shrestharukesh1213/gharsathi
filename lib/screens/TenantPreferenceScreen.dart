import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/model/Preferences.dart';
import 'package:gharsathi/screens/tenantLocationSelectScreen.dart';
import 'package:gharsathi/services/PreferenceServices.dart';
import 'package:gharsathi/utils/utils.dart';

class Tenantpreferencescreen extends StatefulWidget {
  const Tenantpreferencescreen({super.key});

  @override
  State<Tenantpreferencescreen> createState() => _TenantpreferencescreenState();
}

class _TenantpreferencescreenState extends State<Tenantpreferencescreen> {
  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;

  String address = 'Not Set';
  late double latitude;
  late double longitude;
  User? currentUser = FirebaseAuth.instance.currentUser;

  //location silder

  double price = 5000;

  //property Type
  String dropdownPropertyValue = "Apartment";

  //price range

  // List of amenities with their current checked status
  final List<String> _amenitiesOptions = [
    'Gym',
    'School',
    'Hospital',
    'Swimming Pool',
    'Supermarkets',
    'Restaurants',
    'Healthcare',
    'Parks',
    'Banks',
    'Coffee Shops'
  ];

  final List<bool> _isSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  void initState() {
    super.initState();
    _initializeDefaultValues();
    loadPreferences();
  }

  void _initializeDefaultValues() {
    price = 5000;
    dropdownPropertyValue = "Apartment";
  }

  Future<void> loadPreferences() async {
    setState(() {
      _isLoading = false;
    });
    try {
      PreferenceServices preferenceServices = PreferenceServices();
      if (currentUser != null) {
        Preferences? preferences = await preferenceServices.getPreferences();
        if (preferences != null) {
          setState(() {
            address = preferences.location!['address'] ?? '';
            latitude = preferences.location!['latitude'] ?? 0.0;
            longitude = preferences.location!['longitude'] ?? 0.0;
            distanceController.text = preferences.distance.toString();
            priceController.text = preferences.price.toString();
            dropdownPropertyValue = preferences.propertyType ?? "Apartment";

            if (preferences.amenities != null) {
              for (int i = 0; i <= _amenitiesOptions.length - 1; i++) {
                _isSelected[i] =
                    preferences.amenities!.contains(_amenitiesOptions[i]);
              }
            }
          });
        }
      }
    } catch (e) {
      showSnackBar(context, "Error Loading Preferences: $e");
      if (kDebugMode) {
        debugPrint("Error Loading Preferences: $e");
      }
    }
  }

  Future<void> updateUserPrefsLocation(
      String userId, String address, double latitude, double longitude) async {
    try {
      if (currentUser != null) {
        DocumentReference userPrefDoc =
            FirebaseFirestore.instance.collection('userPreference').doc(userId);

        DocumentSnapshot snapshot = await userPrefDoc.get();
        if (snapshot.exists) {
          await userPrefDoc.update({
            "location": {
              "address": address,
              "latitude": latitude,
              "longitude": longitude,
            },
          });
          setState(() {
            address = snapshot['location']['address'];
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed updating location: $e")));
    }
  }

  TextEditingController priceController = TextEditingController();
  TextEditingController distanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preference Screen'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // DropdownButton(
            //   hint: const Text('Select an option'),
            //   items: const [
            //     DropdownMenuItem(child: Text("Bhaktapur"), value: "Bhaktapur"),
            //     DropdownMenuItem(child: Text("Kathmandu"), value: "Kathmandu"),
            //     DropdownMenuItem(child: Text("Lalitpur"), value: "Lalitpur"),
            //     DropdownMenuItem(child: Text("Kritipur"), value: "Kritipur"),
            //   ],
            //   onChanged: (String? newValue) {
            //     setState(() {
            //       dropdownLocationValue = newValue!;
            //     });
            //   },
            //   value: dropdownLocationValue,
            // ),
            const Text(
              "Set distance preference",
              style: TextStyle(fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: distanceController,
                maxLength: 5,
              ),
            ),

            const SizedBox(height: 20),
            const Center(
                child:
                    Text('Price Preference', style: TextStyle(fontSize: 18))),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: priceController,
                maxLength: 7,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Select Location Preference',
                    style: TextStyle(fontSize: 18)),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: OutlinedButton(
                    child: Icon(
                      Icons.add_location,
                    ),
                    onPressed: () async {
                      final Map<String, dynamic>? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TenantLocationSelectScreen(
                                    navigationSource:
                                        NavigationSource.userPreferences,
                                  )));
                      if (result != null && currentUser != null) {
                        address = result['address'];
                        latitude = result['latitude'];
                        longitude = result['longitude'];
                        if (kDebugMode) {
                          print(result);
                          print(address);
                          print(latitude);
                          print(longitude);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 325, child: Text("Current Location: $address")),
            const SizedBox(height: 20),
            const Text('Property Type', style: TextStyle(fontSize: 18)),
            DropdownButton(
              hint: const Text('Select an option'),
              items: const [
                DropdownMenuItem(value: 'Apartment', child: Text('Apartment')),
                DropdownMenuItem(value: 'House', child: Text('House')),
                DropdownMenuItem(value: 'Room', child: Text('Room')),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  dropdownPropertyValue = newValue!;
                });
              },
              value: dropdownPropertyValue,
            ),
            const SizedBox(height: 20),
            const Text('Nearby Amenities', style: TextStyle(fontSize: 18)),
            Wrap(
              spacing: 8.0, // Spacing between chips
              children:
                  List<Widget>.generate(_amenitiesOptions.length, (int index) {
                return FilterChip(
                  label: Text(_amenitiesOptions[index]),
                  selected: _isSelected[index],
                  onSelected: (bool selected) {
                    setState(() {
                      _isSelected[index] = selected;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _savePreferencesToFirestore,
                child: const Text('Save Preferences')),
          ],
        ),
      ),
    );
  }

  Future<void> _savePreferencesToFirestore() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      List<String> selectedAmenities = [];
      for (int i = 0; i < _amenitiesOptions.length; i++) {
        if (_isSelected[i]) {
          selectedAmenities.add(_amenitiesOptions[i]);
        }
      }

      // Create a Preferences object
      Preferences preferences = Preferences(
        user: currentUser.displayName,
        uid: currentUser.uid,
        location: {
          'address': address,
          'latitude': latitude,
          'longitude': longitude
        },
        distance: double.parse(distanceController.text),
        price: double.parse(priceController.text),
        propertyType: dropdownPropertyValue,
        amenities: selectedAmenities,
      );

      // Save the preferences using PreferenceServices
      PreferenceServices preferenceServices = PreferenceServices();
      try {
        await preferenceServices.savePreferences(preferences);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Preferences saved successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save preferences: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in!')),
      );
    }
  }
}
