import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/data/providers/report_provider.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/table_provider.dart';
import '../../../theme/text_theme.dart';

class HeaderTableTransactionWidget extends StatelessWidget {
  const HeaderTableTransactionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ReportProvider, TableProvider>(
      builder: (context, reportProvider, tableProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transaction History',
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
                        tableProvider.changeItemsPerPageReport(value),
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
                            '${tableProvider.itemsPerPageReport}',
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
              ],
            ),
          ],
        );
      },
    );
  }
}
