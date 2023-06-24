import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/theme/utils/my_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextTheme {
  static defaultStyle({
    Color color = MyColors.primary,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return GoogleFonts.urbanist(
      color: color,
      fontSize: fontSize,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
    );
  }
}
