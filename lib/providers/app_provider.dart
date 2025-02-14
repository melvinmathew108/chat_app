import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  // No longer needed to store API preferences
  Future<void> initialize() async {
    // Initialize any app-wide settings here if needed
    notifyListeners();
  }
}
