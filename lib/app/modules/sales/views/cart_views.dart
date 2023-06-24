import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/theme/text_theme.dart';
import 'package:flutter_fire_pos/app/theme/utils/my_colors.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_elevated_button_widget.dart';
import '../../../components/custom_listile_widget.dart';
import '../../../data/providers/card_provider.dart';
import '../widgets/animated_cart_list_widget.dart';

class CartViews extends StatelessWidget {
  const CartViews({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Container(
      width: 360,
      height: double.infinity,
      padding: const EdgeInsets.only(top: 24, right: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          cartProvider.cartItems.isEmpty
              ? const SizedBox.shrink()
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Clear carts",
                      style: MyTextTheme.defaultStyle(),
                    ),
                    IconButton(
                      splashRadius: 16,
                      onPressed: () => cartProvider.clearCart(),
                      icon: const Icon(
                        Icons.clear,
                        size: 18,
                      ),
                    ),
                  ],
                ),
          if (cartProvider.cartItems.isEmpty)
            Flexible(
                child: Center(
              child: Text("Place Order !!", style: MyTextTheme.defaultStyle()),
            ))
          else
            AnimatedCartList(cartProvider: cartProvider),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomListTileWidget(
                        title: 'Subtotal',
                        trailing:
                            '\$ ${cartProvider.getSubtotal().toStringAsFixed(2)}',
                      ),
                      CustomListTileWidget(
                        title: 'Discount',
                        trailing:
                            '\$ ${(cartProvider.getSubtotal() * 0).toStringAsFixed(2)}',
                      ),
                      CustomListTileWidget(
                        title: 'Tax 10%',
                        trailing:
                            '\$ ${(cartProvider.getSubtotal() * 0.1).toStringAsFixed(2)}',
                      ),
                      const Flexible(child: Divider(color: MyColors.primary)),
                      CustomListTileWidget(
                        title: 'Total',
                        trailing:
                            '\$ ${cartProvider.getTotalPrice().toStringAsFixed(2)}',
                        titleFontSize: 18,
                        trailingFontSize: 18,
                      ),
                    ],
                  ),
                  CustomElevatedButtonWidget(
                    title: 'Checkout',
                    radius: 8,
                    onPressed: () => cartProvider.checkout(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
