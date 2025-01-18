import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/model/Rooms.dart';
import 'package:gharsathi/screens/landlordLocationSelectScreen.dart';
import 'package:gharsathi/services/RoomServices.dart';
import 'package:gharsathi/widgets/Esnackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Landlordhomescreen extends StatefulWidget {
  const Landlordhomescreen({super.key});

  @override
  State<Landlordhomescreen> createState() => _LandlordhomescreenState();
}

class _LandlordhomescreenState extends State<Landlordhomescreen> {
  // camera and gallery function
  final List<String> _selectedImages = [];

  void openMedia(ImageSource source) async {
    final permissionStatus = await Permission.camera.request();
    if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }

    final image = await ImagePicker().pickImage(source: source);

    if (image != null) {
      setState(() {
        _selectedImages.add(image.path);
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    super.dispose();
  }

  //controller
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  String roomTitle = '';
  String? postedBy = '';
  String address = 'Not Set';
  late double latitude;
  late double longitude;
  double price = 0;
  String description = '';
  String propertyType = 'Apartment';

  String currentDate() {
    DateTime now = DateTime.now();
    return "${now.year.toString().padLeft(4, '0')}-"
        "${(now.month).toString().padLeft(2, '0')}-"
        "${now.day.toString().padLeft(2, '0')}";
  }

  // List of amenities with their respective icons
  final List<Map<String, dynamic>> _amenitiesOptions = [
    {'label': 'Gym', 'icon': Icons.fitness_center},
    {'label': 'School', 'icon': Icons.school},
    {'label': 'Hospital', 'icon': Icons.local_hospital},
    {'label': 'Swimming Pool', 'icon': Icons.pool},
    {'label': 'Supermarkets', 'icon': Icons.shopping_cart},
    {'label': 'Restaurants', 'icon': Icons.restaurant},
    {'label': 'Healthcare', 'icon': Icons.health_and_safety},
    {'label': 'Parks', 'icon': Icons.park},
    {'label': 'Banks', 'icon': Icons.account_balance},
    {'label': 'Coffee Shops', 'icon': Icons.coffee},
  ];

  final List<bool> _isSelected = List.generate(10, (_) => false);

  final _formKey = GlobalKey<FormState>();
  void addRooms() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    List<String?> uploadedUrls = [];
    // Collect selected amenities
    List<String> selectedAmenities = [];
    for (int i = 0; i < _amenitiesOptions.length; i++) {
      if (_isSelected[i]) {
        selectedAmenities.add(_amenitiesOptions[i]['label']);
      }
    }

    // for loop for uploading each images in array
    for (final eachImage in _selectedImages) {
      final url = await Roomservices().uploadImage(File(eachImage));
      if (url != null) {
        uploadedUrls.add(url);
      }
    }
    final room = Rooms(
        roomTitle: titleController.text,
        postedBy: user!.displayName,
        posterUid: currentUser!.uid,
        postedByEmail: currentUser.email,
        location: {
          'address': address,
          'latitude': latitude,
          'longitude': longitude
        },
        price: double.parse(priceController.text),
        description: descriptionController.text,
        amenities: selectedAmenities, // Add amenities to room object
        images: uploadedUrls,
        isBooked: 0,
        propertyType: propertyType,
        postDate: currentDate());

    await Roomservices()
        .createRoom(room)
        .then((value) => {
              Esnackbar.show(context, "Room added successfully"),
              setState(() {
                titleController.clear();
                priceController.text = '0.0';
                address = "Not Set";
                descriptionController.clear();
                _selectedImages.clear();
                _isSelected.fillRange(0, _isSelected.length, false);
                selectedAmenities.clear();
              })
            })
        .catchError((error) {
      return Esnackbar.show(context, "Failed to add room");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Property for Rent'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: titleController,
                decoration:
                    const InputDecoration(labelText: 'Property Title *'),
                onChanged: (value) {
                  roomTitle = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a property title';
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price *'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  price = double.parse(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description *'),
                maxLines: 5,
                onChanged: (value) {
                  description = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 4.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Set Location on Map",
                      style: TextStyle(fontSize: 18),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: OutlinedButton(
                        child: Icon(
                          Icons.add_location,
                        ),
                        onPressed: () async {
                          final Map<String, dynamic>? result =
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LandlordLocationSelectScreen()));
                          if (result != null) {
                            setState(() {
                              address = result['address'];
                              latitude = result['latitude'];
                              longitude = result['longitude'];
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              Text("Location: $address "),
              const SizedBox(height: 20),

              const Text('Select Property Type',
                  style: TextStyle(fontSize: 18)),

              DropdownButton(
                hint: const Text('Select an option'),
                items: const [
                  DropdownMenuItem(
                      value: "Apartment", child: Text("Apartment")),
                  DropdownMenuItem(value: "House", child: Text("House")),
                  DropdownMenuItem(value: "Room", child: Text("Room")),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    propertyType = newValue!;
                  });
                },
                value: propertyType,
              ),

              const SizedBox(height: 20),

              // Nearby amenities
              const Text('Nearby Amenities', style: TextStyle(fontSize: 18)),
              Wrap(
                spacing: 8.0, // Spacing between chips
                children: List<Widget>.generate(_amenitiesOptions.length,
                    (int index) {
                  return FilterChip(
                    showCheckmark: false,
                    avatar: Icon(_amenitiesOptions[index]['icon'], size: 20),
                    label: Text(_amenitiesOptions[index]['label']),
                    selected: _isSelected[index],
                    onSelected: (bool selected) {
                      setState(() {
                        _isSelected[index] = selected;
                      });
                    },
                  );
                }),
              ),
              // add image widget
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add product image",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            openMedia(ImageSource.camera);
                          },
                          icon: const Icon(Icons.camera_alt)),
                      IconButton(
                          onPressed: () {
                            openMedia(ImageSource.gallery);
                          },
                          icon: const Icon(Icons.photo)),
                    ],
                  ),
                ],
              ),

              _selectedImages.isNotEmpty
                  ? SizedBox(
                      height: 100,
                      child: ListView.builder(
                          itemCount: _selectedImages.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final image = _selectedImages[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(File(image)))),
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                          color: Colors.white,
                                          onPressed: () {
                                            setState(() {
                                              _selectedImages.removeAt(index);
                                            });
                                          },
                                          icon: const Icon(Icons.close)))
                                ],
                              ),
                            );
                          }),
                    )
                  : Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Center(
                          child: Text(
                        "No image selected",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                    ),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      addRooms();
                    }
                  },
                  child: const Text("Post for Rent")),
            ],
          ),
        ),
      ),
    );
  }
}
