import 'package:flutter/material.dart';

import '../theme/text_theme.dart';
import '../theme/utils/my_colors.dart';

class CustomSearchWidget extends StatelessWidget {
  const CustomSearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      child: TextFormField(
        style: MyTextTheme.defaultStyle(),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          filled: true,
          fillColor: MyColors.secondary,
          prefixIcon: const Icon(
            color: Colors.grey,
            Icons.search_outlined,
            size: 28.0,
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
      ),
    );
  }
}
