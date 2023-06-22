import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/data/providers/card_provider.dart';
import 'package:flutter_fire_pos/app/modules/responsive/responsive_main_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'app/data/providers/product_provider.dart';
import 'app/data/services/api_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Inisialisasi Flutter binding
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint("connected");

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ResponsiveMainProvider>(
        lazy: false,
        create: (context) => ResponsiveMainProvider(),
      ),
      ChangeNotifierProvider<CartProvider>(
          lazy: false,
          create: (context) {
            final provider = CartProvider();
            provider.fetchCartItems();
            return provider;
          }),
      ChangeNotifierProvider<ProductProvider>(
          lazy: false,
          create: (context) {
            final provider = ProductProvider();
            provider.getCategories();
            provider.getProducts();

            return provider;
          }),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initial,
      defaultTransition: Transition.fade,
      initialBinding: ApiServiceBinding(),
      getPages: AppPages.pages,
    );
  }
}
