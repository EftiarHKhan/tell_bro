import 'package:flutter/material.dart';

const Color yellowClr = Color(0xFFFF8746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = yellowClr;
const Color darkGreyClr = Colors.grey;

class Themes{
  static final light = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: primaryClr,
    brightness: Brightness.light
  );

  static final dark = ThemeData(
    primaryColor: darkGreyClr,
    brightness: Brightness.dark
  );
}