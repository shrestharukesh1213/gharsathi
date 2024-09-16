import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authentication {
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

      String userId = signUp.user!.uid;

      //Store User data in firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'usertype': userType,
        'phoneNumber': phoneNumber,
      });

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamed(context, '/tenantnavbar');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'Password is weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email already in use';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {}
  }

  Future<void> signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      //Login to your account
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamed(context, '/tenantnavbar');
    } on FirebaseAuthException catch (e) {
      String message = e.code;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {}
  }
}
