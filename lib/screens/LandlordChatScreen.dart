import 'package:flutter/material.dart';

class Landlordchatscreen extends StatefulWidget {
  const Landlordchatscreen({super.key});

  @override
  State<Landlordchatscreen> createState() => _LandlordchatscreenState();
}

class _LandlordchatscreenState extends State<Landlordchatscreen> {
  final chatController = TextEditingController();

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
