import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/model/Preferences.dart';
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
  //dropdownmenu for location
  String dropdownLocationValue = "Bhaktapur";
  // String? _location;
  // final List<String> _location = [
  //   'Bhaktapur',
  //   'Kathmandu',
  //   'Lalitpur',
  //   'Kritipur'
  // ];

  //location silder
  double _currentSliderValue = 20;

  //property Type
  String dropdownPropertyValue = "Apartment";

  //price range
  RangeValues _currentRangeValues = const RangeValues(0, 100000);

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
    dropdownLocationValue = "Bhaktapur";
    _currentRangeValues = const RangeValues(5000.0, 50000.0);
    dropdownPropertyValue = "Apartment";
  }

  Future<void> loadPreferences() async {
    setState(() {
      _isLoading = false;
    });
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      PreferenceServices preferenceServices = PreferenceServices();
      if (currentUser != null) {
        Preferences? preferences = await preferenceServices.getPreferences();
        if (preferences != null) {
          setState(() {
            dropdownLocationValue = preferences.location ?? "Bhaktapur";

            _currentRangeValues = RangeValues(
                (preferences.priceRange!['min'] as num).toDouble(),
                (preferences.priceRange!['max'] as num).toDouble());

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preference Screen'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Location Preference', style: TextStyle(fontSize: 18)),
          DropdownButton(
            hint: const Text('Select an option'),
            items: const [
              DropdownMenuItem(child: Text("Bhaktapur"), value: "Bhaktapur"),
              DropdownMenuItem(child: Text("Kathmandu"), value: "Kathmandu"),
              DropdownMenuItem(child: Text("Lalitpur"), value: "Lalitpur"),
              DropdownMenuItem(child: Text("Kritipur"), value: "Kritipur"),
            ],
            onChanged: (String? newValue) {
              setState(() {
                dropdownLocationValue = newValue!;
              });
            },
            value: dropdownLocationValue,
          ),
          Slider(
            value: _currentSliderValue,
            min: 0,
            max: 100,
            divisions: 10,
            label: _currentSliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),
          const SizedBox(height: 20),
          const Center(
              child: Text('Price Range', style: TextStyle(fontSize: 18))),
          RangeSlider(
            values: _currentRangeValues,
            min: 0,
            max: 100000,
            divisions: 20,
            labels: RangeLabels(
              _currentRangeValues.start.round().toString(),
              _currentRangeValues.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
            },
          ),
          Text(
            'Selected Range: ${_currentRangeValues.start.round()} - ${_currentRangeValues.end.round()}',
            style: const TextStyle(fontSize: 18),
          ),
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
        location: dropdownLocationValue,
        distance: _currentSliderValue,
        priceRange: {
          'min': _currentRangeValues.start.round(),
          'max': _currentRangeValues.end.round(),
        },
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
