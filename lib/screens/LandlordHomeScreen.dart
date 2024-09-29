import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/model/Rooms.dart';
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

  //controller
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  String roomTitle = '';
  String? postedBy = '';
  String location = '';
  double price = 0;
  String description = '';

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

  final _formKey = GlobalKey<FormState>();
  void addRooms() async {
    List<String?> uploadedUrls = [];
    // Collect selected amenities
    List<String> selectedAmenities = [];
    for (int i = 0; i < _amenitiesOptions.length; i++) {
      if (_isSelected[i]) {
        selectedAmenities.add(_amenitiesOptions[i]);
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
      location: locationController.text,
      price: priceController.text,
      description: descriptionController.text,
      amenities: selectedAmenities, // Add amenities to room object

      images: uploadedUrls,
    );

    await Roomservices()
        .createRoom(room)
        .then((value) => {
              Esnackbar.show(context, "Room added successfully"),
            })
        .catchError((error) {
      Esnackbar.show(context, "Failed to add room");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Room Rent'),
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
                decoration: const InputDecoration(labelText: 'Room Title'),
                onChanged: (value) {
                  roomTitle = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a room title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                onChanged: (value) {
                  location = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
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
                decoration: const InputDecoration(labelText: 'Description'),
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
              const SizedBox(height: 20),

              // Nearby amenities
              Text('Nearby Amenities', style: TextStyle(fontSize: 18)),
              Wrap(
                spacing: 8.0, // Spacing between chips
                children: List<Widget>.generate(_amenitiesOptions.length,
                    (int index) {
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
                  onPressed: () {
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
