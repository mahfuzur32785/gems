import 'package:flutter/material.dart';

// Theme Color
Map<int, Color> customWhiteMap = {
  50: const Color.fromRGBO(253, 253, 253, .1),
  100: const Color.fromRGBO(253, 253, 253, .2),
  200: const Color.fromRGBO(253, 253, 253, .3),
  300: const Color.fromRGBO(253, 253, 253, .4),
  400: const Color.fromRGBO(253, 253, 253, .5),
  500: const Color.fromRGBO(253, 253, 253, .6),
  600: const Color.fromRGBO(253, 253, 253, .7),
  700: const Color.fromRGBO(253, 253, 253, .8),
  800: const Color.fromRGBO(253, 253, 253, .9),
  900: const Color.fromRGBO(253, 253, 253, 1),
};
MaterialColor customWhiteSwatch = MaterialColor(0xffFDFDFD, customWhiteMap);

// Basic Colors
const Color transparent = Color(0x00ffffff);
const Color white = Color(0xffffffff);
const Color whiteFD = Color(0xffFDFDFD);
const Color whiteE4 = Color(0xffE4E4E4);
const Color white70 = Color(0xff707070);
const Color black = Color(0xff000000);
const Color black29 = Color(0xff292929);
const Color black4E = Color(0xff4E4E4E);
const Color primaryColor = Color(0xffFDFDFD);
const Color primaryBGColor = Color(0xffEFFFFE);
const Color blue0C6395 = Color(0xff0C6395);
const Color blueDEF4FE = Color(0xffDEF4FE);

const Color green016E69 = Color(0xff016E69);

//for button Status
const Color blue0275d8 = Color(0xff0275d8);
const Color green5cb85c = Color(0xff5cb85c);
const Color skyblue5cb85c = Color(0xff5bc0de);
const Color yellowf0ad4e = Color(0xfff0ad4e);
const Color redf0ad4e = Color(0xffd9534f);
const Color black292b2c = Color(0xff292b2c);
const Color whitef7f7f7 = Color(0xfff7f7f7);

class MyColors {
  static const Color backgroundColor = Color(0xffF6FCFF);
  static const Color white = Color(0xffFFFFFF);
  static const Color borderColor = Color(0xff000000);
  static const Color primaryColor = Color(0xff016E69);
  // static const Color secondaryColor = Color(0xff0C6395);
  static const Color secondaryColor = Color(0xff006747);
  static const Color primaryTextColor = Color(0xff000000);
  static const Color secondaryTextColor = Color(0xffFFFFFF);
  static const Color customRed = Color(0xffF60C0C);
  static const Color approved = Color(0xff15803d);
  static const Color customGreen = Color(0xff15803d);
  static const Color pending = Color(0xffeab308);
  static const Color rejected = Color(0xffb91c1c);
  static const Color submit = Color(0xff3b82f6);
  static const Color draft = Color(0xff78716c);
  static const Color processing = Color(0xff6366f1);
  static const Color resubmit = Color(0xfff97316);
  static const Color customGrey = Color(0xff4E4E4E);
  static Color statusGrey = Colors.grey.shade600;
  static const Color yellowf0ad4e = Color(0xfff0ad4e);
  static const Color yellow9f5f11 = Color(0xff9f5f11);
  static const Color redf0ad4e = Color(0xffd9534f);
  static const Color status = Color(0xfffef9c3);
  static const Color whitef7f7f7 = Color(0xfff7f7f7);
  static const Color customWhite = Color.fromRGBO(220, 220, 233, 1);
}
