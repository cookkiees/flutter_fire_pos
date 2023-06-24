import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/modules/products_management/widgets/footer_table_widget.dart';
import 'package:provider/provider.dart';

import '../../data/providers/product_provider.dart';
import 'widgets/header_table_widget.dart';
import 'widgets/table_product_widget.dart';

class ProductManagementPage extends StatelessWidget {
  const ProductManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productsProvider, _) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderProductManagementWidget(),
                  productsProvider.products.isEmpty
                      ? const SizedBox.shrink()
                      : const SizedBox(height: 16),
                  productsProvider.products.isEmpty
                      ? const SizedBox.shrink()
                      : const TableProductWidget(),
                  const FooterTableWidget()
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
