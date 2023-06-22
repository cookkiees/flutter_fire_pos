import 'package:get/get.dart';

import '../modules/authentication/authentication_page.dart';
import '../modules/responsive/responsive_main_page.dart';
import 'app_routes.dart';

abstract class AppPages {
  static const initial = AppRoutes.initial;
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const ResponsiveMainPage(),
    ),
    GetPage(
      name: AppRoutes.initial,
      page: () => const AuthenticationPage(),
    )
  ];
}
