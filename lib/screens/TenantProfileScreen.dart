import 'package:flutter/material.dart';
import 'package:gharsathi/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Tenantprofilescreen extends StatefulWidget {
  const Tenantprofilescreen({super.key});

  @override
  State<Tenantprofilescreen> createState() => _TenantprofilescreenState();
}

class _TenantprofilescreenState extends State<Tenantprofilescreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final name = user!.displayName;
    final email = user.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenant Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(
                  'https://static1.srcdn.com/wordpress/wp-content/uploads/2021/12/One-Piece-Sales-Luffy.jpg',
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Name: $name",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Email: $email",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('User Preference'),
            subtitle: const Text('Change your preferences'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/tenantpreference');
            },
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
    );
  }
}
