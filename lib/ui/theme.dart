import 'package:flutter/material.dart';
import 'package:reminder_app/ui/colors.dart';

class MyAppThemeConfig {
  final Color primaryColor;
  final Brightness brightness;
  final Color backgroundColor;
  final Color onBackgroundColor;

  MyAppThemeConfig.light()
      : primaryColor = ColorPalette.bluishClr,
        brightness = Brightness.light,
        backgroundColor = Colors.white,
        onBackgroundColor = Colors.black;

  MyAppThemeConfig.dark()
      : primaryColor = ColorPalette.darkGrayClr,
        brightness = Brightness.dark,
        backgroundColor = ColorPalette.darkGrayClr,
        onBackgroundColor = Colors.white;

  ThemeData getTheme() {
    return ThemeData(
        primaryColor: primaryColor,
        brightness: brightness,
        backgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor,
          foregroundColor: onBackgroundColor,
        ));
  }
}
