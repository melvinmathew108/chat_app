import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _phoneNumber;

  bool get isLoggedIn => _isLoggedIn;
  String? get phoneNumber => _phoneNumber;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    _phoneNumber = prefs.getString('phone_number');
    notifyListeners();
  }

  Future<void> login(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('phone_number', phoneNumber);
    _isLoggedIn = true;
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isLoggedIn = false;
    _phoneNumber = null;
    notifyListeners();
  }
}
