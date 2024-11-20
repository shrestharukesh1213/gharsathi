import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
}
