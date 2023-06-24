import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/data/providers/table_provider.dart';
import 'package:provider/provider.dart';

class FooterTableWidget extends StatelessWidget {
  const FooterTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TableProvider>(builder: (context, tableProvider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                tableProvider.currentPage > 0
                    ? tableProvider.goToPage(tableProvider.currentPage - 1)
                    : null;
              }),
          Text('Page ${tableProvider.currentPage + 1}'),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              tableProvider.currentPage < tableProvider.totalPages - 1
                  ? tableProvider.goToPage(tableProvider.currentPage + 1)
                  : null;
            },
          ),
        ],
      );
    });
  }
}
