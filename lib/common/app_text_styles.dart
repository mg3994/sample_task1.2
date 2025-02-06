import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextStyle normalStyle({
    double size = 14,
    FontWeight weight = FontWeight.normal,
    FontStyle style = FontStyle.normal,
  }) {
    return GoogleFonts.lato(
      fontSize: size,
      fontWeight: weight,
      fontStyle: style,
    );
  }

  static TextStyle boldStyle({
    double size = 14,
    FontWeight weight = FontWeight.bold,
    FontStyle style = FontStyle.normal,
  }) {
    return GoogleFonts.lato(
      fontSize: size,
      fontWeight: weight,
      fontStyle: style,
    );
  }
}
