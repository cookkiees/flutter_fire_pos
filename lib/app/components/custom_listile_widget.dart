import 'package:flutter/material.dart';

import '../theme/text_theme.dart';
import '../theme/utils/my_colors.dart';

class CustomListTileWidget extends StatelessWidget {
  const CustomListTileWidget({
    super.key,
    required this.title,
    required this.trailing,
    this.trailingFontSize = 14,
    this.titleFontSize = 15,
  });
  final String title;
  final double titleFontSize;
  final String trailing;
  final double trailingFontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListTile(
        title: Text(
          title,
          style: MyTextTheme.defaultStyle(
            color: MyColors.primary,
            fontWeight: FontWeight.w500,
            fontSize: titleFontSize,
          ),
        ),
        trailing: Text(
          trailing,
          style: MyTextTheme.defaultStyle(
            fontWeight: FontWeight.w800,
            fontSize: trailingFontSize,
          ),
        ),
      ),
    );
  }
}
