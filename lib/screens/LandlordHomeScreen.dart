import 'dart:io';

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

  String roomTitle = '';
  String location = '';
  double price = 0;
  String description = '';

  final _formKey = GlobalKey<FormState>();
  void addRooms() async {
    List<String?> uploadedUrls = [];
    // for loop for uploading each images in array
    for (final eachImage in _selectedImages) {
      final url = await Roomservices().uploadImage(File(eachImage));
      if (url != null) {
        uploadedUrls.add(url);
      }
    }
    final room = Rooms(
      roomTitle: titleController.text,
      location: locationController.text,
      price: priceController.text,
      description: descriptionController.text,
      images: uploadedUrls,
    );

    await Roomservices()
        .createRoom(room)
        .then((value) => {Esnackbar.show(context, "Room added successfully")})
        .catchError((error) {
      Esnackbar.show(context, "Failed to add room");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post a Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Room Title'),
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
                decoration: InputDecoration(labelText: 'Location'),
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
                decoration: InputDecoration(labelText: 'Price'),
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
                decoration: InputDecoration(labelText: 'Description'),
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
                          icon: Icon(Icons.camera_alt)),
                      IconButton(
                          onPressed: () {
                            openMedia(ImageSource.gallery);
                          },
                          icon: Icon(Icons.photo)),
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
                      child: Center(
                          child: Text(
                        "No image selected",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                    ),
              SizedBox(height: 20),
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
