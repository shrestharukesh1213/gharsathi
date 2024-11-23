import 'dart:io';
import 'package:gharsathi/global_variables.dart';
import 'package:gharsathi/services/SharedPref.dart';
import 'package:gharsathi/model/Users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/services/authentication.dart';
import 'package:gharsathi/widgets/Esnackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;

  // Function to open media (camera/gallery)
  void openMedia() async {
    final action = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop('camera');
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop('gallery');
            },
            child: const Text('Gallery'),
          ),
        ],
      ),
    );

    if (action == 'camera') {
      final permissionStatus = await Permission.camera.request();
      if (permissionStatus.isPermanentlyDenied) {
        openAppSettings();
      }

      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      }
    } else if (action == 'gallery') {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      }
    }
  }

  // controllers for text fields
  final TextEditingController _firstNameController =
      TextEditingController(text: firstName);
  final TextEditingController _lastNameController =
      TextEditingController(text: lastName);
  final TextEditingController _phoneNumberController = TextEditingController();

  // update profile function
  Future<void> _updateFunction() async {
    print("First Name: ${_firstNameController.text}");
    print(lastName);
    print(profileImage);
    print(phoneNumber);

    String? uploadedImage;

    // Check if the user has selected a new image
    if (_image != null) {
      uploadedImage = await Authentication().uploadProfile(_image!);
    }

    String userID = FirebaseAuth.instance.currentUser!.uid;
    final updatedUserData = Users(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: _phoneNumberController.text,
      profileImage: uploadedImage ?? profileImage ?? "https://via.placeholder.com/150",
    );

    try {
      // Update user profile in Firebase and local storage
      await Authentication()
          .updateUser(userID, updatedUserData)
          .then((value) async {
            // Fetch the user's usertype (role) from Firestore
            DocumentSnapshot userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(userID)
                .get();

            String userType = userDoc['usertype'];

            // Navigate based on usertype
            if (userType == 'tenant') {
              Navigator.pushReplacementNamed(context, '/tenantnavbar');
            } else if (userType == 'Landlord') {
              Navigator.pushReplacementNamed(context, '/landlordnavbar');
            }

            SharedPref().updateUserData(updatedUserData);
            SharedPref().getUserData();
            Esnackbar.show(context, "Profile updated");
          })
          .catchError((error) => {
                Esnackbar.show(context, "Firebase profile update error"),
              });
    } catch (e) {
      Esnackbar.show(context, "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile picture with camera button
            Stack(
              children: [
                _image == null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profileImage == null
                            ? 'https://via.placeholder.com/150'
                            : profileImage!))
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                      ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: openMedia,  // Open media picker (camera/gallery)
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            // First name input field
            const Text(
              "First Name",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                hintText: "Enter your first name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),
            // Last name input field
            const Text(
              "Last Name",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                hintText: "Enter your last name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),
            // Phone number input field
            const Text(
              "Phone Number",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                hintText: "Enter your phone number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),
            // Update button
            ElevatedButton(
              onPressed: _updateFunction,
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
