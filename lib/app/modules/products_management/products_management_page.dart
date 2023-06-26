import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/providers/consumer_provider.dart';
import '../../data/providers/product_provider.dart';
import 'widgets/footer_table_consumer_widget.dart';
import 'widgets/footer_table_product_widget.dart';
import 'widgets/header_table_consumer_widget.dart';
import 'widgets/header_table_product_widget.dart';
import 'widgets/table_consumer_widget.dart';
import 'widgets/table_product_widget.dart';

class ProductManagementPage extends StatelessWidget {
  const ProductManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductProvider, ConsumersProvider>(
      builder: (context, products, consumers, _) {
        return ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(
                right: 24,
                top: 24,
                left: 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderTableProductWidget(),
                  products.products.isEmpty
                      ? const SizedBox.shrink()
                      : const SizedBox(height: 16),
                  products.products.isEmpty
                      ? const SizedBox.shrink()
                      : const TableProductWidget(),
                  const SizedBox(height: 16),
                  products.products.isEmpty
                      ? const SizedBox.shrink()
                      : const FooterTableProductWidget(),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(
                right: 24,
                top: 24,
                left: 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderTableConsumersWidget(),
                  consumers.listConsumers.isEmpty
                      ? const SizedBox.shrink()
                      : const SizedBox(height: 16),
                  consumers.listConsumers.isEmpty
                      ? const SizedBox.shrink()
                      : const TableConsumerWidget(),
                  const SizedBox(height: 16),
                  consumers.listConsumers.isEmpty
                      ? const SizedBox.shrink()
                      : const FooterTableConsumerWidget(),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
