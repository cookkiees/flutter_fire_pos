import 'package:flutter/material.dart';

import '../theme/text_theme.dart';
import '../theme/utils/my_colors.dart';

class CustomSearchWidget extends StatelessWidget {
  const CustomSearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: MyTextTheme.defaultStyle(),
      cursorColor: MyColors.primary,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 16),
        filled: true,
        fillColor: MyColors.grey[150],
        hintText: 'Start Searching',
        prefixIcon: const Icon(
          color: MyColors.primary,
          Icons.search_outlined,
          size: 26.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBorder: InputBorder.none,
      ),
    );
  }
}
