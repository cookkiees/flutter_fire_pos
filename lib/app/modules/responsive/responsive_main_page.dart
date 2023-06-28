import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/modules/reports/reports_page.dart';

import 'package:provider/provider.dart';

import '../../data/providers/authentication_provider.dart';
import '../../theme/text_theme.dart';
import '../products_management/products_management_page.dart';
import '../sales/views/cart_views.dart';
import 'responsive_layout.dart';
import '../../components/custom_search_widget.dart';
import '../../theme/utils/my_colors.dart';
import '../sales/sales_page.dart';
import 'responsive_main_provider.dart';
import 'widgets/menu_bar_widget.dart';

class ResponsiveMainPage extends StatelessWidget {
  const ResponsiveMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mainProvider = context.watch<ResponsiveMainProvider>();

    return Scaffold(
      key: mainProvider.scaffoldKey,
      backgroundColor: MyColors.grey[200],
      body: const ResponsiveLayout(
        phone: ResponsiveHomePage(),
        tablet: ResponsiveHomePage(),
        largeTablet: ResponsiveHomePage(),
        computer: ResponsiveHomePage(),
      ),
      drawer: const MenuBarWidget(
        width: 300,
        useFlexible: false,
      ),
      endDrawer: const CartViews(),
    );
  }
}

class ResponsiveHomePage extends StatelessWidget {
  const ResponsiveHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mainProvider = context.watch<ResponsiveMainProvider>();

    return LayoutBuilder(
      builder: ((context, constraints) {
        var isLargeTablet = ResponsiveLayout.isLargeTablet(context);
        var isTablet = ResponsiveLayout.isTablet(context);
        var isPhone = ResponsiveLayout.isPhone(context);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            constraints.maxWidth <= 1160 || isLargeTablet || isTablet
                ? const SizedBox.shrink()
                : const MenuBarWidget(),
            Expanded(
              flex: 5,
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 24),
                            color: MyColors.white,
                            width: double.infinity,
                            height: 82,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    constraints.maxWidth <= 1160 ||
                                            isLargeTablet ||
                                            isTablet
                                        ? InkWell(
                                            onTap: () {
                                              mainProvider.openDrawer();
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              padding: const EdgeInsets.all(8),
                                              margin: const EdgeInsets.only(
                                                  right: 24),
                                              decoration: BoxDecoration(
                                                color: MyColors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: const Icon(
                                                Icons.subject_outlined,
                                                size: 24,
                                                color: MyColors.primary,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    const SizedBox(
                                      width: 324,
                                      height: 46,
                                      child: CustomSearchWidget(),
                                    ),
                                  ],
                                ),
                                constraints.maxWidth <= 677 ||
                                        isTablet ||
                                        isPhone
                                    ? InkWell(
                                        onTap: () {
                                          mainProvider.openEndDrawer();
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          padding: const EdgeInsets.all(8),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 24),
                                          decoration: BoxDecoration(
                                            color: MyColors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Icon(
                                            Icons.shopping_cart_outlined,
                                            size: 20,
                                            color: MyColors.primary,
                                          ),
                                        ),
                                      )
                                    : Flexible(
                                        child: Container(
                                          color: MyColors.white,
                                          padding:
                                              const EdgeInsets.only(right: 24),
                                          child: SizedBox(
                                            width: 336,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons.email_outlined,
                                                        color: MyColors.grey,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons
                                                            .notifications_outlined,
                                                        color: MyColors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 16),
                                                const DisplayUserWidget(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: IndexedStack(
                        index: mainProvider.tabIndex,
                        children: const [
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: SalesPage(),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: ProductManagementPage(),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: ReportsPage(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class DisplayUserWidget extends StatelessWidget {
  const DisplayUserWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, child) {
        return Row(
          children: [
            Text(
              '${authProvider.userModel?.displayName ?? ''} ',
              style: MyTextTheme.defaultStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              radius: 20.0,
              backgroundColor: MyColors.primary,
              child: authProvider.userModel?.photoURL == null
                  ? const SizedBox.shrink()
                  : Image.network(
                      authProvider.userModel!.photoURL,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const CircularProgressIndicator(); // Tampilkan indikator loading saat gambar sedang dimuat
                      },
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return const Icon(Icons
                            .error); // Tampilkan ikon error jika terjadi kesalahan saat memuat gambar
                      },
                    ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_drop_down,
                color: MyColors.grey,
              ),
            ),
          ],
        );
      },
    );
  }
}
