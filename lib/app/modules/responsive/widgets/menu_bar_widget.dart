import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/text_theme.dart';
import '../../../theme/utils/my_colors.dart';
import '../responsive_main_provider.dart';

class MenuBarWidget extends StatelessWidget {
  const MenuBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveMainProvider = context.watch<ResponsiveMainProvider>();

    return Flexible(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: MyColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Container(
              height: 100,
              alignment: Alignment.center,
              child: Text(
                'FLUTTER',
                style: MyTextTheme.defaultStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            ...[
              "Sales",
              "Products",
              "Accounting",
            ].asMap().entries.map((entry) {
              final index = entry.key;
              final title = entry.value;
              final isSelected = responsiveMainProvider.tabIndex == index;
              List<IconData> icon = [
                Icons.shopping_cart_outlined,
                Icons.assignment_outlined,
                Icons.analytics_outlined,
              ];
              return Container(
                decoration: BoxDecoration(
                    color: isSelected ? MyColors.primary : null,
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  onTap: () => responsiveMainProvider.changeTabIndex(index),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  leading: Icon(
                    icon[index],
                    size: 20,
                    color: isSelected ? MyColors.white : null,
                  ),
                  title: Text(
                    title,
                    style: MyTextTheme.defaultStyle(
                      fontWeight: FontWeight.w500,
                      color: isSelected ? MyColors.white : MyColors.primary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
