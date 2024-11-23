import 'package:shared_preferences/shared_preferences.dart';
import 'package:gharsathi/model/Users.dart';

class SharedPref {
  // Function to set user data
  Future<void> setUserData(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', data['firstName']);
    prefs.setString('lastName', data['lastName']);
    prefs.setString('email', data['email']);
    prefs.setString('phoneNumber', data['phoneNumber']);
    prefs.setString('profileImage', data['profileImage']);
  }

  // Function to update user data
  Future<void> updateUserData(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> userMap = data is Users ? data.toJson() : data;

    if (userMap.containsKey('firstName')) {
      prefs.setString('firstName', userMap['firstName']);
    }
    if (userMap.containsKey('lastName')) {
      prefs.setString('lastName', userMap['lastName']);
    }
    if (userMap.containsKey('phoneNumber')) {
      prefs.setString('phoneNumber', userMap['phoneNumber']);
    }
    if (userMap.containsKey('profileImage')) {
      prefs.setString('profileImage', userMap['profileImage']);
    }
  }

  // Function to get user data
  Future<Map<String, String?>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'firstName': prefs.getString('firstName'),
      'lastName': prefs.getString('lastName'),
      'email': prefs.getString('email'),
      'phoneNumber': prefs.getString('phoneNumber'),
      'profileImage': prefs.getString('profileImage'),
    };
  }
}
