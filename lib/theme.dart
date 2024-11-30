import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme (Custom white color - 0xFFFFFFFF)
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.grey[800],
      scaffoldBackgroundColor: const Color(0xFFFFFFFF), // White background
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: Colors.black, // Default text color for light theme
        ),
        titleLarge: TextStyle(
          color: Colors.black, // Title color in light theme
          fontWeight: FontWeight.bold,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[800], // AppBar background color
        titleTextStyle: TextStyle(
          color: Colors.white, // AppBar title text color
          fontWeight: FontWeight.bold,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.grey[800], // Button color in light theme
        textTheme: ButtonTextTheme.primary  ,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.grey[900],
      scaffoldBackgroundColor: Colors.black, // Background color for dark theme
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: Colors.white, // Default text color for dark theme
        ),
        titleLarge: TextStyle(
          color: Colors.grey[300], // Title color in dark theme
          fontWeight: FontWeight.bold,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor:
            Colors.grey[900], // AppBar background color in dark theme
        titleTextStyle: TextStyle(
          color: Colors.white, // AppBar title text color in dark theme
          fontWeight: FontWeight.bold,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.grey[700], // Button color in dark theme
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
