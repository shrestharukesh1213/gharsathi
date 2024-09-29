import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool _isCheckingSession = true; // Variable to track session checking status
  bool _isLoggedIn = false;       // Variable to track login status

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

          // Navigate to the appropriate screen based on user role
          Future.delayed(Duration.zero, () {
            if (userType == 'Tenant') {
              Navigator.pushReplacementNamed(context, '/tenantnavbar');
            } else if (userType == 'Landlord') {
              Navigator.pushReplacementNamed(context, '/landlordnavbar');
            }
          });
        } else {
          FirebaseAuth.instance.signOut();
          setState(() {
            _isLoggedIn = false;
            _isCheckingSession = false;
          });
        }
      } catch (e) {
        print('Error checking user session: $e');
        FirebaseAuth.instance.signOut();
        setState(() {
          _isLoggedIn = false;
          _isCheckingSession = false;
        });
      }
    } else {
      // User is not logged in
      setState(() {
        _isLoggedIn = false;
        _isCheckingSession = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingSession) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Show loading while checking session
        ),
      );
    }

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
          const SizedBox(height: 20),
          if (!_isLoggedIn)
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Get Started'),
            ),
        ],
      ),
    );
  }
}
