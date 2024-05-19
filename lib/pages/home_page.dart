import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/blue_section.dart';
import 'package:stock_market/components/chart.dart';
import 'package:stock_market/components/circular_progress.dart';
import 'package:stock_market/components/styled_list.dart';
import 'package:stock_market/components/styled_text.dart';
import 'package:stock_market/core/app_themes.dart';
import 'package:stock_market/core/jwt_provider.dart';
import 'package:http/http.dart' as http;

import '../core/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  User? user;
  String? token;
  String? serverUrl = dotenv.env['SERVER_URL'];

  Map<String, dynamic> myInvestments = {};

  List<Map<String, Object>> myInvestmentsList = [];
  List<Map<String, dynamic>> forecastChartData = [];
  List<Map<String, Object>> recommendStocksList = [];

  double totalGain = 0,
      totalGainPercentage = 0,
      totalExpend = 0,
      totalInvested = 0,
      totalMoney = 0;

  bool isLoading = true;
  bool isForecastLoading = true;
  bool isRecommendListLoading = true;

  void _remountHomepage() {
    setState(() {
      myInvestments = {};

      myInvestmentsList = [];
      forecastChartData = [];
      recommendStocksList = [];

      totalGain = 0;
      totalGainPercentage = 0;
      totalExpend = 0;
      totalInvested = 0;

      isLoading = true;
      isForecastLoading = true;
      isRecommendListLoading = true;
    });

    _fetchMyInvestments();
  }

  void _fetchRecommendedStocks() async {
    setState(() {
      isRecommendListLoading = true;
    });

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse('$serverUrl/recommend/stocks/'),
        headers: headers,
      );
      if (!mounted) return;

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
      if (!mounted) return;
      setState(() {
        myInvestments = jsonDecode(response.body);
        isLoading = false;
      });
      if (myInvestments["data"]["investments"].length == 0) {
        // if user has no investments, recommend some
        _fetchRecommendedStocks();
      } else {
        _fetchForecastData();

        myInvestmentsList = _calculateTotalGain({});

        for (var element in myInvestmentsList) {
          totalInvested += element['invested'] as double;
          totalExpend += element['totalBuy'] as double;
          totalGain += element['gain'] as double;
        }

        forecastChartData.add({'date': 'Now', 'close': totalInvested});

        totalGainPercentage = (totalGain / totalExpend) * 100;
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  void _fetchForecastData() async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    List<String> list =
        myInvestments["data"]["company_overviews"].keys.toList();

    dynamic body = {
      "company_tickers": list,
    };

    try {
      final response = await http.post(
        Uri.parse('$serverUrl/forecast/'),
        headers: headers,
        body: jsonEncode(body),
      );
      if (!mounted) return;

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> companyForecasts = body['data'];

        final Map<String, Map<String, double>> closeValuesOfCompaniesByMonth =
            {};

        for (var company in companyForecasts) {
          // calculate forecast values for the chart
          company['months'].forEach((month, closeValue) {
            if (closeValuesOfCompaniesByMonth[month] == null) {
              closeValuesOfCompaniesByMonth[month] = {};
            }

            closeValuesOfCompaniesByMonth[month]?[company['company_ticker']] =
                closeValue;
          });
        }

        List<int> monthsKeys = closeValuesOfCompaniesByMonth.keys
            .map((key) => int.parse(key))
            .toList();

        monthsKeys.sort();

        for (var month in monthsKeys) {
          final closeValuesByCompany =
              closeValuesOfCompaniesByMonth[month.toString()];

          final allInvestments = _calculateTotalGain(closeValuesByCompany);
          double totalBalance = 0;

          for (var element in allInvestments) {
            totalBalance += element['invested'] as double;
          }

          forecastChartData.add({
            'date': '+${month}m',
            'close': totalBalance,
          });
        }
      }

      setState(() {
        isForecastLoading = false;
      });
    } catch (error) {
      setState(() {
        isForecastLoading = false;
      });
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

  List<Map<String, Object>> _calculateTotalGain(
      Map<String, double>? staticTargetCloseByCompany) {
    Map<String, dynamic>? companies =
        myInvestments["data"]["company_overviews"];
    final List<Map<String, Object>> investmentsList = [];

    companies?.forEach(
      (companyTicker, overview) {
        List<dynamic> curCompanyInvestments =
            (myInvestments["data"])["investments"]
                .where((investment) =>
                    investment["company_ticker"] == companyTicker)
                .toList();

        double targetClose = staticTargetCloseByCompany?[companyTicker] ??
            overview["price"]["current"];
        List<dynamic> gains =
            _calculateCompanyGain(curCompanyInvestments, targetClose);

        investmentsList.add({
          'logo': overview["logo"],
          'symbol': companyTicker,
          'price': {'current': overview?["price"]["current"]},
          'invested': gains[0],
          'gain': gains[1],
          'gainPercent': gains[2],
          'totalBuy': gains[3],
        });
      },
    );

    return investmentsList;
  }

  List<double> _calculateCompanyGain(
    List<dynamic> companyInvestments,
    double targetClose,
  ) {
    double curAmount = 0, totalAmount = 0, totalBuy = 0;
    double avg = 0, unrealizedGain = 0, realizedGain;

    for (final investment in companyInvestments) {
      if (investment["type"] == "buy") {
        curAmount += investment["amount"];
        totalAmount += investment["amount"];
        totalBuy += investment["price"] * investment["amount"];
      }

      if (investment["type"] == "sell") {
        avg = totalBuy / totalAmount;
        curAmount -= investment["amount"];
        unrealizedGain += (investment["price"] - avg) * investment["amount"];
      }
    }

    avg = totalBuy / totalAmount;

    realizedGain = curAmount * (targetClose - avg);

    double curInvested = unrealizedGain + (targetClose * curAmount);
    double curGain = realizedGain + unrealizedGain;
    double curGainPercent = totalBuy == 0 ? 0 : ((curGain / totalBuy) * 100);

    return [curInvested, curGain, curGainPercent, totalBuy];
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
    return SizedBox(
      width: double.infinity,
      child: BlueSection(
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
                    onUpdateParent: _remountHomepage,
                  ),
            const SizedBox(height: 16),
            const StyledText(
              text:
                  'Tap on a stock to see more details and enter a stock purchase',
              type: 'functional',
            )
          ],
        ),
      ),
    );
  }

  Widget _renderHomePageWithRecommendedStocks() {
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
                text: totalInvested >= 0
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
                    text: totalGain >= 0
                        ? '+\$${totalGain.toStringAsFixed(2)} '
                        : '-\$${(totalGain).abs().toStringAsFixed(2)} ',
                    type: 'functional',
                    color: totalGain >= 0 ? greenLight : redLight,
                  ),
                  StyledText(
                    text: totalGainPercentage >= 0
                        ? '(+${totalGainPercentage.toStringAsFixed(2)}%)'
                        : '(${(totalGainPercentage).toStringAsFixed(2)}%)',
                    type: 'functional',
                    color: totalGainPercentage >= 0 ? greenLight : redLight,
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
    return SizedBox(
      width: double.infinity,
      child: BlueSection(
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
              onUpdateParent: _remountHomepage,
            ),
          ],
        ),
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
        isForecastLoading
            ? const CircularProgress()
            : Chart(
                data: forecastChartData,
                isLabelVisible: true,
              ),
      ],
    );
  }

  Widget _renderHomePageWithUserData() {
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
    return Center(
      child: isLoading
          ? const CircularProgress()
          : myInvestments["data"]["investments"].length == 0
              ? _renderHomePageWithRecommendedStocks()
              : _renderHomePageWithUserData(),
    );
  }
}
