import 'package:flutter/material.dart';

class AuthChangeNotifier with ChangeNotifier {
  var authorized = true;

  void toggle() {
    authorized = !authorized;
    notifyListeners();
  }
}
