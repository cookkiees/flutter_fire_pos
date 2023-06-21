import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/text_theme.dart';
import '../../../theme/utils/my_colors.dart';
import '../responsive_main_provider.dart';

class PanelLeftWidget extends StatelessWidget {
  const PanelLeftWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ResponsiveMainProvider>();

    return Flexible(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              height: 100,
              alignment: Alignment.center,
              child: Text(
                '🔥.🔥',
                style: MyTextTheme.defaultStyle(
                  fontSize: 32,
                ),
              ),
            ),
            ...[
              "Reservation",
              "Table Services",
              "Menu",
              "Delivery",
              "Accounting",
            ].asMap().entries.map((entry) {
              final index = entry.key;
              final title = entry.value;
              final isSelected = controller.tabIndex == index;
              return ListTile(
                onTap: () => controller.changeTabIndex(index),
                selected: true,
                selectedColor: isSelected ? MyColors.secondary : null,
                selectedTileColor: isSelected ? MyColors.secondary : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                title: Text(
                  title,
                  style: MyTextTheme.defaultStyle(),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
