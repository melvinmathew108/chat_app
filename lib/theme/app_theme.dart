import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryPink = Color(0xFFFF1E74);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color textGray = Color(0xFF9E9E9E);
  static const Color darkText = Color(0xFF2B2B2B);
  static const Color offWhite = Color(0xFFF8F8F8); // Add this off-white color

  static TextStyle titleText = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: darkText,
  );

  static TextStyle subtitleText = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: darkText,
  );

  static TextStyle regularText = const TextStyle(
    fontSize: 14,
    color: darkText,
  );
}
