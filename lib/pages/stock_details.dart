import 'package:flutter/material.dart';
import 'package:stock_market/components/chart.dart';
import 'package:stock_market/components/circular_progress.dart';
import 'package:stock_market/components/styled_button.dart';
import 'package:stock_market/core/app_themes.dart';

import '../components/styled_text.dart';

final stockData = {
  'ticker': 'TSLA',
  'photoUrl':
      'https://media.designrush.com/inspirations/269904/conversions/1.Tesla-Logo-Design-preview.jpg',
  'name': 'Tesla',
  'opening': 132.44,
  'previous_closing': 130.24,
  'risk': 'High',
  'highest': 140.54,
  'lowest': 120.43,
  'profitability': 'Neutral',
  'average_volume': '24 Mn',
  'market_cap': '512 Bn',
  'amount': 0.56,
};

final Map<String, List<StockData>> chartData = {
  "1W": [
    StockData('Mon', 1234),
    StockData('Tue', 1456),
    StockData('Wed', 987),
    StockData('Thu', 1345),
    StockData('Fri', 921),
    StockData('Sat', 1412),
    StockData('San', 1345),
  ],
  "1M": [
    StockData('Mon', 1234),
    StockData('Tue', 1456),
    StockData('Wed', 987),
    StockData('Thu', 1345),
    StockData('Fri', 921),
    StockData('Sat', 1412),
    StockData('San', 1345),
  ],
  "1Y": [
    StockData('Mon', 100),
    StockData('Tue', 1456),
    StockData('Wed', 987),
    StockData('Thu', 1345),
    StockData('Fri', 921),
    StockData('Sat', 1412),
    StockData('San', 1345),
  ],
  "5Y": [
    StockData('Mon', 1234),
    StockData('Tue', 1456),
    StockData('Wed', 987),
    StockData('Thu', 1345),
    StockData('Fri', 921),
    StockData('Sat', 1412),
    StockData('San', 1345),
  ],
  "Forecast": [
    StockData('Mon', 1234),
    StockData('Tue', 1456),
    StockData('Wed', 987),
    StockData('Thu', 1345),
    StockData('Fri', 921),
    StockData('Sat', 1412),
    StockData('San', 900),
  ],
};

class StockDetails extends StatefulWidget {
  const StockDetails({super.key});

  State<StockDetails> createState() => _StockDetails();
}

class _StockDetails extends State<StockDetails> {
  late bool isForecastActive;
  late bool isStockTrendIncrease;
  bool isTrendCalculating = true;
  String selectedRange = '1W';

  void _setSelectedRange(String range) {
    setState(() {
      selectedRange = range;
    });
  }

  void _setIsForecastActive(bool isActive) {
    setState(() {
      isForecastActive = isActive;
    });
  }

  void _setIsTrendCalculating(bool isCalculating) {
    setState(() {
      isTrendCalculating = isCalculating;
    });
  }

  void _setIsStockTrendIncrease(bool isIncrease) {
    setState(() {
      isStockTrendIncrease = isIncrease;
    });
  }

  void _calculateStockTrend(double start, double end) {
    _setIsTrendCalculating(true);
    if (end < start) {
      _setIsStockTrendIncrease(false);
      print(false);
    } else {
      _setIsStockTrendIncrease(true);
      print(true);
    }
    _setIsTrendCalculating(false);
  }

  @override
  void initState() {
    isForecastActive = false;
    print(chartData[selectedRange]!.first.price);
    print(chartData[selectedRange]!.last.price);
    _calculateStockTrend(
      chartData[selectedRange]!.first.price,
      chartData[selectedRange]!.last.price,
    );
    _setIsTrendCalculating(false);
    super.initState();
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
              'Opening', stockData['opening'].toString(), "\$", null),
        ),
        GridTile(
          child: _buildTile(
            'Previous Closing',
            stockData['previous_closing'].toString(),
            "\$",
            null,
          ),
        ),
        GridTile(
          child: _buildTile(
            'Risk',
            stockData['risk'].toString(),
            null,
            stockData['risk'].toString() == "High" ? redSolid : primary,
          ),
        ),
        GridTile(
          child: _buildTile(
              'Highest', stockData['highest'].toString(), "\$", null),
        ),
        GridTile(
          child:
              _buildTile('Lowest', stockData['lowest'].toString(), "\$", null),
        ),
        GridTile(
          child: _buildTile(
            'Profitability',
            stockData['profitability'].toString(),
            null,
            stockData['profitability'].toString() == "High"
                ? redSolid
                : primary,
          ),
        ),
        GridTile(
          child: _buildTile(
            'Avg Volume',
            stockData['average_volume'].toString(),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 27,
                    width: 27,
                    child: CircleAvatar(
                      backgroundColor: primarySmoke,
                      backgroundImage: NetworkImage(
                        stockData['photoUrl'].toString(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  StyledText(text: stockData['name'].toString()),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const StyledText(
                    text: '\$170,83 ',
                    type: 'title_bold',
                  ),
                  const SizedBox(width: 4),
                  Row(
                    children: [
                      Icon(
                        isStockTrendIncrease
                            ? Icons.arrow_outward_sharp
                            : Icons.arrow_downward_rounded,
                        color: isStockTrendIncrease ? greenSolid : redSolid,
                      ),
                      StyledText(
                        text: '-1,15%',
                        color: isStockTrendIncrease ? greenSolid : redSolid,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: StyledButton(
            handlePress: () {
              _setIsForecastActive(!isForecastActive);
              _setSelectedRange("Forecast");
            },
            text: 'Forecast',
            isActive: isForecastActive,
          ),
        )
      ],
    );
  }

  Widget _buildChartContent(chartData) {
    return Chart(
      data: chartData,
      color: isStockTrendIncrease ? greenSolid : redSolid,
    );
  }

  Widget _buildContent() {
    _calculateStockTrend(
      chartData[selectedRange]!.first.price,
      chartData[selectedRange]!.last.price,
    );

    return SizedBox(
      height: 160,
      child: _buildChartContent(chartData[selectedRange]),
    );
  }

  Widget _buildSelectableBox(String range) {
    final isSelected = range == selectedRange;
    return GestureDetector(
      onTap: () {
        _setSelectedRange(range);
        _setIsForecastActive(false);
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
        _buildContent(),
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
          height: 360,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: primarySmoke,
          ),
          child: isTrendCalculating
              ? const CircularProgress()
              : Column(
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
              handlePress: () {},
              text: 'Delete Purchase',
              type: 'delete',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StyledButton(
              handlePress: () {},
              text: 'Enter Purchase',
              isActive: true,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.arrow_back),
            const SizedBox(width: 12),
            StyledText(
              text: stockData['ticker'].toString(),
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
    );
  }
}
