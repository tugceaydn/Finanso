import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../core/app_themes.dart';

class Chart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final Color? color;
  final bool isLabelVisible;

  const Chart({
    super.key,
    required this.data,
    this.color,
    this.isLabelVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        isVisible: isLabelVisible,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
        minimum: data
                .map((e) => e['close'] as double)
                .reduce((value, element) => element < value ? element : value) *
            0.93,
        maximum: data
                .map((e) => e['close'] as double)
                .reduce((value, element) => element > value ? element : value) *
            1.05,
      ),
      enableAxisAnimation: false,
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        animationDuration: 150,
        canShowMarker: false,
        decimalPlaces: 2,
      ),
      series: <CartesianSeries<Map<String, dynamic>, String>>[
        LineSeries<Map<String, dynamic>, String>(
          color: color ?? primary,
          animationDuration: 0,
          dataSource: data,
          xValueMapper: (Map<String, dynamic> data, _) =>
              data['date'] as String,
          yValueMapper: (Map<String, dynamic> data, _) =>
              num.parse(data['close'].toStringAsFixed(2)),
          isVisibleInLegend: false,
          name: '',
          dataLabelSettings: DataLabelSettings(isVisible: isLabelVisible),
        )
      ],
    );
  }
}
