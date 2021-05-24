import 'package:flutter/material.dart';

class SignInDetails with ChangeNotifier {
  String _user = "";
  String get user => _user;
  void signIn(String userName) {
    _user = userName;
    notifyListeners();
  }
}
