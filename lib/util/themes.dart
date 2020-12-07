import 'package:flutter/material.dart';

final List<ThemeData> lightThemeData = [
  ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,
    accentColor: Colors.black54,
    backgroundColor: Color(0xFFE6ECF0),
    scaffoldBackgroundColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  ),
];

final List<ThemeData> darkThemeData = [
  ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,
    accentColor: Color(0xFF8899A6),
    backgroundColor: Color(0xFF10171E),
    scaffoldBackgroundColor: Color(0xFF15202B),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  ),
  ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    primarySwatch: Colors.blue,
    accentColor: Color(0xFF7A8087),
    backgroundColor: Color(0xFF202327),
    scaffoldBackgroundColor: Colors.black,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  ),
];