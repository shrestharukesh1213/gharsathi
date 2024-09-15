import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/firebase_options.dart';
import 'package:gharsathi/screens/AddScreen.dart';
import 'package:gharsathi/screens/ChatScreen.dart';
import 'package:gharsathi/screens/HomeScreen.dart';
import 'package:gharsathi/screens/LoginScreen.dart';
import 'package:gharsathi/screens/ProfileScreen.dart';
import 'package:gharsathi/screens/RegisterScreen.dart';
import 'package:gharsathi/screens/SavedScreen.dart';
import 'package:gharsathi/screens/SplashScreen.dart';
import 'package:gharsathi/screens/TenantScreen.dart';
import 'package:gharsathi/widgets/Navbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/register',
      routes: {
        '/': (context) => Splashscreen(),
        '/login': (context) => Loginscreen(),
        '/register': (context) => Registerscreen(),
        '/home': (context) => Homescreen(),
        '/add': (context) => Addscreen(),
        '/saved': (context) => Savedscreen(),
        '/chat': (context) => Chatscreen(),
        '/profile': (context) => Profilescreen(),
        '/navbar': (context) => Navbar(),
        '/tenant': (context) => Tenantscreen(),
      },
    );
  }
}
