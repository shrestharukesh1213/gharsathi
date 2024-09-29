import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/services/authentication.dart';

class Landlordprofilescreen extends StatefulWidget {
  const Landlordprofilescreen({super.key});

  @override
  State<Landlordprofilescreen> createState() => _LandlordprofilescreenState();
}

class _LandlordprofilescreenState extends State<Landlordprofilescreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final name = user!.displayName;
    final email = user.email;
    // final phoneNumber = user.phoneNumber;
    // final uid = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
         
              Text(
                "Name: $name",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "Email: $email",
                style: TextStyle(fontSize: 20),
              ),
               const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Authentication().signOut(context);
            },
            child: const Text('Logout'),
          ),
            ],
          ),
        ),
      ),
    );
  }
}
