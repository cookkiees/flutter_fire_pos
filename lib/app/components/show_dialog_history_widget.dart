import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/model/report_model.dart';
import '../theme/text_theme.dart';
import '../theme/utils/my_colors.dart';
import 'custom_listile_widget.dart';

void showDialogHistory(ReportModel transaction) {
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Flutter',
                style: MyTextTheme.defaultStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
              Text(
                'Address : ',
                style: MyTextTheme.defaultStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  '${DateTime.now()}',
                  style: MyTextTheme.defaultStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'ID: ${transaction.id}',
                  style: MyTextTheme.defaultStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              ListTile(
                dense: true,
                leading: Text(
                  "QTY",
                  style: MyTextTheme.defaultStyle(),
                ),
                title: Text(
                  "Name",
                  style: MyTextTheme.defaultStyle(),
                ),
                trailing: Text(
                  "Price",
                  style: MyTextTheme.defaultStyle(),
                ),
              ),
              const Divider(color: MyColors.primary),
              for (var product in transaction.products)
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: MyColors.primary,
                    radius: 12,
                    child: Text(
                      "${product.quantity}",
                      style: MyTextTheme.defaultStyle(
                        color: MyColors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    "${product.name} ",
                    style: MyTextTheme.defaultStyle(),
                  ),
                  trailing: Text(
                    "Rp ${product.sellingPrice}",
                    style: MyTextTheme.defaultStyle(),
                  ),
                ),
              const Divider(color: MyColors.primary),
              CustomListTileWidget(
                title: 'Subtotal',
                trailing: 'Rp ${transaction.subtotal.toStringAsFixed(2)}',
              ),
              CustomListTileWidget(
                title: 'Discount',
                trailing: 'Rp ${transaction.discount.toStringAsFixed(2)}',
              ),
              CustomListTileWidget(
                title: 'Tax 10%',
                trailing: 'Rp ${transaction.tax.toStringAsFixed(2)}',
              ),
              const Divider(color: MyColors.primary),
              CustomListTileWidget(
                title: 'Total',
                trailing: 'Rp ${transaction.total.toStringAsFixed(2)}',
                titleFontSize: 18,
                trailingFontSize: 18,
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
