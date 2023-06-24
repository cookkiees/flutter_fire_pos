import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/product_provider.dart';
import '../../../data/providers/table_provider.dart';
import '../../../theme/text_theme.dart';
import '../../../theme/utils/my_colors.dart';
import 'add_products_widget.dart';

class HeaderProductManagementWidget extends StatelessWidget {
  const HeaderProductManagementWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductProvider, TableProvider>(
      builder: (context, productProvider, tableProvider, child) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Products',
              style: MyTextTheme.defaultStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Text('Entries per page', style: MyTextTheme.defaultStyle()),
                const SizedBox(width: 16),
                SizedBox(
                  width: 50,
                  child: PopupMenuButton<int>(
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 5,
                        child: Text('Show 5 entries',
                            style: MyTextTheme.defaultStyle()),
                      ),
                      PopupMenuItem(
                        value: 10,
                        child: Text('Show 10 entries',
                            style: MyTextTheme.defaultStyle()),
                      ),
                      PopupMenuItem(
                        value: 15,
                        child: Text('Show 15 entries',
                            style: MyTextTheme.defaultStyle()),
                      ),
                    ],
                    onSelected: (value) =>
                        tableProvider.changeItemsPerPage(value),
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.1),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${tableProvider.itemsPerPage}',
                            style: MyTextTheme.defaultStyle(),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const AddProductWidget());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    icon: const Icon(Icons.add),
                    label: Text(
                      'Add Products',
                      style: MyTextTheme.defaultStyle(
                        color: MyColors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
