import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_pos/app/theme/text_theme.dart';
import 'package:flutter_fire_pos/app/theme/utils/my_colors.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/report_provider.dart';

class BestSellingProductChartWidget extends StatefulWidget {
  const BestSellingProductChartWidget({super.key});

  @override
  State<StatefulWidget> createState() => BestSellingProductChartWidgetState();
}

class BestSellingProductChartWidgetState
    extends State<BestSellingProductChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(
      builder: (context, reportProvider, _) {
        Map<String, int> productQuantities =
            reportProvider.calculateProductQuantities();

        return Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _generateIndicators(productQuantities),
            ),
            const SizedBox(width: 40),
            SizedBox(
              height: 280,
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    sections: _generateChartSections(productQuantities),
                    centerSpaceColor: Colors.transparent,
                    centerSpaceRadius: 0,
                    sectionsSpace: 0,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<PieChartSectionData> _generateChartSections(
      Map<String, int> productQuantities) {
    List<PieChartSectionData> sections = [];
    int totalQuantity = 0;

    for (var quantity in productQuantities.values) {
      totalQuantity += quantity;
    }

    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple
    ];

    productQuantities.forEach(
      (productName, quantity) {
        double percentage = quantity / totalQuantity;
        final isTouched = sections.length == touchedIndex;
        final fontSize = isTouched ? 25.0 : 16.0;
        final radius = isTouched ? 150.0 : 140.0;

        sections.add(
          PieChartSectionData(
            value: percentage,
            title: '${(percentage * 100).toStringAsFixed(1)}%',
            color: colors[sections.length % colors.length],
            radius: radius,
            titleStyle: MyTextTheme.defaultStyle(
              color: MyColors.white,
              fontSize: fontSize,
            ),
          ),
        );
      },
    );

    return sections;
  }

  List<Widget> _generateIndicators(Map<String, int> productQuantities) {
    List<Widget> indicators = [];

    productQuantities.forEach(
      (productName, quantity) {
        indicators.add(
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _generateChartSections(productQuantities)
                      .elementAt(indicators.length)
                      .color,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                productName,
                style: MyTextTheme.defaultStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        );
      },
    );

    return indicators;
  }
}
