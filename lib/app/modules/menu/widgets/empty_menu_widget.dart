import 'package:flutter/material.dart';

import '../../../theme/text_theme.dart';
import '../../../theme/utils/my_colors.dart';
import 'add_new_menu_widget.dart';

class EmptyMenuWidget extends StatelessWidget {
  const EmptyMenuWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const AddNewMenuWidget();
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.secondary,
          ),
          child: Text('Add new', style: MyTextTheme.defaultStyle()),
        ),
      ],
    );
  }
}
