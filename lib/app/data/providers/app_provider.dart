import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/data/providers/authentication_provider.dart';
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
        ChangeNotifierProvider<AuthenticationProvider>(
          lazy: false,
          create: (context) => AuthenticationProvider(),
        ),
        ChangeNotifierProvider<CartProvider>(
          lazy: false,
          create: (context) {
            final provider = CartProvider();
            provider.fetchCartItems();
            return provider;
          },
        ),
        ChangeNotifierProvider<ProductProvider>(
          lazy: false,
          create: (context) {
            final provider = ProductProvider();
            provider.getCategories();
            provider.getProducts();
            return provider;
          },
        ),
      ],
      child: child,
    );
  }
}
