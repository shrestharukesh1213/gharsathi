import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/firebase_options.dart';
import 'package:gharsathi/screens/ChangePasswordScreen.dart';
import 'package:gharsathi/screens/EditProfileScreen.dart';
import 'package:gharsathi/screens/LandlordChatScreen.dart';
import 'package:gharsathi/screens/LandlordHomeScreen.dart';
import 'package:gharsathi/screens/LandlordPostsScreen.dart';
import 'package:gharsathi/screens/LandlordProfileScreen.dart';
import 'package:gharsathi/screens/LandlordRoomDetails.dart';
import 'package:gharsathi/screens/LoginScreen.dart';
import 'package:gharsathi/screens/PasswordResetScreen.dart';
import 'package:gharsathi/screens/RegisterScreen.dart';
import 'package:gharsathi/screens/RoomDetails.dart';
import 'package:gharsathi/screens/SplashScreen.dart';
import 'package:gharsathi/screens/TenantChatScreen.dart';
import 'package:gharsathi/screens/TenantHomeScreen.dart';
import 'package:gharsathi/screens/TenantPreferenceScreen.dart';
import 'package:gharsathi/screens/TenantProfileScreen.dart';
import 'package:gharsathi/screens/TenantSavedScreen.dart';
import 'package:gharsathi/widgets/LandlordNavbar.dart';
import 'package:gharsathi/widgets/TenantNavbar.dart';
import 'package:gharsathi/provider/auth_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Splashscreen(),
          '/login': (context) => Loginscreen(),
          '/register': (context) => Registerscreen(),
          '/landlordnavbar': (context) => Landlordnavbar(),
          '/tenantnavbar': (context) => Tenantnavbar(),
          '/landlordhome': (context) => Landlordhomescreen(),
          '/landlordchat': (context) => Landlordchatscreen(),
          '/landlordprofile': (context) => Landlordprofilescreen(),
          '/tenanthome': (context) => Tenanthomescreen(),
          '/tenantsaved': (context) => TenantSavedScreen(),
          '/tenantchat': (context) => Tenantchatscreen(),
          '/tenantprofile': (context) => Tenantprofilescreen(),
          '/tenantpreference': (context) => Tenantpreferencescreen(),
          '/details': (context) => Roomdetails(),
          '/landlordposts': (context) => Landlordpostsscreen(),
          '/landlordroomdetails': (context) => Landlordroomdetails(),
          '/changepass': (context) => Changepasswordscreen(),
          '/editprofile': (context) => EditProfileScreen(),
          '/resetpass': (context) => PasswordResetScreen(),
        },
      ),
    );
  }
}
