import 'package:flutter/material.dart';

class Tenantpreferencescreen extends StatefulWidget {
  const Tenantpreferencescreen({super.key});

  @override
  State<Tenantpreferencescreen> createState() => _TenantpreferencescreenState();
}

class _TenantpreferencescreenState extends State<Tenantpreferencescreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preference Screen'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Location Preference', style: TextStyle(fontSize: 18)),
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
          Text('Price Range', style: TextStyle(fontSize: 18)),
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
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          Text('Property Type', style: TextStyle(fontSize: 18)),
          DropdownButton(
            hint: const Text('Select an option'),
            items: const [
              DropdownMenuItem(child: Text('Apartment'), value: 'Apartment'),
              DropdownMenuItem(child: Text('House'), value: 'House'),
              DropdownMenuItem(child: Text('Condo'), value: 'Condo'),
            ],
            onChanged: (String? newValue) {
              setState(() {
                dropdownPropertyValue = newValue!;
              });
            },
            value: dropdownPropertyValue,
          ),
          const SizedBox(height: 20),
          Text('Nearby Amenities', style: TextStyle(fontSize: 18)),
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
        ],
      ),
    );
  }
}
