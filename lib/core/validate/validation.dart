import 'package:flutter/cupertino.dart';

class Validations {
  static bool validateUserEmail(String email) {
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email);
    return emailValid;
  }
}
