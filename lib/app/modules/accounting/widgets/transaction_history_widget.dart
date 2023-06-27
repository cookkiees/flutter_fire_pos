import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/data/model/report_model.dart';
import 'package:flutter_fire_pos/app/data/providers/report_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/table_provider.dart';
import '../../../theme/text_theme.dart';
import '../../../theme/utils/my_colors.dart';

class TableTransactionWidget extends StatelessWidget {
  const TableTransactionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ReportProvider, TableProvider>(
      builder: (context, transactionProvider, tableProvider, _) {
        List<ReportModel> transactions = transactionProvider.transactionHistory;
        int itemsPerPage = tableProvider.itemsPerPageReport;
        int currentPage = tableProvider.currentPageReport;

        int startIndex = currentPage * itemsPerPage;
        int endIndex = startIndex + itemsPerPage;
        if (endIndex > transactions.length) {
          endIndex = transactions.length;
        }
        List<ReportModel> pageTransactions =
            transactions.sublist(startIndex, endIndex);

        return Table(
          border: TableBorder.all(width: 0.2),
          columnWidths: const {
            0: FlexColumnWidth(0.3),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(0.8),
          },
          children: [
            TableRow(
              children: [
                tableCellWidget(
                  title: 'ID',
                  fontWeight: FontWeight.w600,
                  onTap: () => tableProvider.sortReports('ID'),
                ),
                tableCellWidget(
                  title: 'Profit',
                  fontWeight: FontWeight.w600,
                  onTap: () => tableProvider.sortReports('Profit'),
                ),
                tableCellWidget(
                  title: 'Date',
                  fontWeight: FontWeight.w600,
                  onTap: () => tableProvider.sortReports('Date'),
                ),
                tableCellWidget(
                  title: 'Time',
                  fontWeight: FontWeight.w600,
                  onTap: () => tableProvider.sortReports('Time'),
                ),
                tableCellWidget(
                  title: 'Products',
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            for (var transaction in pageTransactions)
              TableRow(
                children: [
                  tableCellWidget(title: transaction.id.toString()),
                  tableCellWidget(title: "Rp ${transaction.profit}"),
                  tableCellWidget(
                      title: DateFormat.yMMMd().format(transaction.timestamp)),
                  tableCellWidget(
                      title: DateFormat.Hm().format(transaction.timestamp)),
                  TableCell(
                    child: IconButton(
                      icon: const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: MyColors.grey,
                      ),
                      onPressed: () {
                        showTransactionDetailsDialog(context, transaction);
                      },
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  void showTransactionDetailsDialog(
      BuildContext context, ReportModel transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Transaction Details',
            style: MyTextTheme.defaultStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ID: ${transaction.id}',
                  style: MyTextTheme.defaultStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Products:',
                  style: MyTextTheme.defaultStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                for (var product in transaction.products)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        'Product: ${product.name}',
                        style: MyTextTheme.defaultStyle(),
                      ),
                      Text(
                        'Quantity: ${product.quantity}',
                        style: MyTextTheme.defaultStyle(),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                const Divider(
                  color: Colors.grey,
                  height: 30,
                  thickness: 1,
                ),
                Text(
                  'Total Items Sold: ${transaction.products.length}',
                  style: MyTextTheme.defaultStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Profit: ${transaction.profit.toStringAsFixed(2)}',
                  style: MyTextTheme.defaultStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Date: ${DateFormat.yMMMd().format(transaction.timestamp)}',
                  style: MyTextTheme.defaultStyle(),
                ),
                Text(
                  'Time: ${DateFormat.Hm().format(transaction.timestamp)}',
                  style: MyTextTheme.defaultStyle(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Close',
                style: MyTextTheme.defaultStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  TableCell tableCellWidget({
    String title = '',
    AlignmentGeometry alignment = Alignment.center,
    double left = 0,
    FontWeight fontWeight = FontWeight.w400,
    void Function()? onTap,
  }) {
    return TableCell(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(left: left),
          height: 40,
          alignment: alignment,
          child: Text(
            title,
            style: MyTextTheme.defaultStyle(
              color: Colors.black,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
