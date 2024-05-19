import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/chart.dart';
import 'package:stock_market/components/circular_progress.dart';
import 'package:stock_market/components/styled_button.dart';
import 'package:stock_market/core/app_themes.dart';
import 'package:http/http.dart' as http;
import 'package:stock_market/main.dart';
import 'package:stock_market/pages/transaction.dart';

import '../components/styled_text.dart';
import '../core/jwt_provider.dart';

final Map<String, List<Map<String, dynamic>>> chartData = {
  "1W": [],
  "1M": [],
  "1Y": [],
  "5Y": [],
  "Forecast": [],
};

class StockDetails extends StatefulWidget {
  final String symbol;
  const StockDetails({super.key, required this.symbol});

  @override
  State<StockDetails> createState() => _StockDetails();
}

class _StockDetails extends State<StockDetails> {
  String? token;
  String? serverUrl = dotenv.env['SERVER_URL'];

  late String symbol;
  String selectedRange = '1W';

  late Map<String, dynamic> stockData;

  bool isLoading = true;
  bool isForecastLoading = false;
  late bool isForecastActive;
  late bool isStockTrendIncrease = false;

  late double gain;

  Future<void> _fetchStockData() async {
    if (!mounted) return;

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        Uri.parse('$serverUrl/stocks/$symbol'),
        headers: headers,
      );
      if (!mounted) return;

      final body = jsonDecode(response.body);

      stockData = body["data"];

      chartData["1W"] =
          List<Map<String, dynamic>>.from(stockData["historical_values"]["1w"]);
      chartData["1M"] = List<Map<String, dynamic>>.from(
          stockData["historical_values"]["1mo"]);
      chartData["1Y"] =
          List<Map<String, dynamic>>.from(stockData["historical_values"]["1y"]);
      chartData["5Y"] =
          List<Map<String, dynamic>>.from(stockData["historical_values"]["5y"]);

