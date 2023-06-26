import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/text_theme.dart';
import '../theme/utils/my_colors.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  const CustomTextFormFieldWidget({
    super.key,
    this.labelText = 'lableText',
    this.inputFormatters,
    this.controller,
    this.errorText,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.styleColor = MyColors.primary,
  });
  final Color styleColor;
  final String labelText;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final String? errorText;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      onChanged: onChanged,
      controller: controller,
      inputFormatters: inputFormatters,
      cursorColor: styleColor,
      style: MyTextTheme.defaultStyle(color: styleColor),
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        suffixIcon: suffixIcon,
        errorStyle: MyTextTheme.defaultStyle(color: Colors.red, fontSize: 12),
        fillColor: MyColors.primary,
        labelStyle: MyTextTheme.defaultStyle(color: styleColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: styleColor),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: styleColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: styleColor),
        ),
        focusColor: styleColor,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: styleColor),
        ),
      ),
    );
  }
}
