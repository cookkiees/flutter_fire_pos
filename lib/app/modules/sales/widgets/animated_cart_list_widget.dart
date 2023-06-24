import 'package:flutter/material.dart';

import '../../../data/providers/card_provider.dart';
import '../../../theme/text_theme.dart';
import '../../../theme/utils/my_colors.dart';

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
            child: Container(
              key: ValueKey(product.id), // Key unik untuk AnimatedSwitcher
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: MyColors.primary,
                  radius: 12,
                  child: Text(
                    "${index + 1}",
                    style: MyTextTheme.defaultStyle(
                      color: MyColors.white,
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
          );
        },
      ),
    );
  }
}
