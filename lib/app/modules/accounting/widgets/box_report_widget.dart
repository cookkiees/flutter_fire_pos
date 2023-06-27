import 'package:flutter/material.dart';

import '../../../theme/text_theme.dart';

class BoxReportsWidget extends StatelessWidget {
  const BoxReportsWidget({
    super.key,
    this.title = "",
    this.value = "",
    this.subtitle = "",
    required this.icon,
  });
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: MyTextTheme.defaultStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Icon(icon, size: 38)
            ],
          ),
          Text(
            value,
            style: MyTextTheme.defaultStyle(),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: MyTextTheme.defaultStyle(),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
