import 'package:flutter/material.dart';

class LoginControllers {
  final urlController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void dispose() {
    urlController.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }
}
