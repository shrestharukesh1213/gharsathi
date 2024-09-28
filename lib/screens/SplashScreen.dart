import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  // Check if a user is already logged in
  void _checkAuthState() async {
    await Future.delayed(const Duration(seconds: 2)); // Add some delay for splash screen
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, navigate to the relevant home screen
      Navigator.pushReplacementNamed(context, '/tenantnavbar'); // or '/landlordnavbar' if user is a landlord
    } else {
      // User is not logged in, navigate to login screen
      Navigator.pushReplacementNamed(context, '/login');
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