      setState(() {
        gain = _calculateGain();
        isLoading = false;
        isStockTrendIncrease = gain >= 0;
      });
    } catch (error) {
      throw Exception(error);
    }
  }

  void _fetchForecastData() async {
    setState(() {
      isForecastLoading = true;
    });

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    dynamic body = {
      "company_tickers": [symbol],
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
        final companyForecastMonthData = companyForecasts[0]["months"];

        List<int> monthsKeys = companyForecastMonthData.keys
            .map<int>((key) => int.parse(key))
            .toList();

        monthsKeys.sort();

        bool entryExists = false;
        for (var data in chartData['Forecast']!) {
          if (data['date'] == 'Now') {
            data['close'] = stockData["last_close"];
            entryExists = true;
            break;
          }
        }

        if (!entryExists) {
          chartData['Forecast']!.add({
            'date': 'Now',
            'close': stockData["last_close"],
          });
        }

        for (var month in monthsKeys) {
          String dateString = '+${month}m';

          bool entryExists = false;
          for (var data in chartData['Forecast']!) {
            if (data['date'] == dateString) {
              data['close'] = companyForecastMonthData[month.toString()];
              entryExists = true;
              break;
            }
          }

          if (!entryExists) {
            chartData['Forecast']!.add({
              'date': dateString,
              'close': companyForecastMonthData[month.toString()],
            });
          }
        }

        setState(() {
          gain = _calculateGain(range: 'Forecast');
          isStockTrendIncrease = gain >= 0;
          isForecastLoading = false;
        });
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

    isForecastActive = false;
    symbol = widget.symbol;
    token = Provider.of<JWTProvider>(context, listen: false).token;

    _fetchStockData();
  }

  double _calculateGain({String range = '1W'}) {
    final List<Map<String, dynamic>> selectedRangeData = chartData[range]!;

    final start = selectedRangeData[0]["close"];
    final end = selectedRangeData[selectedRangeData.length - 1]["close"];

    return ((end - start) / start) * 100;
  }

  Widget _buildTile(String title, String value, String? symbol, Color? color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StyledText(
          text: title,
          type: 'functional',
        ),
        const SizedBox(height: 8),
        StyledText(
          text: symbol != null ? (symbol + value) : value,
          color: color ?? textPrimary,
        ),
      ],
    );
  }

  Widget _renderStockInfo() {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 32,
        childAspectRatio: (1 / .4),
      ),
      padding: EdgeInsets.zero,
      children: [
        GridTile(
          child: _buildTile(
              'Opening', stockData['last_open'].toStringAsFixed(2), "\$", null),
        ),
        GridTile(
          child: _buildTile(
            'Previous Closing',
            stockData['last_close'].toStringAsFixed(2),
            "\$",
            null,
          ),
        ),
        GridTile(
          child: _buildTile(
            'Risk',
            stockData['risk_label'].toString(),
            null,
            primary,
          ),
        ),
        GridTile(
          child: _buildTile(
              'Highest', stockData['last_high'].toStringAsFixed(2), "\$", null),
        ),
        GridTile(
          child: _buildTile(
              'Lowest', stockData['last_low'].toStringAsFixed(2), "\$", null),
        ),
        GridTile(
          child: _buildTile(
            'Profitability',
            stockData['profitability_label'].toString(),
            null,
            primary,
          ),
        ),
        GridTile(
          child: _buildTile(
            'Avg Volume',
            stockData['last_volume'].toString(),
            null,
            null,
          ),
        ),
        GridTile(
          child: _buildTile(
            'Market Cap',
            stockData['market_cap'].toString(),
            null,
            null,
          ),
        ),
        GridTile(
          child: _buildTile(
            'Amount',
            stockData['amount'].toString(),
            null,
            null,
          ),
        ),
      ],
    );
  }

  Widget _renderTopSectionOfCard() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipOval(
              child: Image.network(
                stockData['logo'],
                fit: BoxFit.fitWidth,
                width: 27.0,
                height: 27.0,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 27,
                    height: 27,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: StyledText(
                      text: stockData['company_ticker'][0].toUpperCase(),
                      type: 'button',
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: StyledText(
                text: stockData['name'].toString(),
                maximumLines: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StyledText(
                  text: '\$${stockData['last_close'].toStringAsFixed(2)}',
                  type: 'title_bold',
                ),
                const SizedBox(width: 4),
                Icon(
                  isStockTrendIncrease
                      ? Icons.arrow_outward_sharp
                      : Icons.arrow_downward_rounded,
                  color: isStockTrendIncrease ? greenSolid : redSolid,
                ),
                StyledText(
                  text: gain >= 0
                      ? '+${gain.toStringAsFixed(2)}%'
                      : '${gain.toStringAsFixed(2)}%',
                  color: isStockTrendIncrease ? greenSolid : redSolid,
                ),
                const SizedBox(width: 16),
              ],
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child: StyledButton(
                handlePress: () {
                  setState(() {
                    selectedRange = isForecastActive ? '1W' : 'Forecast';
                    isForecastActive = !isForecastActive;
                  });
                },
                text: 'Forecast',
                isActive: isForecastActive,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildSelectableBox(String range) {
    final bool isSelected = range == selectedRange;
    return GestureDetector(
      onTap: () {
        setState(() {
          gain = _calculateGain(range: range);
          selectedRange = range;
          isForecastActive = false;
          isStockTrendIncrease = gain >= 0;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: StyledText(
          text: range,
          type: 'small',
          color: isSelected ? Colors.white : textSmoke,
        ),
      ),
    );
  }

  Widget _renderChartsSection() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: selectedRange == 'Forecast' && isForecastLoading
              ? const CircularProgress()
              : Chart(
                  data: chartData[selectedRange]!,
                  color: isStockTrendIncrease ? greenSolid : redSolid,
                  isLabelVisible: selectedRange == 'Forecast',
                ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSelectableBox('1W'),
            _buildSelectableBox('1M'),
            _buildSelectableBox('1Y'),
            _buildSelectableBox('5Y'),
          ],
        ),
      ],
    );
  }

  Widget _renderCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: primarySmoke,
          ),
          child: Column(
            children: [
              _renderTopSectionOfCard(),
              const SizedBox(height: 32),
              _renderChartsSection(),
            ],
          ),
        ),
        isForecastActive
            ? const Padding(
                padding: EdgeInsets.only(top: 16),
                child: StyledText(
                  text:
                      'Keep in mind that future price estimations may not be accurate',
                  type: 'functional',
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _renderButtons() {
    return Container(
      padding: const EdgeInsets.only(top: 32),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: primarySmoke, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: StyledButton(
              handlePress: () {
                navigatorKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (context) => Transaction(
                      type: "sell",
                      logo: stockData["logo"],
                      name: stockData["name"],
                      symbol: stockData["company_ticker"],
                    ),
                  ),
                );
              },
              text: 'Enter Sell',
              type: 'delete',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StyledButton(
              handlePress: () {
                navigatorKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (context) => Transaction(
                      type: "buy",
                      logo: stockData["logo"],
                      name: stockData["name"],
                      symbol: stockData["company_ticker"],
                    ),
                  ),
                );
              },
              text: 'Enter Buy',
              isActive: true,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CommonThemes.appTheme,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: isLoading
                ? const CircularProgress()
                : Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              chartData['Forecast'] = [];
                              navigatorKey.currentState?.pop(context);
                            },
                            child: const Icon(Icons.arrow_back),
                          ),
                          const SizedBox(width: 12),
                          StyledText(
                            text: stockData['company_ticker'].toString(),
                            type: 'title_bold',
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _renderCard(),
                      const SizedBox(height: 32),
                      Expanded(child: _renderStockInfo()),
                      _renderButtons(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
