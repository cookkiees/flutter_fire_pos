import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/model/product_model.dart';
import '../data/providers/card_provider.dart';
import '../theme/text_theme.dart';
import '../theme/utils/my_colors.dart';
import 'custom_listile_widget.dart';

void showStruckDialog(CartProvider cartProvider, int transactionId) {
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'ID: $transactionId',
          style: MyTextTheme.defaultStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        content: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(color: MyColors.primary),
              Flexible(
                child: SizedBox(
                  width: 400,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartProvider.cartItems.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      Product product = cartProvider.cartItems[index];
                      return ListTile(
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
                      );
                    },
                  ),
                ),
              ),
              const Divider(color: MyColors.primary),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomListTileWidget(
                    title: 'Subtotal',
                    trailing:
                        'Rp ${cartProvider.getSubtotal().toStringAsFixed(2)}',
                  ),
                  CustomListTileWidget(
                    title: 'Discount',
                    trailing:
                        'Rp ${(cartProvider.getSubtotal() * 0).toStringAsFixed(2)}',
                  ),
                  CustomListTileWidget(
                    title: 'Tax 10%',
                    trailing:
                        'Rp ${(cartProvider.getSubtotal() * 0.1).toStringAsFixed(2)}',
                  ),
                  const Divider(color: MyColors.primary),
                  CustomListTileWidget(
                    title: 'Total',
                    trailing:
                        'Rp ${cartProvider.getTotalPrice().toStringAsFixed(2)}',
                    titleFontSize: 18,
                    trailingFontSize: 18,
                  ),
                ],
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
              cartProvider.clearCart();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
