import 'package:flutter/material.dart';

class ThemeClass {

  Color lightPrimary = Colors.pink;
  Color darkPrimary = Color.fromARGB(1,18,18,18);
  Color lightSecondary = Colors.yellow;
  Color darkSecondary = Color.fromRGBO(26, 9, 221, 0.612);
  Color lightTertiary = Colors.blueAccent;
  Color darkTertiary =Color.fromRGBO(9, 153, 236, 0.612);//Colors.tealAccent.shade400;
  Color outline = Colors.white;
  Color alertColor = Colors.red;
  Color bgLight = Colors.grey.shade100;
  Color bgDark = Colors.black;//Colors.blueGrey.shade800;
  Color lightOnPrimary = Colors.black;
  Color lightOnSecondary = Colors.green;
  Color lightOnTertiary = Colors.grey.shade300;
  Color darkOnPrimary = Colors.white;
  Color darkOnSecondary = Colors.orange;
  Color darkOnTertiary = Colors.grey.shade800;
  Color lightSurface = Colors.grey.shade200;
  Color darkSurface = Color.fromARGB(255, 34, 32, 32);

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light().copyWith(
      primary: _themeClass.lightPrimary,
      secondary: _themeClass.lightSecondary,
      tertiary: _themeClass.lightTertiary,
      error: _themeClass.alertColor,
      background: _themeClass.bgLight,
      outline: _themeClass.outline,
      onPrimary: _themeClass.lightOnPrimary,
      onSecondary: _themeClass.lightOnSecondary,
      onTertiary: _themeClass.lightOnTertiary,
      surface: _themeClass.lightSurface,
    ));
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark().copyWith(
      primary: _themeClass.darkPrimary,
      secondary: _themeClass.darkSecondary,
      tertiary: _themeClass.darkTertiary,
      error: _themeClass.alertColor,
      background: _themeClass.bgDark,
      outline: _themeClass.outline,
      onPrimary: _themeClass.darkOnPrimary,
      onSecondary: _themeClass.darkOnSecondary,
      onTertiary: _themeClass.darkOnTertiary,
      surface: _themeClass.darkSurface,
    )
  );
}

ThemeClass _themeClass = ThemeClass();