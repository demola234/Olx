import 'package:flutter/material.dart';
import '../constants/colors.dart';

enum ThemeOptions {
  light,
  dark,
}

final themeOptions = {
  ThemeOptions.light: ThemeData(
    brightness: Brightness.light,
    primaryColor: OlxColor.olxPrimary,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  ),
  ThemeOptions.dark: ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    backgroundColor: const Color(0xFF202327),
    scaffoldBackgroundColor: Colors.black,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  ),
};
