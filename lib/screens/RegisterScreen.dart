import 'package:flutter/material.dart';
import 'package:gharsathi/services/authentication.dart';
import 'package:email_validator/email_validator.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _lastnameController,
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter a username";
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (!EmailValidator.validate(value!)) {
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
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password field should not be empty";
                    } else if (value.length <= 6) {
                      return "Password should be longer than 6 letters";
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Enter your password',
                    hintText: 'Enter your password  ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Authentication().signup(
                            firstname: _firstnameController.text,
                            lastname: _lastnameController.text,
                            username: _usernameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                            context: context);
                      }
                    },
                    child: const Text('Register')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
