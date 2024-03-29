import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

const Color orangeClr = Colors.orange;
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = orangeClr;
const Color darkGreyClr = Colors.blue;
const Color blackClr = Colors.black;

class Themes{
  static final light = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: primaryClr,
    brightness: Brightness.light
  );

  static final dark = ThemeData(
    backgroundColor: Colors.black,
    primaryColor: darkGreyClr,
    brightness: Brightness.dark
  );
}

TextStyle get subHeadingStyle{
  return GoogleFonts.lato (
    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode?Colors.grey[400]:Colors.grey,
    )
  );
}

TextStyle get HeadingStyle{
  return GoogleFonts.lato (
      textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode?Colors.white:Colors.black,
      )
  );
}

TextStyle get titleStyle{
  return GoogleFonts.lato (
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode?Colors.white:Colors.black,
      )
  );
}

TextStyle get subTitleStyle{
  return GoogleFonts.lato (
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode?Colors.grey[100]:Colors.grey[600],
      )
  );
}

