import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/theme/text_theme.dart';
import 'package:provider/provider.dart';

import '../../data/providers/report_provider.dart';
import '../responsive/responsive_layout.dart';
import 'widgets/box_report_widget.dart';
import 'widgets/best_selling_product_chart_widget.dart';
import 'widgets/footer_table_transaction_history_widget.dart';
import 'widgets/header_table_transaction_history_widget.dart';
import 'widgets/transaction_history_widget.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Consumer<ReportProvider>(
          builder: (context, reports, _) {
            var isTablet = ResponsiveLayout.isTablet(context);
            var isPhone = ResponsiveLayout.isPhone(context);

            return ListView(
              shrinkWrap: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: [
                Container(
                  height: constraints.maxWidth <= 900 || isTablet || isPhone
                      ? 400
                      : 200,
                  padding: const EdgeInsets.only(top: 24),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 176,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        crossAxisCount:
                            constraints.maxWidth <= 900 || isTablet || isPhone
                                ? 2
                                : 4),
                    itemCount: 4,
                    shrinkWrap: true,
                    padding: constraints.maxWidth <= 900 || isTablet || isPhone
                        ? const EdgeInsets.symmetric(horizontal: 24)
                        : const EdgeInsets.only(left: 24, right: 24),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
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
                      return BoxReportsWidget(
                        icon: icon[index],
                        title: title[index],
                        value: value[index],
                        subtitle: '* Update every order success',
                      );
                    },
                  ),
                ),
                constraints.maxWidth <= 900 || isTablet || isPhone
                    ? Container(
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
                            const HeaderTableTransactionWidget(),
                            reports.transactionHistory.isEmpty
                                ? const SizedBox.shrink()
                                : const SizedBox(height: 16),
                            reports.transactionHistory.isEmpty
                                ? const SizedBox.shrink()
                                : const TableTransactionWidget(),
                            const SizedBox(height: 16),
                            reports.transactionHistory.isEmpty
                                ? const SizedBox.shrink()
                                : const FooterTableTransactionWidget(),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    constraints.maxWidth <= 900 || isTablet || isPhone
                        ? const SizedBox.shrink()
                        : Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(
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
                                  const HeaderTableTransactionWidget(),
                                  reports.transactionHistory.isEmpty
                                      ? const SizedBox.shrink()
                                      : const SizedBox(height: 16),
                                  reports.transactionHistory.isEmpty
                                      ? const SizedBox.shrink()
                                      : const TableTransactionWidget(),
                                  const SizedBox(height: 16),
                                  reports.transactionHistory.isEmpty
                                      ? const SizedBox.shrink()
                                      : const FooterTableTransactionWidget(),
                                ],
                              ),
                            ),
                          ),
                    Container(
                      height: 376,
                      width: 450,
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
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              'Best Seller',
                              style: MyTextTheme.defaultStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const BestSellingProductChartWidget(),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        );
      },
    );
  }
}
