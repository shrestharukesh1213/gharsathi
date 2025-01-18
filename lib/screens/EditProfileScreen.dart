import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gharsathi/services/authentication.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  String? profileImageUrl;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Load existing user profile data
  Future<void> _loadUserProfile() async {
    try {
      String userID = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _firstNameController.text = userData['firstName'] ?? '';
          _lastNameController.text = userData['lastName'] ?? '';
          _phoneNumberController.text = userData['phoneNumber'] ?? '';
          profileImageUrl = userData['profileImage'] ??
              'https://via.placeholder.com/150'; // Default placeholder
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading user profile: $e");
      }
    }
  }

  // Open media picker (camera/gallery)
  void _openMedia() async {
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

  // Update user profile
  Future<void> _updateFunction() async {
    // Show progress indicator (optional)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      String? uploadedImage;

      // Check if a new image is selected
      if (_image != null) {
        uploadedImage = await Authentication().uploadProfile(_image!);
      }

      String userID = FirebaseAuth.instance.currentUser!.uid;

      // Prepare updated user data
      final updatedUserData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        'profileImage': uploadedImage ?? profileImageUrl,
      };

      // Update user profile in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .update(updatedUserData);

      // Update local state
      setState(() {
        profileImageUrl = uploadedImage ?? profileImageUrl;
      });

      // Show success message
      Navigator.pop(context); // Remove progress indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      Navigator.pop(context); // Remove progress indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile.')),
      );
      if (kDebugMode) {
        print('Update error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                _image == null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profileImageUrl ??
                            'https://via.placeholder.com/150'),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(_image!),
                      ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _openMedia,
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
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
