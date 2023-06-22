import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/data/providers/card_provider.dart';
import 'package:flutter_fire_pos/app/theme/utils/my_colors.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../data/model/product_model.dart';
import '../../data/providers/product_provider.dart';
import '../../theme/text_theme.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final cartProvider = context.watch<CartProvider>();

    return ChangeNotifierProvider(
      create: (context) => productProvider,
      builder: (context, child) => SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (productProvider.categories.isEmpty)
                Text(
                    'Be part of our creativity and diversity! Add a new and contribute to inspiring others.',
                    style: MyTextTheme.defaultStyle(
                      color: Colors.white,
                    ))
              else
                AnimationLimiter(
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
                      final category = productProvider.categories[index];
                      final containerColor = Colors.green[200];

                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        columnCount: 2,
                        child: ScaleAnimation(
                          child: InkWell(
                            onTap: () {
                              productProvider.updateSelectedCategory(category);
                            },
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: containerColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category,
                                    style: MyTextTheme.defaultStyle(
                                      fontSize: 22,
                                      color: MyColors.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${productProvider.getProductCountByCategory(category)} Items',
                                    style: MyTextTheme.defaultStyle(
                                      fontSize: 14,
                                      color: MyColors.secondary,
                                      fontWeight: FontWeight.w600,
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
              const Flexible(child: Divider(color: Colors.grey, height: 50)),

              AnimationLimiter(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisExtent: 150,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: productProvider.filteredProducts.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final product = productProvider.filteredProducts[index];
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
                        ),
                      ),
                    );
                  },
                ),
              ),
              // StreamBuilder<List<Product>>(
              //   stream: productProvider.getProductStream(),
              //   builder: (context, snapshot) {
              //     final products = snapshot.data;
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const SizedBox.shrink();
              //     } else if (snapshot.hasError) {
              //       return Text('Error: ${snapshot.error}');
              //     } else if (products != null && products.isNotEmpty) {
              //       // Filter produk berdasarkan kategori yang dipilih
              //       final selectedCategory = productProvider.selectedCategory;
              //       final filteredProducts = selectedCategory != null
              //           ? products
              //               .where(
              //                 (product) => product.category == selectedCategory,
              //               )
              //               .toList()
              //           : products;

              //       return AnimationLimiter(
              //         child: GridView.builder(
              //           gridDelegate:
              //               const SliverGridDelegateWithMaxCrossAxisExtent(
              //             maxCrossAxisExtent: 200,
              //             mainAxisExtent: 150,
              //             mainAxisSpacing: 16,
              //             crossAxisSpacing: 16,
              //           ),
              //           itemCount: filteredProducts.length,
              //           shrinkWrap: true,
              //           physics: const NeverScrollableScrollPhysics(),
              //           itemBuilder: (BuildContext context, int index) {
              //             final product = filteredProducts[index];
              //             final quantity =
              //                 cartProvider.getQuantityInCart("${product.id}");
              //             return AnimationConfiguration.staggeredGrid(
              //               position: index,
              //               duration: const Duration(milliseconds: 500),
              //               columnCount: 2,
              //               child: ScaleAnimation(
              //                 child: CardProductWidget(
              //                   quantity: quantity,
              //                   product: product,
              //                   increment: () =>
              //                       cartProvider.addToCart("${product.id}"),
              //                 ),
              //               ),
              //             );
              //           },
              //         ),
              //       );
              //     } else {
              //       return const SizedBox();
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardProductWidget extends StatelessWidget {
  const CardProductWidget({
    super.key,
    required this.product,
    this.increment,
    required this.quantity,
  });
  final int quantity;
  final Product product;
  final void Function()? increment;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: MyColors.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: MyTextTheme.defaultStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${product.sellingPrice}",
                    style: MyTextTheme.defaultStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w800,
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
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.remove,
                        size: 24.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$quantity',
                      style: MyTextTheme.defaultStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: increment,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 24.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          width: 8,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.green[200],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
