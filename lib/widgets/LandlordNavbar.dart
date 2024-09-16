import 'package:flutter/material.dart';
import 'package:gharsathi/screens/LandlordChatScreen.dart';
import 'package:gharsathi/screens/LandlordHomeScreen.dart';
import 'package:gharsathi/screens/LandlordProfileScreen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Landlordnavbar extends StatefulWidget {
  const Landlordnavbar({super.key});

  @override
  State<Landlordnavbar> createState() => _LandlordnavbarState();
}

class _LandlordnavbarState extends State<Landlordnavbar> {
  int _selectedIndex = 0;
  final _screen = [
    Landlordhomescreen(),
    Landlordchatscreen(),
    Landlordprofilescreen(),
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

          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(Icons.chat),
            title: const Text("Chat"),
            selectedColor: Colors.pink,
          ),

          ///Chat
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
