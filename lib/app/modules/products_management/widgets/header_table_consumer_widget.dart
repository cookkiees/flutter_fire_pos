import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/product_provider.dart';
import '../../../data/providers/table_provider.dart';
import '../../../theme/text_theme.dart';
import '../../../theme/utils/my_colors.dart';
import 'add_consumer_widget.dart';

class HeaderTableConsumersWidget extends StatelessWidget {
  const HeaderTableConsumersWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductProvider, TableProvider>(
      builder: (context, productProvider, tableProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Consumers',
              style: MyTextTheme.defaultStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Text('Entries per page',
                    style: MyTextTheme.defaultStyle(fontSize: 12)),
                const SizedBox(width: 8),
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
                        tableProvider.changeItemsPerPageConsumer(value),
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
                            '${tableProvider.itemsPerPageConsumer}',
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
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const AddConsumersWidget());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    icon: const Icon(
                      Icons.add,
                      size: 18,
                    ),
                    label: Text(
                      'Add Consumers',
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
