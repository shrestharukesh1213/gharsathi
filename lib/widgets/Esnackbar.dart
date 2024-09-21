import 'package:flutter/material.dart';

class Esnackbar {
  static show(context, message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$message')));
  }
}
