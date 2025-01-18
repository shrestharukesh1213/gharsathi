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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/icons/logo.png',
              height: 200,
              width: 200,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: TextFormField(
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
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: TextFormField(
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: 200,
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
                  const SizedBox(height: 250),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/resetpass');
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
