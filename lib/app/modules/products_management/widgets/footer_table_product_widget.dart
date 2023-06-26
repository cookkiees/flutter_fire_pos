import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/data/providers/table_provider.dart';
import 'package:flutter_fire_pos/app/theme/text_theme.dart';
import 'package:flutter_fire_pos/app/theme/utils/my_colors.dart';
import 'package:provider/provider.dart';

class FooterTableProductWidget extends StatelessWidget {
  const FooterTableProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TableProvider>(builder: (context, tableProvider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              tableProvider.currentPageProduct > 0
                  ? tableProvider
                      .goToPageProduct(tableProvider.currentPageProduct - 1)
                  : null;
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.primary,
              ),
              child: const Icon(
                Icons.chevron_left,
                color: MyColors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${tableProvider.currentPageProduct + 1}',
            style: MyTextTheme.defaultStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () {
              tableProvider.currentPageProduct <
                      tableProvider.totalPagesProduct - 1
                  ? tableProvider
                      .goToPageProduct(tableProvider.currentPageProduct + 1)
                  : null;
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.primary,
              ),
              child: const Icon(
                Icons.chevron_right,
                color: MyColors.white,
              ),
            ),
          ),
        ],
      );
    });
  }
}
