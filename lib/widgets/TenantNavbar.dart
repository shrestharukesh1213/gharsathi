import 'package:flutter/material.dart';
import 'package:gharsathi/screens/TenantChatScreen.dart';
import 'package:gharsathi/screens/TenantHomeScreen.dart';
import 'package:gharsathi/screens/TenantProfileScreen.dart';
import 'package:gharsathi/screens/TenantSavedScreen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Tenantnavbar extends StatefulWidget {
  const Tenantnavbar({super.key});

  @override
  State<Tenantnavbar> createState() => _TenantnavbarState();
}

class _TenantnavbarState extends State<Tenantnavbar> {
  int _selectedIndex = 0;
  final _screen = [
    Tenanthomescreen(),
    Tenantsavedscreen(),
    Tenantchatscreen(),
    Tenantprofilescreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screen.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.purple,
          ),

          /// Saved
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite_border_outlined),
            title: const Text("Saved"),
            selectedColor: Colors.orange,
          ),

          ///Chat
          SalomonBottomBarItem(
            icon: const Icon(Icons.chat),
            title: const Text("Profile"),
            selectedColor: Colors.teal,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Chat"),
            selectedColor: Colors.pink,
          ),
        ],
      ),
    );
  }
}
