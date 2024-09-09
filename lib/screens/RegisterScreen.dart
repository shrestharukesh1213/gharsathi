import 'package:flutter/material.dart';
import 'package:gharsathi/services/authentication.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: _firstnameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your First Name',
                    hintText: 'Enter your First Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _lastnameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your Last Name',
                    hintText: 'Enter your Last Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your User Name',
                    hintText: 'Enter your User Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
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
                      Authentication().signup(
                          firstname: _firstnameController.text,
                          lastname: _lastnameController.text,
                          username: _usernameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                          context: context);
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
