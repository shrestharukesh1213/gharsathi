import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gharsathi/services/authentication.dart';

class Tenantprofilescreen extends StatefulWidget {
  const Tenantprofilescreen({super.key});

  @override
  State<Tenantprofilescreen> createState() => _TenantprofilescreenState();
}

class _TenantprofilescreenState extends State<Tenantprofilescreen> {
  final Authentication _authService = Authentication();
  String? firstName;
  String? lastName;
  String? email;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      User? currentUser = _authService.getCurrentUser();
      if (currentUser != null) {
        // Fetch user details from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            firstName = userDoc['firstName'];
            lastName = userDoc['lastName'];
            email = userDoc['email'];
            profileImageUrl = userDoc['profileImage'] ??
                'https://via.placeholder.com/150'; // Default image if not found
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: $e')),
      );
    }
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sign out"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                _authService.signOut(context);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenant Profile'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: firstName == null || email == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : const NetworkImage('https://via.placeholder.com/150'),
                  onBackgroundImageError: (exception, stackTrace) {
                    setState(() {
                      profileImageUrl =
                          'https://via.placeholder.com/150'; // Fallback image on error
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  "$firstName $lastName",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(email!),
                const SizedBox(height: 10),
                const Divider(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/editprofile');
                        },
                        leading: const Icon(Icons.person),
                        title: const Text("My Profile"),
                        subtitle: const Text("Edit your profile"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/tenantpreference');
                        },
                        leading: const Icon(Icons.menu_open_outlined),
                        title: const Text("Edit Preferences"),
                        subtitle: const Text("Change your preferences"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/changepass');
                        },
                        leading: const Icon(Icons.security),
                        title: const Text("Change Password"),
                        subtitle: const Text("Create a new password"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/tenantLocationSelect');
                        },
                        leading: const Icon(Icons.location_on),
                        title: const Text("My Location"),
                        subtitle: const Text("Set your Location"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/tenantsaved');
                        },
                        leading: const Icon(Icons.favorite),
                        title: const Text("Favourites"),
                        subtitle: const Text("View your saved rooms"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _signOut,
                  child: const Text("Logout"),
                ),
              ],
            ),
    );
  }
}
