import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/theme/utils/my_colors.dart';

import '../theme/text_theme.dart';

class CustomElevatedButtonWidget extends StatelessWidget {
  const CustomElevatedButtonWidget({
    super.key,
    this.onPressed,
    this.title = '',
    this.radius = 32,
  });

  final void Function()? onPressed;
  final String title;

  final double radius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.purple,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      child: Text(
        title,
        style: MyTextTheme.defaultStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
