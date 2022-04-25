import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextTheme {
  TextStyle get subHeading1Style {
    return GoogleFonts.lato(
        textStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Get.isDarkMode ? Colors.grey[400] : Colors.grey));
  }

  TextStyle get heading4Style {
    return GoogleFonts.lato(
        textStyle: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ));
  }

  TextStyle get heading6Style {
    return GoogleFonts.lato(
        textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ));
  }

  TextStyle get body1Style {
    return GoogleFonts.lato(
        textStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ));
  }

  TextStyle get body2Style {
    return GoogleFonts.lato(
        textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ));
  }
}
