import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gharsathi/model/Users.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection("users").snapshots();

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String userType,
    required String phoneNumber,
    required BuildContext context,
  }) async {
    try {
      // Create User Account
      UserCredential signUp = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update User Display Name
      User? user = signUp.user;
      if (user != null) {
        await user.updateDisplayName("$firstName $lastName");
        await user.reload();
      }

      String userId = signUp.user!.uid;

      // Store User data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'usertype': userType,
        'phoneNumber': phoneNumber,
        'uid': userId,
        'profileImage': 'https://via.placeholder.com/150',
      });

      return true; // Registration was successful
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email is already in use';
      } else {
        message = 'Registration failed: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return false; // Registration failed
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return false;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential signIn = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String uidForSignIn = signIn.user!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uidForSignIn)
          .get();

      if (userDoc.exists) {
        String userTypeForSignIn = userDoc['usertype'];

        if (userTypeForSignIn == 'Tenant') {
          Navigator.pushNamed(context, '/tenantnavbar');
        } else if (userTypeForSignIn == 'Landlord') {
          Navigator.pushNamed(context, '/landlordnavbar');
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }
  Future<String?> uploadProfile(File imageFile) async {
    try {
      // path to storage
      final path = 'profile/${DateTime.now()}.png';
      final file = File(imageFile.path);
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  } 
  Future<void> updateUser(String userId, Users user) async {
  try {
    if (user.profileImage != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
            'profileImage': user.profileImage,  
            'firstName': user.firstName,
            'lastName': user.lastName,
            'phoneNumber': user.phoneNumber,
          });
    } else {
      // If no image is provided, just update the rest of the fields
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(user.toJson());
    }
  } catch (e) {
    print("Error updating user: $e");
    rethrow;
  }
}
}
