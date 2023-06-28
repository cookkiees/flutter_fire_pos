import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/data/model/report_model.dart';
import 'package:flutter_fire_pos/app/data/providers/report_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../components/show_dialog_history_widget.dart';
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
                        showDialogHistory(transaction);
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
