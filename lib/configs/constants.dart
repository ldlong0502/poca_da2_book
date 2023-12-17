import 'package:flutter/material.dart';

const Color whiteColor = Colors.white;
const Color yellowColor = Color(0xfff4d03f);
const Color orangeColor = Color(0xffff8c00);
const Color purpleColor = Color(0xff405070);
const Color pinkColor = Color(0xffDC8665);
const Color darkPurpleColor = Color(0xff3f4f6e);
const Color lightAccent = Color(0xff16a085);
const Color secondBackground = Color(0xffF8F5F1);
const Color authorColor = Color(0xff757575);
const Color primaryColor = Color(0xff655299);
const Color secondaryColor = Color(0xffAA9ECD);
const Color textColor = Color(0xff242327);
BoxDecoration linearDecoration = const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryColor,
      secondaryColor
    ],
  ),
);