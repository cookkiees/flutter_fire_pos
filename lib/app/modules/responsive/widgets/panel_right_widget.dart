import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/theme/text_theme.dart';
import 'package:flutter_fire_pos/app/theme/utils/my_colors.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_elevated_button_widget.dart';
import '../../../data/providers/card_provider.dart';

class PanelRightWidget extends StatelessWidget {
  const PanelRightWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return SizedBox(
      width: 360,
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 100,
          ),
          if (cartProvider.cartItems.isEmpty)
            Flexible(
                child: Center(
              child: Text("", style: MyTextTheme.defaultStyle()),
            ))
          else
            AnimatedCartList(cartProvider: cartProvider),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                      const Divider(color: Colors.grey),
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
                    title: 'Place order',
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

class AnimatedCartList extends StatefulWidget {
  const AnimatedCartList({
    Key? key,
    required this.cartProvider,
  }) : super(key: key);

  final CartProvider cartProvider;

  @override
  AnimatedCartListState createState() => AnimatedCartListState();
}

class AnimatedCartListState extends State<AnimatedCartList>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedCartList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cartProvider.cartItems.length >
        oldWidget.cartProvider.cartItems.length) {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: ListView.builder(
        itemCount: widget.cartProvider.cartItems.length,
        itemBuilder: (context, index) {
          final product = widget.cartProvider.cartItems[index];

          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(_animationController),
            child: GestureDetector(
              key: ValueKey(product.id), // Key unik untuk AnimatedSwitcher
              onTap: () {
                // Menghapus item dari cartProvider
                widget.cartProvider.decrementFromCart("${product.id}");
                _animationController.reverse();
              },
              child: Container(
                key: ValueKey(product.id), // Key unik untuk AnimatedSwitcher
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: MyColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 12,
                    child: Text(
                      "${index + 1}",
                      style: MyTextTheme.defaultStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${product.name} ",
                        style: MyTextTheme.defaultStyle(),
                      ),
                      Text(
                        "x ${product.quantity}",
                        style: MyTextTheme.defaultStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    "\$ ${product.sellingPrice}",
                    style: MyTextTheme.defaultStyle(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomListTileWidget extends StatelessWidget {
  const CustomListTileWidget({
    super.key,
    required this.title,
    required this.trailing,
    this.trailingFontSize = 14,
    this.titleFontSize = 15,
  });
  final String title;
  final double titleFontSize;
  final String trailing;
  final double trailingFontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListTile(
        title: Text(
          title,
          style: MyTextTheme.defaultStyle(
            color: Colors.grey.shade200,
            fontWeight: FontWeight.w500,
            fontSize: titleFontSize,
          ),
        ),
        trailing: Text(
          trailing,
          style: MyTextTheme.defaultStyle(
            fontWeight: FontWeight.w800,
            fontSize: trailingFontSize,
          ),
        ),
      ),
    );
  }
}
