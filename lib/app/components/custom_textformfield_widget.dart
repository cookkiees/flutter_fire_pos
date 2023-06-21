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
  });
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
      cursorColor: MyColors.primary,
      style: MyTextTheme.defaultStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        suffixIcon: suffixIcon,
        errorStyle: MyTextTheme.defaultStyle(color: Colors.red),
        fillColor: MyColors.primary,
        labelStyle: MyTextTheme.defaultStyle(color: Colors.black),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.primary),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.primary),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.primary),
        ),
        focusColor: MyColors.primary,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.primary),
        ),
      ),
    );
  }
}
