import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authentication {
  Future<void> signup(
      {required String firstname,
      required String lastname,
      required String username,
      required String email,
      required String password,
      required String userType,
      required BuildContext context}) async {
    try {
      //Create User Account
      UserCredential signup = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String userId = signup.user!.uid;

      //Store User data in firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'firstname': firstname,
        'lastname': lastname,
        'username': username,
        'email': email,
        'usertype':userType,
      });

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamed(context, '/navbar');
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

  Future<void> signin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      //Login to your account
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamed(context, '/navbar');
    } on FirebaseAuthException catch (e) {
      String message = e.code;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {}
  }
}
