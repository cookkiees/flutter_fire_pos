import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/modules/products_management/products_management_page.dart';
import 'package:flutter_fire_pos/app/theme/text_theme.dart';
import 'package:provider/provider.dart';

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
    final responsiveMainProvider = context.watch<ResponsiveMainProvider>();

    return Scaffold(
      backgroundColor: MyColors.grey[200],
      body: ResponsiveLayout(
        phone: Container(),
        tablet: Container(),
        largeTablet: Container(),
        computer: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MenuBarWidget(),
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
                                const SizedBox(
                                  width: 360,
                                  child: CustomSearchWidget(),
                                ),
                                Flexible(
                                  child: Container(
                                    color: MyColors.white,
                                    padding: const EdgeInsets.only(right: 24),
                                    child: SizedBox(
                                      width: 336,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                  Icons.notifications_outlined,
                                                  color: MyColors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 16),
                                          Row(
                                            children: [
                                              Text(
                                                'Username',
                                                style: MyTextTheme.defaultStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              const CircleAvatar(
                                                radius: 20.0,
                                                backgroundColor:
                                                    MyColors.primary,
                                              ),
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.arrow_drop_down,
                                                  color: MyColors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
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
                        index: responsiveMainProvider.tabIndex,
                        children: [
                          const SalesPage(),
                          const ProductManagementPage(),
                          Container(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
