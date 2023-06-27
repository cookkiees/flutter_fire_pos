import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../data/providers/report_provider.dart';
import '../../theme/text_theme.dart';
import '../responsive/responsive_layout.dart';
import 'widgets/accounting_bar_chart_widget.dart';
import 'widgets/box_report_widget.dart';
import 'widgets/footer_table_transaction_history_widget.dart';
import 'widgets/header_table_transaction_history_widget.dart';
import 'widgets/transaction_history_widget.dart';

class AccountingPage extends StatelessWidget {
  const AccountingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Consumer<ReportProvider>(
          builder: (_, reports, __) {
            var isTablet = ResponsiveLayout.isTablet(context);
            var isPhone = ResponsiveLayout.isPhone(context);
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
              clipBehavior: Clip.antiAliasWithSaveLayer,
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
                        child: AnimationLimiter(
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
                            padding: constraints.maxWidth <= 900 ||
                                    isTablet ||
                                    isPhone
                                ? const EdgeInsets.symmetric(horizontal: 24)
                                : const EdgeInsets.only(right: 24),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 500),
                                columnCount: 2,
                                child: ScaleAnimation(
                                  child: BoxReportsWidget(
                                    icon: icon[index],
                                    title: title[index],
                                    value: value[index],
                                    subtitle: '* Update every order success',
                                  ),
                                ),
                              );
                            },
                          ),
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
                Container(
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
