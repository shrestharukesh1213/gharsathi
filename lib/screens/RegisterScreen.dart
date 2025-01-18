import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/global_variables.dart';
import 'package:gharsathi/services/authentication.dart';
import 'package:email_validator/email_validator.dart';

enum UserTypeEnum { Tenant, Landlord }

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Country selectedCountry = Country(
      phoneCode: "977",
      countryCode: "NP",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Nepal",
      example: "Nepal",
      displayName: "Nepal",
      displayNameNoCountryCode: "NP",
      e164Key: "");

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
                Image.asset(
                  'assets/icons/logo.png',
                  height: 200,
                  width: 200,
                ),
                TextFormField(
                  controller: _firstnameController,
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
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _lastnameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter a Lastname";
                    } else if (value.length <= 2) {
                      return "Last name must be longer than 2 letters";
                    } else if (value.contains(RegExp(r'[0-9]'))) {
                      return "Last name should not contain numbers";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter your Last Name',
                    hintText: 'Enter your Last Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  ),
                ),

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
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                    } else if (!value.startsWith('98') &&
                        !value.startsWith('97')) {
                      return "Phone number should start with 98 or 97";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Phone Number',
                    hintText: 'Enter Phone Number',
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          showCountryPicker(
                              context: context,
                              countryListTheme: const CountryListThemeData(
                                  bottomSheetHeight: 550),
                              onSelect: (value) {
                                setState(() {
                                  selectedCountry = value;
                                });
                              });
                        },
                        child: Text(
                            "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
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
                    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return "Password must contain at least one uppercase letter";
                    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return "Password must contain at least one number";
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Enter your password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  ),
                ),
                const SizedBox(height: 20),
                // User Type Radio Buttons (Tenant or Landlord) in a Row
                const Text(
                  'Select Account Type:',
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<UserTypeEnum>(
                        contentPadding: const EdgeInsets.all(1.0),
                        value: UserTypeEnum.Tenant,
                        groupValue: _userTypeEnum,
                        title: Text(UserTypeEnum.Tenant.name),
                        onChanged: (UserTypeEnum? value) {
                          setState(() {
                            _userTypeEnum = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<UserTypeEnum>(
                        contentPadding: const EdgeInsets.all(1.0),
                        value: UserTypeEnum.Landlord,
                        groupValue: _userTypeEnum,
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
                ElevatedButton(
                  onPressed: () async {
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
                      Authentication().signUp(
                        firstName: _firstnameController.text,
                        lastName: _lastnameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        phoneNumber: _phoneController.text,
                        userType: _userTypeEnum
                            .toString()
                            .split('.')
                            .last, // Passing user type
                        context: context,
                      );
                    }
                  },
                  child: const Text('Register'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
