import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gharsathi/services/authentication.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final _emailAndPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailAndPhoneController,
                validator: (value) {
                  if (!EmailValidator.validate(value!)) {
                    return "Invalid Email";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password field should not be empty";
                  } else if (value.length <= 6) {
                    return "Password should be longer than 6 letters";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Enter your password',
                  hintText: 'Enter your password  ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60, // Full width of the screen
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Authentication().signIn(
                            email: _emailAndPhoneController.text,
                            password: _passwordController.text,
                            context: context);
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18),
                    )),
              ),
              const SizedBox(height: 20),
              const Text(
                "Dont have an account?",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(fontSize: 18),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
