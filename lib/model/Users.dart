class Users {
  String? firstName;
  String? lastName;
  String? email;
  String? userType;
  String? phoneNumber;
  String? profileImage;
  String? uid;

  Users({
    this.firstName,
    this.lastName,
    this.email,
    this.userType,
    this.phoneNumber,
    this.profileImage,
    this.uid,
  });

  Users fromJson(Map<String, dynamic> json) {
    return Users(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      userType: json['usertype'],
      phoneNumber: json['phoneNumber'] ?? "",
      profileImage: json['profileImage'] ?? "https://via.placeholder.com/150",
      uid: json['uid'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'usertype': userType,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'uid': uid, 
    };
  }
}
