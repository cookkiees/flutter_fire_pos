import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/data/providers/authentication_provider.dart';
import 'package:flutter_fire_pos/app/data/providers/table_provider.dart';
import 'package:flutter_fire_pos/app/data/providers/report_provider.dart';
import 'package:provider/provider.dart';

import '../../modules/responsive/responsive_main_provider.dart';
import 'card_provider.dart';
import 'product_provider.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ResponsiveMainProvider>(
          lazy: false,
          create: (context) => ResponsiveMainProvider(),
        ),
        ChangeNotifierProvider<TableProvider>(
          lazy: false,
          create: (context) => TableProvider(),
        ),
        ChangeNotifierProvider<ReportProvider>(
          lazy: false,
          create: (context) => ReportProvider(),
        ),
        ChangeNotifierProvider<AuthenticationProvider>(
            lazy: false,
            create: (context) {
              final auth = AuthenticationProvider();

              return auth;
            }),
        ChangeNotifierProvider<CartProvider>(
          lazy: false,
          create: (context) {
            final cart = CartProvider();
            cart.fetchCartItems();
            return cart;
          },
        ),
        ChangeNotifierProvider<ProductProvider>(
          lazy: false,
          create: (context) {
            final product = ProductProvider();
            product.getCategories();
            product.getProducts();
            return product;
          },
        ),
      ],
      child: child,
    );
  }
}
