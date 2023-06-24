import 'package:flutter/material.dart';

import '../../../data/model/product_model.dart';
import '../../../theme/text_theme.dart';
import '../../../theme/utils/my_colors.dart';

class CardProductWidget extends StatefulWidget {
  const CardProductWidget({
    super.key,
    required this.product,
    this.increment,
    required this.quantity,
    this.decrement,
  });
  final int quantity;
  final Product product;
  final void Function()? increment;
  final void Function()? decrement;

  @override
  State<CardProductWidget> createState() => _CardProductWidgetState();
}

class _CardProductWidgetState extends State<CardProductWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> widthAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    widthAnimation = Tween<double>(
      begin: 10,
      end: 200,
    ).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quantity >= 1) {
      animationController.forward();
    } else if (widget.quantity <= 0) {
      animationController.reverse();
    }

    return Stack(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        AnimatedBuilder(
          animation: animationController,
          builder: (context, chlid) {
            return Container(
              width: widthAnimation.value,
              height: double.infinity,
              decoration: BoxDecoration(
                color: MyColors.primary,
                borderRadius: animationController.value >= 0.1
                    ? BorderRadius.circular(8)
                    : const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
              ),
            );
          },
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: MyTextTheme.defaultStyle(
                      fontSize: 18,
                      color: widget.quantity == 0
                          ? MyColors.primary
                          : MyColors.white,
                      fontWeight: widget.quantity == 0
                          ? FontWeight.w500
                          : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${widget.product.sellingPrice}",
                    style: MyTextTheme.defaultStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.stock == 0
                        ? "Not available"
                        : "${widget.product.stock} avalaible",
                    style: MyTextTheme.defaultStyle(
                      fontSize: 12,
                      color: widget.product.stock == 0
                          ? Colors.red
                          : MyColors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: widget.decrement,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: widget.quantity == 0
                                ? MyColors.primary
                                : MyColors.white,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 24.0,
                          color: widget.quantity == 0
                              ? MyColors.primary
                              : MyColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.quantity}',
                      style: MyTextTheme.defaultStyle(
                        fontSize: 16,
                        color: widget.quantity == 0
                            ? MyColors.primary
                            : MyColors.white,
                        fontWeight: widget.quantity == 0
                            ? FontWeight.w500
                            : FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: widget.increment,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: widget.quantity == 0
                                ? MyColors.primary
                                : MyColors.white,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 24.0,
                          color: widget.quantity == 0
                              ? MyColors.primary
                              : MyColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
