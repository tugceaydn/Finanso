import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../core/app_themes.dart';

class StockData {
  StockData(this.date, this.price);

  final String date;
  final double price;
}

class Chart extends StatelessWidget {
  final List<StockData> data;
  final Color? color;

  const Chart({
    super.key,
    required this.data,
    this.color,
  });

  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        isVisible: false,
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        isVisible: false,
        initialVisibleMinimum: 987 - 200,
      ),
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<StockData, String>>[
        LineSeries<StockData, String>(
          color: color ?? primary,
          dataSource: data,
          xValueMapper: (StockData sales, _) => sales.date,
          yValueMapper: (StockData sales, _) => sales.price,
          isVisibleInLegend: false,
          name: '',
          dataLabelSettings: const DataLabelSettings(isVisible: false),
        )
      ],
    );
  }
}
