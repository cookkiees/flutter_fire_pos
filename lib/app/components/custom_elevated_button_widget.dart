import 'package:flutter/material.dart';

import '../theme/text_theme.dart';
import '../theme/utils/my_colors.dart';

class CustomElevatedButtonWidget extends StatelessWidget {
  const CustomElevatedButtonWidget({
    super.key,
    this.onPressed,
    this.title = '',
    this.radius = 32,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
  });

  final void Function()? onPressed;
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.primary,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      child: Text(
        title,
        style: MyTextTheme.defaultStyle(
          color: Colors.white,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
