import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishColor = Color(0xFF4e5ae8);
const Color yellowColor = Color(0xFFFFB746);
const Color pinkColor = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishColor;
const Color darkGreyColor = Color(0xFF121212);
Color darkHeaderColor = const Color(0xFF424242);

class Themes {
  static final light = ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        backgroundColor: Colors.white,
          primarySwatch: Colors.red,
          brightness: Brightness.light
          )
          );

  static final dark = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
        backgroundColor: Colors.white,
        primarySwatch: Colors.grey, 
        brightness: Brightness.light),
  );
}

TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      // color: Get.isDarkMode?Colors.white:Colors.black
      color: Colors.grey
    )

  );
}
TextStyle get headingStyle{
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold
    )

  );
}

TextStyle get titleStyle{
  return GoogleFonts.lato(
      textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        color: Colors.black
      )

  );
}

TextStyle get subTitleStyle{
  return GoogleFonts.lato(
      textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        color: Colors.grey
      )

  );
}
