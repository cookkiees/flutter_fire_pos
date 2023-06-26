import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/providers/report_provider.dart';
import '../../theme/text_theme.dart';
import '../responsive/responsive_layout.dart';
import 'widgets/accounting_bar_chart_widget.dart';

class AccountingPage extends StatelessWidget {
  const AccountingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var isTablet = ResponsiveLayout.isTablet(context);
        var isPhone = ResponsiveLayout.isPhone(context);
        return Consumer<ReportProvider>(
          builder: (context, reports, _) {
            var title = [
              "Sales today",
              "Total orders",
              "Total earning",
              "Visitor today",
            ];
            var icon = [
              Icons.price_change_outlined,
              Icons.receipt_long_outlined,
              Icons.monetization_on_outlined,
              Icons.group_outlined,
            ];
            var value = [
              "Rp ${reports.dailyProfit}",
              "${reports.transactionHistory.length}",
              "Rp ${reports.getYearlyProfit()}",
              "Rp 0.00",
            ];
            return ListView(
              shrinkWrap: true,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    constraints.maxWidth <= 900 || isTablet || isPhone
                        ? const SizedBox.shrink()
                        : Flexible(
                            flex: 1,
                            child: Container(
                              height: 376,
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
                                  Text(
                                    "Revenue",
                                    style: MyTextTheme.defaultStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Rp ${reports.getYearlyProfit()}",
                                    style: MyTextTheme.defaultStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Flexible(
                                    child: AccountingBarChartWidget(
                                        reportProvider: reports),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    Flexible(
                      child: Container(
                        height: 400,
                        padding: const EdgeInsets.only(top: 24),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 400,
                            mainAxisExtent: 176,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 24,
                          ),
                          itemCount: title.length,
                          shrinkWrap: true,
                          padding:
                              constraints.maxWidth <= 900 || isTablet || isPhone
                                  ? const EdgeInsets.symmetric(horizontal: 24)
                                  : const EdgeInsets.only(right: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return BoxReportsWidget(
                              icon: icon[index],
                              title: title[index],
                              value: value[index],
                              subtitle: '* Update every order success',
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                constraints.maxWidth <= 900 || isTablet || isPhone
                    ? Container(
                        height: 376,
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
                            Text(
                              "Revenue",
                              style: MyTextTheme.defaultStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Rp ${reports.getYearlyProfit()}",
                              style: MyTextTheme.defaultStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Flexible(
                              child: AccountingBarChartWidget(
                                  reportProvider: reports),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 24),
              ],
            );
          },
        );
      },
    );
  }
}

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
