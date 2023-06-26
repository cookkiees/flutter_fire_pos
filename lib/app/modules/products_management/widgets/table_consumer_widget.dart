import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../data/model/consumer_model.dart';
import '../../../data/providers/consumer_provider.dart';
import '../../../data/providers/table_provider.dart';
import '../../../theme/text_theme.dart';
import '../../../theme/utils/my_colors.dart';

class TableConsumerWidget extends StatelessWidget {
  const TableConsumerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ConsumersProvider, TableProvider>(
      builder: (context, consumersProvider, tableProvider, _) {
        List<ConsumersModel> consumers = consumersProvider.listConsumers;
        int itemsPerPage = tableProvider.itemsPerPageConsumer;
        int currentPage = tableProvider.currentPageConsumer;

        int startIndex = currentPage * itemsPerPage;
        int endIndex = startIndex + itemsPerPage;
        if (endIndex > consumers.length) {
          endIndex = consumers.length;
        }
        List<ConsumersModel> pageConsumers =
            consumers.sublist(startIndex, endIndex);

        return Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.min,
          children: [
            Table(
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
                      onTap: () => tableProvider.sortConsumers('ID'),
                    ),
                    headerTableCellWidget(
                      title: 'Name',
                      onTap: () => tableProvider.sortConsumers('Name'),
                      fontWeight: FontWeight.w600,
                    ),
                    headerTableCellWidget(
                      title: 'Address',
                      onTap: () => tableProvider.sortConsumers('Address'),
                      fontWeight: FontWeight.w600,
                    ),
                    headerTableCellWidget(
                      title: 'Phone Number',
                      onTap: () => tableProvider.sortConsumers('Phone Number'),
                      fontWeight: FontWeight.w600,
                    ),
                    tableCellWidget(
                      title: 'Action',
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                ...pageConsumers.map((consumers) {
                  return TableRow(
                    children: [
                      tableCellWidget(title: consumers.id),
                      tableCellWidget(
                        title: consumers.name,
                        alignment: Alignment.centerLeft,
                        left: 12,
                      ),
                      tableCellWidget(
                        title: consumers.address,
                        alignment: Alignment.centerLeft,
                        left: 12,
                      ),
                      tableCellWidget(
                        title: consumers.phoneNumber.toString(),
                        alignment: Alignment.centerLeft,
                        left: 12,
                      ),
                      TableCell(
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 18,
                            color: MyColors.grey,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Delete Consumers',
                                    style: MyTextTheme.defaultStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  content: Text(
                                    'Are you sure you want to delete this consumers?',
                                    style: MyTextTheme.defaultStyle(),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        'Cancel',
                                        style: MyTextTheme.defaultStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Delete',
                                        style: MyTextTheme.defaultStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await consumersProvider
                                            .deleteConsumer(consumers.id);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
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

  TableCell headerTableCellWidget({
    String title = '',
    AlignmentGeometry alignment = Alignment.center,
    FontWeight fontWeight = FontWeight.w400,
    void Function()? onTap,
  }) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 40,
        alignment: alignment,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                title,
                style: MyTextTheme.defaultStyle(
                  color: Colors.black,
                  fontWeight: fontWeight,
                ),
              ),
            ),
            InkWell(
              onTap: onTap,
              child: const Icon(
                Icons.import_export_outlined,
                size: 18.0,
                color: MyColors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
