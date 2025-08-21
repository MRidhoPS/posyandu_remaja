import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppUtil {
  static final subtitleTextStyle = GoogleFonts.luckiestGuy(
    color: const Color(0xFF4B4B4B),
    fontSize: 24,
  );

  static final titleTextStyle = GoogleFonts.luckiestGuy(
    color: const Color(0xFF4B4B4B),
    fontSize: 30,
  );

  static double screenHeight = 0;
  static double screenWidth = 0;

  static void init(BuildContext context) {
    if (screenWidth == 0 && screenHeight == 0) {
      final size = MediaQuery.of(context).size;
      screenHeight = size.height;
      screenWidth = size.width;
    }
  }
}
