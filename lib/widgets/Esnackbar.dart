import 'package:flutter/material.dart';

class Esnackbar {
  Esnackbar(String s);

  static show(context, message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$message')));
  }
}
