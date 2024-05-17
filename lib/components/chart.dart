import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../core/app_themes.dart';

class Chart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final Color? color;

  const Chart({
    super.key,
    required this.data,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        isVisible: false,
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        initialVisibleMinimum: data
                .map((e) => e['close'] as double)
                .reduce((value, element) => element < value ? element : value) -
            10,
      ),
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<Map<String, dynamic>, String>>[
        LineSeries<Map<String, dynamic>, String>(
          color: color ?? primary,
          dataSource: data,
          xValueMapper: (Map<String, dynamic> data, _) =>
              data['date'] as String,
          yValueMapper: (Map<String, dynamic> data, _) =>
              data['close'] as double,
          isVisibleInLegend: false,
          name: '',
          dataLabelSettings: const DataLabelSettings(isVisible: false),
        )
      ],
    );
  }
}
