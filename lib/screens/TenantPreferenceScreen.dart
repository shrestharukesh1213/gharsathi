import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gharsathi/model/Preferences.dart';
import 'package:gharsathi/services/PreferenceServices.dart';

class TenantPreferenceScreen extends StatefulWidget {
  const TenantPreferenceScreen({super.key});

  @override
  State<TenantPreferenceScreen> createState() => _TenantPreferenceScreenState();
}

class _TenantPreferenceScreenState extends State<TenantPreferenceScreen> {
  // Dropdown menu for location
  String dropdownLocationValue = "Bhaktapur";
  double _currentSliderValue = 20; // Distance slider value
  String dropdownPropertyValue = "Apartment"; // Property type dropdown
  RangeValues _currentRangeValues = const RangeValues(0, 100000); // Price range

  // List of amenities and selection status
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
  final List<bool> _isSelected = List.generate(10, (_) => false);

  final PreferenceServices _preferenceServices = PreferenceServices();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Preferences? preferences =
          await _preferenceServices.getPreferences(currentUser.uid);

      if (preferences != null) {
        setState(() {
          dropdownLocationValue = preferences.location;
          _currentSliderValue = preferences.distance;

          // Safely parse min and max values from priceRange
          final minPrice = preferences.priceRange['min']?.toDouble() ?? 0.0;
          final maxPrice =
              preferences.priceRange['max']?.toDouble() ?? 100000.0;

          _currentRangeValues = RangeValues(minPrice, maxPrice);
          dropdownPropertyValue = preferences.propertyType;

          for (int i = 0; i < _amenitiesOptions.length; i++) {
            _isSelected[i] =
                preferences.amenities.contains(_amenitiesOptions[i]);
          }
        });
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
        children: [
          _buildDropdown('Location Preference', dropdownLocationValue,
              ['Bhaktapur', 'Kathmandu', 'Lalitpur', 'Kritipur'], (value) {
            setState(() {
              dropdownLocationValue = value!;
            });
          }),
          _buildSlider('Distance Preference (km)', _currentSliderValue,
              (value) {
            setState(() {
              _currentSliderValue = value;
            });
          }),
          _buildRangeSlider('Price Range', _currentRangeValues, (values) {
            setState(() {
              _currentRangeValues = values;
            });
          }),
          _buildDropdown('Property Type', dropdownPropertyValue,
              ['Apartment', 'House', 'Room'], (value) {
            setState(() {
              dropdownPropertyValue = value!;
            });
          }),
          _buildAmenitiesChips(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _savePreferencesToFirestore,
            child: const Text('Save Preferences'),
          ),
        ],
      ),
    );
  }

  // Helper methods to build UI components
  Widget _buildDropdown(String title, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 18)),
        DropdownButton<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSlider(
      String title, double value, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 18)),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 10,
          label: value.round().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildRangeSlider(
      String title, RangeValues values, ValueChanged<RangeValues> onChanged) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 18)),
        RangeSlider(
          values: values,
          min: 0,
          max: 100000,
          divisions: 20,
          labels: RangeLabels(
              values.start.round().toString(), values.end.round().toString()),
          onChanged: onChanged,
        ),
        Text(
          'Selected Range: ${values.start.round()} - ${values.end.round()}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildAmenitiesChips() {
    return Column(
      children: [
        Text('Nearby Amenities', style: const TextStyle(fontSize: 18)),
        Wrap(
          spacing: 8.0,
          children: List<Widget>.generate(_amenitiesOptions.length, (index) {
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
      ],
    );
  }

  Future<void> _savePreferencesToFirestore() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      List<String> selectedAmenities = _amenitiesOptions
          .asMap()
          .entries
          .where((entry) => _isSelected[entry.key])
          .map((entry) => entry.value)
          .toList();

      Preferences preferences = Preferences(
        user: currentUser.displayName ?? '',
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

      try {
        await _preferenceServices.savePreferences(preferences);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preferences saved successfully!')),
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
