import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gharsathi/screens/RegisterScreen.dart';

class Authentication {
  //instance of auth and firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection("users").snapshots();

  Future<void> signUp(
      {required String firstName,
      required String lastName,
      required String email,
      required String password,
      required String userType,
      required String phoneNumber,
      required BuildContext context}) async {
    try {
      //Create User Account
      UserCredential signUp = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      //Update User Display Name
      User? user = signUp.user;
      if (user != null) {
        await user.updateDisplayName("$firstName $lastName");
        await user.reload();
      }

      String userId = signUp.user!.uid;

      //Store User data in firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'usertype': userType,
        'phoneNumber': phoneNumber,
        'uid': userId,
      });

      //Sends to Tenant or Landlord screen depending on user type
      if (userType == UserTypeEnum.Tenant.name) {
        Navigator.pushNamed(context, '/tenantnavbar');
      } else if (userType == UserTypeEnum.Landlord.name) {
        Navigator.pushNamed(context, '/landlordnavbar');
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'Password is weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email already in use';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      //Login to your account
      UserCredential signIn = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String uidForSignIn = signIn.user!.uid;

      //Fetch user document from firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uidForSignIn)
          .get();

      //Checks if userdocument exists
      if (userDoc.exists) {
        //Retrieving usertype from firestore
        String userTypeForSignIn = userDoc['usertype'];

        if (userTypeForSignIn == UserTypeEnum.Tenant.name) {
          Navigator.pushNamed(context, '/tenantnavbar');
        } else if (userTypeForSignIn == UserTypeEnum.Landlord.name) {
          Navigator.pushNamed(context, '/landlordnavbar');
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = e.code;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {}
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Optionally navigate to the splash screen or login screen after logging out
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error signing out: $e')));
    }
  }
}
