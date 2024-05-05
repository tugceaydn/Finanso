import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/blue_section.dart';
import 'package:stock_market/components/styled_list.dart';
import 'package:stock_market/components/styled_text.dart';
import 'package:stock_market/core/app_themes.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../core/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  User? user;

  List<_StocksData> forecast_data = [
    _StocksData('Today', 1234),
    _StocksData('+3 mn', 1456),
    _StocksData('+6 mn', 987),
    _StocksData('+1 yr', 1345),
  ];

  final List<Map<String, Object>> stockDataList = [
    {
      'photoUrl':
          'https://cdn.logojoy.com/wp-content/uploads/20240110153809/Black-tesla-logo-600x600.png',
      'companyTicker': 'TSLA',
      'currentPrice': '\$738.20',
      'sector': 'Technology',
    },
    {
      'photoUrl':
          'https://cdn.logojoy.com/wp-content/uploads/20240110153809/Black-tesla-logo-600x600.png',
      'companyTicker': 'AAPL',
      'currentPrice': '\$134.72',
      'invested': '\$500.0',
      'profit': '+\$1,23(+1,1%)'
    },
  ];

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
  }

  Widget _renderStocks() {
    return BlueSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StyledText(
            text: 'You can start with',
            type: 'title_bold',
          ),
          const SizedBox(height: 16),
          StyledList(stockDataList: stockDataList),
          const SizedBox(height: 16),
          const StyledText(
            text:
                'Tap on a stock to see more details and enter a stock purchase',
            type: 'functional',
          )
        ],
      ),
    );
  }

  Widget _renderTopSection() {
    return Column(
      children: [
        StyledText(text: 'Hi ${user?.displayName} 👋'),
        const SizedBox(height: 32),
        const StyledText(
            text:
                'You can find the stocks below that we think are a good start for you!'),
        const SizedBox(height: 28),
        const Icon(Icons.keyboard_double_arrow_down_rounded),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _renderInitialHomePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _renderTopSection(),
        _renderStocks(),
      ],
    );
  }

  Widget _renderTotalAssets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StyledText(text: 'Hi ${user?.displayName} 👋'),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: primary,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StyledText(
                text: 'Total Assets',
                color: background,
              ),
              SizedBox(height: 4),
              StyledText(
                text: '\$1.234,56',
                type: 'header',
                color: background,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledText(
                    text: '+\$24,37 (+0,76%) ',
                    type: 'functional',
                    color: greenLight,
                  ),
                  StyledText(
                      text: 'Today', type: 'functional', color: background),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _renderMyInvestments() {
    return BlueSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StyledText(
            text: 'My Investments',
            type: 'title_bold',
          ),
          const SizedBox(height: 16),
          StyledList(stockDataList: stockDataList),
        ],
      ),
    );
  }

  Widget _renderForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const StyledText(
          text: 'Forecast',
          type: 'title_bold',
        ),
        const SizedBox(height: 16),
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(
            majorGridLines: MajorGridLines(width: 0),
          ),
          primaryYAxis: const NumericAxis(
            isVisible: false,
            initialVisibleMinimum: 987 - 200,
          ),
          legend: const Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<_StocksData, String>>[
            LineSeries<_StocksData, String>(
              color: primary,
              dataSource: forecast_data,
              xValueMapper: (_StocksData sales, _) => sales.date,
              yValueMapper: (_StocksData sales, _) => sales.price,
              isVisibleInLegend: false,
              name: '',
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            )
          ],
        ),
      ],
    );
  }

  Widget _renderPersonalizedHomePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _renderTotalAssets(),
        _renderMyInvestments(),
        _renderForecast()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _renderPersonalizedHomePage();
  }
}

class _StocksData {
  _StocksData(this.date, this.price);

  final String date;
  final double price;
}
