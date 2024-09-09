import 'package:flutter/material.dart';
import 'package:gharsathi/screens/AddScreen.dart';
import 'package:gharsathi/screens/ChatScreen.dart';
import 'package:gharsathi/screens/HomeScreen.dart';
import 'package:gharsathi/screens/ProfileScreen.dart';
import 'package:gharsathi/screens/SavedScreen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;
  final _screen = [
    Homescreen(),
    Addscreen(),
    Savedscreen(),
    Chatscreen(),
    Profilescreen(),
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

          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.add),
            title: const Text("Home"),
            selectedColor: Colors.purple,
          ),

          /// Saved
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite_border_outlined),
            title: const Text("Saved"),
            selectedColor: Colors.orange,
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
