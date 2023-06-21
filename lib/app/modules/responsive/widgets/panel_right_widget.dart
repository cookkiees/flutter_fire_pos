import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/theme/text_theme.dart';
import 'package:flutter_fire_pos/app/theme/utils/my_colors.dart';

class PanelRightWidget extends StatelessWidget {
  const PanelRightWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 100,
          ),
          Flexible(child: Container()),
          const SizedBox(height: 16),
          Flexible(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    children: [
                      CustomListTileWidget(
                        title: 'Subtotal',
                        trailing: '\$ 0.0',
                      ),
                      CustomListTileWidget(
                        title: 'Discount',
                        trailing: '\$ 0.0',
                      ),
                      CustomListTileWidget(
                        title: 'Tax 10%',
                        trailing: '\$ 0.0',
                      ),
                      Divider(color: Colors.grey),
                      CustomListTileWidget(
                        title: 'Total',
                        trailing: '\$ 0.0',
                        titleFontSize: 18,
                        trailingFontSize: 18,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[200],
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Place Order',
                      style: MyTextTheme.defaultStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomListTileWidget extends StatelessWidget {
  const CustomListTileWidget({
    super.key,
    required this.title,
    required this.trailing,
    this.trailingFontSize = 14,
    this.titleFontSize = 15,
  });
  final String title;
  final double titleFontSize;
  final String trailing;
  final double trailingFontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListTile(
        title: Text(
          title,
          style: MyTextTheme.defaultStyle(
            color: Colors.grey.shade200,
            fontWeight: FontWeight.w500,
            fontSize: titleFontSize,
          ),
        ),
        trailing: Text(
          trailing,
          style: MyTextTheme.defaultStyle(
            fontWeight: FontWeight.w800,
            fontSize: trailingFontSize,
          ),
        ),
      ),
    );
  }
}
