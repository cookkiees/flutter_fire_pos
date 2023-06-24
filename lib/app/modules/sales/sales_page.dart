import 'package:flutter/material.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../data/providers/card_provider.dart';
import '../../data/providers/product_provider.dart';
import '../../theme/text_theme.dart';
import '../../theme/utils/my_colors.dart';
import 'views/cart_views.dart';
import 'widgets/card_product_item_widget.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final cartProvider = context.watch<CartProvider>();

    return ChangeNotifierProvider(
      create: (context) => productProvider,
      builder: (context, child) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: SizedBox(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    productProvider.categories.isEmpty
                        ? Text(
                            'Be part of our creativity and diversity! Add a new PRODUCTS and contribute to inspiring others.',
                            style: MyTextTheme.defaultStyle())
                        : AnimationLimiter(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                mainAxisExtent: 150,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                              ),
                              itemCount: productProvider.categories.isEmpty
                                  ? 1
                                  : productProvider.categories.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                final category =
                                    productProvider.categories[index];
                                final itemCount = cartProvider.cartItems
                                    .where((element) =>
                                        element.category == category)
                                    .length;
                                return AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  duration: const Duration(milliseconds: 500),
                                  columnCount: 2,
                                  child: ScaleAnimation(
                                    child: InkWell(
                                      radius: 12,
                                      onTap: () => productProvider
                                          .updateSelectedCategory(category),
                                      child: Container(
                                        alignment: Alignment.bottomLeft,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: productProvider
                                                      .selectedCategory ==
                                                  category
                                              ? MyColors.primary
                                              : MyColors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Stack(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  category,
                                                  style:
                                                      MyTextTheme.defaultStyle(
                                                    fontSize: 22,
                                                    color: productProvider
                                                                .selectedCategory ==
                                                            category
                                                        ? MyColors.white
                                                        : MyColors.primary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  '${productProvider.getProductCountByCategory(category)} Items',
                                                  style:
                                                      MyTextTheme.defaultStyle(
                                                    fontSize: 14,
                                                    color: MyColors.grey,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            itemCount == 0
                                                ? const SizedBox.shrink()
                                                : Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          productProvider
                                                                      .selectedCategory ==
                                                                  category
                                                              ? MyColors.white
                                                              : MyColors
                                                                  .primary,
                                                      radius: 12,
                                                      child: Text(
                                                        "$itemCount",
                                                        style: MyTextTheme
                                                            .defaultStyle(
                                                          color: productProvider
                                                                      .selectedCategory ==
                                                                  category
                                                              ? MyColors.primary
                                                              : MyColors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                    productProvider.categories.isEmpty
                        ? const SizedBox.shrink()
                        : const Flexible(
                            child:
                                Divider(color: MyColors.primary, height: 50)),
                    AnimationLimiter(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisExtent: 150,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        itemCount: productProvider.filteredProducts.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final product =
                              productProvider.filteredProducts[index];
                          final quantity =
                              cartProvider.getQuantityInCart("${product.id}");

                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: CardProductWidget(
                                quantity: quantity,
                                product: product,
                                increment: () =>
                                    cartProvider.addToCart("${product.id}"),
                                decrement: () => cartProvider
                                    .decrementFromCart("${product.id}"),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const CartViews(),
        ],
      ),
    );
  }
}
