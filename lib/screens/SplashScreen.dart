import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _checkUserSession(); // Check user session when splash screen loads
  }

  // Method to check user session and decide where to navigate
  Future<void> _checkUserSession() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        // User is logged in, fetch their role from Firestore
        String uid = currentUser.uid;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .get();

        if (userDoc.exists) {
          // Get the user role
          String userType = userDoc['usertype'];

          // Delay the navigation to avoid Navigator issues
          Future.delayed(Duration.zero, () {
            // Navigate to the appropriate screen based on user role
            if (userType == 'Tenant') {
              Navigator.pushReplacementNamed(context, '/tenanthome');
            } else if (userType == 'Landlord') {
              Navigator.pushReplacementNamed(context, '/landlordhome');
            } else {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            }
          });
        } else {
          // If user document doesn't exist, log out and navigate to login screen
          FirebaseAuth.instance.signOut();
          Future.delayed(Duration.zero, () {
            Navigator.pushReplacementNamed(context, '/login');
          });
        }
      } catch (e) {
        // Handle any error (e.g., network issues or Firestore errors)
        print('Error checking user session: $e');
        FirebaseAuth.instance.signOut();
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(context, '/login');
        });
      }
    } else {
      // User is not logged in, navigate to login screen
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/logo.png',
            height: 300,
            width: 300,
          ),
          const Center(
            child: Text(
              'Welcome to GharSathi',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
