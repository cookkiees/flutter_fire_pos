import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/data/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../../../responsive_layout.dart';
import '../../components/custom_search_widget.dart';
import '../../theme/text_theme.dart';
import '../../theme/utils/my_colors.dart';
import '../menu/menu_page.dart';
import '../menu/widgets/add_new_menu_widget.dart';
import 'responsive_main_provider.dart';
import 'widgets/panel_right_widget.dart';
import 'widgets/panel_left_widget.dart';

class ResponsiveMainPage extends StatelessWidget {
  const ResponsiveMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ResponsiveMainProvider>();
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: MyColors.primary,
      body: ResponsiveLayout(
        phone: Container(),
        tablet: Container(),
        largeTablet: Container(),
        computer: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 24),
              const PanelLeftWidget(),
              const SizedBox(width: 24),
              Expanded(
                flex: 4,
                child: SizedBox(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Flexible(
                            child: CustomSearchWidget(),
                          ),
                          const SizedBox(width: 24),
                          Flexible(
                              flex: 2,
                              child: SizedBox(
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return const AddNewMenuWidget();
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MyColors.secondary,
                                    ),
                                    child: Text(
                                      'Add new menu',
                                      style: MyTextTheme.defaultStyle(),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                      Expanded(
                        child: IndexedStack(
                          index: controller.tabIndex,
                          children: [
                            Container(color: Colors.blue),
                            Container(color: Colors.amber),
                            const MenuPage(),
                            Container(color: Colors.green),
                            Container(color: Colors.white),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              const PanelRightWidget(),
              const SizedBox(width: 24),
            ],
          ),
        ),
      ),
    );
  }
}
