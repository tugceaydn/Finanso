import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/blue_section.dart';
import 'package:stock_market/components/circular_progress.dart';
import 'package:stock_market/components/styled_list.dart';
import 'package:stock_market/components/styled_text.dart';
import 'package:stock_market/core/app_themes.dart';
import 'package:stock_market/core/jwt_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

import '../core/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

List<_StocksData> forecast_data = [
  _StocksData('Today', 1234),
  _StocksData('+3 mn', 1456),
  _StocksData('+6 mn', 987),
  _StocksData('+1 yr', 1345),
];

class _HomePage extends State<HomePage> {
  User? user;
  final List<Map<String, Object>> myInvestmentsList = [];
  List<Map<String, Object>> recommendStocksList = [];
  Map<String, dynamic> myInvestments = {};
  bool isInvestmentListEmpty = true;

  double totalGain = 0,
      totalGainPercentage = 0,
      totalExpend = 0,
      totalInvested = 0;

  String? serverUrl = dotenv.env['SERVER_URL'];
  String? token;
  bool isRecommendListLoading = true;
  bool isLoading = true;

  Future<void> _fetchRecommendedStocks() async {
    setState(() {
      isRecommendListLoading = true;
    });
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse('$serverUrl/recommend/stocks'),
        headers: headers,
      );
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> data = responseData['data'];
      setState(() {
        recommendStocksList =
            data.map((item) => Map<String, Object>.from(item)).toList();
        isRecommendListLoading = false;
      });
    } catch (error) {
      throw Exception(error);
    }
  }

  void _fetchMyInvestments() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response =
          await http.get(Uri.parse('$serverUrl/investments'), headers: headers);
      if (!mounted) return; // ????
      setState(() {
        myInvestments = jsonDecode(response.body);
        isInvestmentListEmpty =
            myInvestments["data"]["investments"].length == 0;
        isLoading = false;
      });
      if (isInvestmentListEmpty) {
        _fetchRecommendedStocks();
      } else {
        _calculateTotalGain();
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
    token = Provider.of<JWTProvider>(context, listen: false).token;
    _fetchMyInvestments();
  }

  void _calculateTotalGain() {
    Map<String, dynamic>? companies =
        myInvestments["data"]["company_overviews"];

    companies?.forEach(
      (key, value) {
        List<dynamic> curCompanyInvestments =
            (myInvestments["data"] as Map<String, dynamic>?)?["investments"]
                ?.where((investment) => investment["company_ticker"] == key)
                .toList();
        List<dynamic> gains = _calculateCompanyGain(curCompanyInvestments);

        myInvestmentsList.add({
          'logo': value["logo"],
          'symbol': key,
          'price': {'current': value?["price"]["current"]},
          'invested': gains[0],
          'gain': gains[1],
          'gainPercent': gains[2],
        });
      },
    );
  }

  List<double> _calculateCompanyGain(List<dynamic> companyInvestments) {
    num curAmount = 0, totalPrice = 0, totalAmount = 0;
    double avg = 0, unrealizedGain = 0, realizedGain;
    for (final i in companyInvestments) {
      if (i["type"] == "buy") {
        curAmount += i["amount"];
        totalAmount += i["amount"];
        totalPrice += i["price"] * i["amount"];
      }

      if (i["type"] == "sell") {
        avg = totalPrice / totalAmount;
        curAmount -= i["amount"];
        unrealizedGain += (i["price"] - avg) * i["amount"];
      }
    }
    avg = totalPrice / totalAmount;
    totalExpend += totalPrice;

    String ticker = companyInvestments[0]["company_ticker"];
    double cur =
        (myInvestments["data"] as Map<String, dynamic>?)?["company_overviews"]
                [ticker]["price"]["current"]
            .toDouble();

    realizedGain = curAmount.toDouble() * (cur - avg);

    double curInvested = unrealizedGain + (cur * curAmount);
    double curGain = realizedGain + unrealizedGain;
    double curGainPercent = (curGain / totalPrice) * 100;

    totalInvested += curInvested;
    totalGain += curGain;
    totalGainPercentage = (totalGain / totalExpend) * 100;

    return [curInvested, curGain, curGainPercent];
  }

  Widget _renderInitialTopSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StyledText(text: 'Hi ${user?.displayName} 👋'),
        const SizedBox(height: 32),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StyledText(
                text:
                    'You can find the stocks below that we think are a good start for you!'),
            SizedBox(height: 28),
            Icon(Icons.keyboard_double_arrow_down_rounded),
            SizedBox(height: 32),
          ],
        ),
      ],
    );
  }

  Widget _renderRecommendedStocks() {
    return BlueSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StyledText(
            text: 'You can start with',
            type: 'title_bold',
          ),
          const SizedBox(height: 16),
          isRecommendListLoading
              ? const CircularProgress()
              : StyledList(
                  stockDataList: recommendStocksList,
                  onlySector: true,
                ),
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

  Widget _renderInitialHomePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _renderInitialTopSection(),
        _renderRecommendedStocks(),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const StyledText(
                text: 'Total Assets',
                color: background,
              ),
              const SizedBox(height: 4),
              StyledText(
                text: totalInvested > 0
                    ? '\$${totalInvested.toStringAsFixed(2)}'
                    : '-\$${(totalInvested).abs().toStringAsFixed(2)}',
                type: 'header',
                color: background,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledText(
                    text: totalGain > 0
                        ? '+\$${totalGain.toStringAsFixed(2)} '
                        : '-\$${(totalGain).abs().toStringAsFixed(2)} ',
                    type: 'functional',
                    color: totalGain > 0 ? greenLight : redLight,
                  ),
                  StyledText(
                    text: totalGainPercentage > 0
                        ? '(+${totalGainPercentage.toStringAsFixed(2)}%)'
                        : '(${(totalGainPercentage).toStringAsFixed(2)}%)',
                    type: 'functional',
                    color: totalGainPercentage > 0 ? greenLight : redLight,
                  ),
                  const StyledText(
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
          StyledList(
            stockDataList: myInvestmentsList,
            onlySector: false,
          ),
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
    return isLoading
        ? const CircularProgress()
        : isInvestmentListEmpty
            ? _renderInitialHomePage()
            : _renderPersonalizedHomePage();
  }
}

class _StocksData {
  _StocksData(this.date, this.price);

  final String date;
  final double price;
}
