import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/providers/report_provider.dart';
import '../../../theme/text_theme.dart';
import '../../../theme/utils/my_colors.dart';

class AccountingBarChartWidget extends StatelessWidget {
  const AccountingBarChartWidget({
    super.key,
    required this.reportProvider,
  });
  final ReportProvider reportProvider;

  @override
  Widget build(BuildContext context) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final emptyMonths = [1, 3, 5, 7, 9, 11];
    final mappedMonths = months.map((month) {
      if (emptyMonths.contains(months.indexOf(month))) {
        return '';
      }
      return month;
    }).toList();

    return FutureBuilder(
      future: reportProvider.getMonthlyChartFromFirebase(),
      builder: ((_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator();
        } else if (snapshot.hasError) {
          return const SizedBox.shrink();
        } else {
          final monthlyProfits = snapshot.data!;
          final maxProfit = monthlyProfits.reduce(max);
          final barGroups = List<BarChartGroupData>.generate(
            12,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: monthlyProfits[index].toDouble(),
                  width: 16,
                  color: MyColors.primary,
                  borderRadius: BorderRadius.zero,
                ),
              ],
            ),
          );
          return BarChart(
            BarChartData(
              maxY: maxProfit - 1,
              groupsSpace: 16,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  maxContentWidth: 100,
                  tooltipBorder: const BorderSide(width: 0.1),
                  tooltipBgColor: Colors.white,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final index = group.x.toInt();
                    String month = index < months.length ? months[index] : '';
                    final spotPrice = rod.toY.toInt();

                    return BarTooltipItem(
                      '\$$spotPrice\n$month',
                      GoogleFonts.urbanist(),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final intValue = value.toInt();
                      if (intValue >= 0 && intValue < mappedMonths.length) {
                        return Text(
                          mappedMonths[intValue],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.urbanist(fontSize: 12),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                      reservedSize: 30,
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        String labelText = value >= 1
                            ? "${(value / 1000).toStringAsFixed(0)}K"
                            : "$value";

                        if (value % 5 == 0) {
                          return Text(
                            labelText,
                            style: MyTextTheme.defaultStyle(),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                ),
              ),
              gridData: FlGridData(
                show: true,
                horizontalInterval: 1,
                drawVerticalLine: true,
                verticalInterval: 1,
                checkToShowHorizontalLine: (value) => value % 1 == 0,
                getDrawingHorizontalLine: (value) => const FlLine(
                  color: Color(0xFFE4E4E4),
                  strokeWidth: 1,
                ),
              ),
              barGroups: barGroups,
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(width: 0.5),
                  bottom: BorderSide(width: 0.5),
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
