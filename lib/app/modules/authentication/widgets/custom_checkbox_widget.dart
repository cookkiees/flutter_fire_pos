import 'package:flutter/material.dart';

import '../../../theme/text_theme.dart';
import '../../../theme/utils/my_colors.dart';

class CustomCheckboxWidget extends StatelessWidget {
  const CustomCheckboxWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool? value;
  final void Function(bool?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.padded,
            splashRadius: 10,
            side: const BorderSide(width: 1),
            activeColor: MyColors.primary,
            checkColor: Colors.white,
            value: value,
            onChanged: onChanged),
        const SizedBox(width: 8),
        Text(
          'Remember me',
          style: MyTextTheme.defaultStyle(),
        ),
      ],
    );
  }
}
