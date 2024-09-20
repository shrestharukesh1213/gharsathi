import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/screens/OtpVerificationScreen.dart';
import 'package:gharsathi/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthProvider extends ChangeNotifier{
  bool _isSignedIn =false;
  bool get isSignedIn => _isSignedIn;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance ;

  AuthProvider(){
    checkSign();

  }

  void checkSign() async{
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("_isSignedin")?? false;
    notifyListeners();

  }
  void signInwithPhone(BuildContext context, String phoneNumber) async {
    try{
      await _firebaseAuth.verifyPhoneNumber(
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential)async {
        await _firebaseAuth.signInWithCredential(phoneAuthCredential);
      }, 
      verificationFailed: (error){
        throw Exception(error.message);
      }, 
      codeSent: ((verficationId, forceResendingToken){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Otpverificationscreen(verificationId: verficationId),));
      }), 
      codeAutoRetrievalTimeout: (verficationId){});
    } on FirebaseAuthException catch(e){
      showSnackBar(context,e.message.toString());
    }
  }

}