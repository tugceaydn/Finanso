import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isOnboarded = false;

  User? get user => _user;
  bool get isOnboarded => _isOnboarded;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void setOnboarded(bool onboarded) {
    _isOnboarded = onboarded;
    notifyListeners();
  }
}
