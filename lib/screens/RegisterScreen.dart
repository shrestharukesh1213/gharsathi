import 'package:flutter/material.dart';
import 'package:gharsathi/services/authentication.dart';
import 'package:email_validator/email_validator.dart';

enum UserTypeEnum { Tenant, Landlord }

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
<<<<<<< HEAD
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
=======
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _userNameController = TextEditingController();
>>>>>>> origin/main
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserTypeEnum? _userTypeEnum; // To track selected user type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter a Firstname";
                    } else if (value.length <= 3) {
                      return "First name must be longer than 3 letters";
                    } else if (value.contains(RegExp(r'[0-9]'))) {
                      return "First name should not contain numbers";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter your First Name',
                    hintText: 'Enter your First Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter a Lastname";
                    } else if (value.length <= 3) {
                      return "Last name must be longer than 3 letters";
                    } else if (value.contains(RegExp(r'[0-9]'))) {
                      return "Last name should not contain numbers";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter your Last Name',
                    hintText: 'Enter your Last Name',
                    border: OutlineInputBorder(),
                  ),
                ),
<<<<<<< HEAD
                
=======
                const SizedBox(height: 20),
                TextFormField(
                  controller: _userNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter a userName";
                    } else if (value.length <= 5) {
                      return "Username must be longer than 5 letters";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter your User Name',
                    hintText: 'Enter your User Name',
                    border: OutlineInputBorder(),
                  ),
                ),
>>>>>>> origin/main
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || !EmailValidator.validate(value)) {
                      return "Invalid Email";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter your email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter phone number";
                    } else if (value.contains(RegExp(r'[a-zA-Z]'))) {
                      return "Should not contain alphabets";
                    } else if (value.length != 10) {
                      return "Phone number should be 10 digits";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter your Phone Number',
                    hintText: 'Enter your Phone Number',
                    border: OutlineInputBorder(),
                    
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password field should not be empty";
                    } else if (value.length <= 6) {
                      return "Password should be longer than 6 letters";
                    } else if (!RegExp(r'[A-Z]').hasMatch(value)){
                      return "Password must contain at least one uppercase letter";
                    } else if (!RegExp(r'[0-9]').hasMatch(value)){
                      return "Password must contain at least one number";
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Enter your password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // User Type Radio Buttons (Buyer or Seller) in a Row
                const Text(
                  'Select Account Type:',
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<UserTypeEnum>(
                        contentPadding: EdgeInsets.all(0.0),
                        value: UserTypeEnum.Tenant,
                        groupValue: _userTypeEnum,
                        tileColor: Colors.deepPurple.shade50,
                        title: Text(UserTypeEnum.Tenant.name),
                        onChanged: (UserTypeEnum? value) {
                          setState(() {
                            _userTypeEnum = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: RadioListTile<UserTypeEnum>(
                        contentPadding: EdgeInsets.all(0.0),
                        value: UserTypeEnum.Landlord,
                        groupValue: _userTypeEnum,
                        tileColor: Colors.deepPurple.shade50,
                        title: Text(UserTypeEnum.Landlord.name),
                        onChanged: (UserTypeEnum? value) {
                          setState(() {
                            _userTypeEnum = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
<<<<<<< HEAD
                 ElevatedButton(  onPressed: () async {
      if (_userTypeEnum == null) {
      // Show a SnackBar when user type is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select account type'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (_formKey.currentState!.validate()) {
      // Proceed with the signup if all fields and user type are valid
      Authentication().signup(
        firstname: _firstnameController.text,
        lastname: _lastnameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        phoneNumber: _phoneController.text,
        userType: _userTypeEnum.toString().split('.').last, // Passing user type
        context: context,
      );
    }
  },
  child: const Text('Register'),
)

=======
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_userTypeEnum == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select account type'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        // Pass user's data for Authentication
                        Authentication().signUp(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          userName: _userNameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                          phoneNumber: _phoneController.text,
                          context: context,
                          userType: _userTypeEnum
                              .toString()
                              .split('.')
                              .last, // Passing user type
                        );
                      }
                    }
                  },
                  child: const Text('Register'),
                ),
>>>>>>> origin/main
              ],
            ),
          ),
        ),
      ),
    );
  }
}
