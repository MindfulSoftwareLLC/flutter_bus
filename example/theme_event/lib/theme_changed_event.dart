import 'package:flutter/material.dart';

class ThemeChangedEvent {
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final String themeName;

  ThemeChangedEvent(this.themeName, this.lightTheme, this.darkTheme);
}
