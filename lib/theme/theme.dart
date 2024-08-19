import 'package:flutter/material.dart';

class AppTheme {
  static const Color cursorColor = Color(0xFF474e4d);
  static const Color primaryColor = Color(0xFF01822c);
  static const Color accentColor = Color(0xFFc2d8c2);
  static const Color blackColor = Color(0xFF000000);
  static const Color whiteColor = Color(0xFFfefffe);
  static const Color secondaryColor = Color(0xFF1e6c32);
  ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(surface: whiteColor),
  );
    static const Color greenColor = Color(0xFF8bc33c);
  static const Color redColor = Color(0xFFec1923);
  static const Color blueColor = Color(0xFF3072FF);
  static const Color hintColor = Colors.grey;
  static final Color greyColor = Colors.grey[300]!;
  static final Color lightBlue = Colors.blue[100]!;
  static final Color darkGrey = Colors.grey[700]!;
}
