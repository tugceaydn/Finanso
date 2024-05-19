import 'package:flutter/material.dart';
import 'package:stock_market/components/styled_text.dart';
import 'package:stock_market/core/app_themes.dart';
import 'package:stock_market/main.dart';
import 'package:stock_market/pages/stock_details.dart';

class StyledList extends StatelessWidget {
  final List<Map<String, dynamic>> stockDataList;
  final bool onlySector;
  final bool isCurrentPriceIncluded;

  const StyledList({
    super.key,
    required this.stockDataList,
    required this.onlySector,
    this.isCurrentPriceIncluded = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stockDataList.length,
      itemBuilder: (context, index) {
        final stockData = stockDataList[index];
        final bool isFirstItem = index == 0;
        final bool isLastItem = index == stockDataList.length - 1;

        return InkWell(
          onTap: () {
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) => StockDetails(symbol: stockData["symbol"]),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isLastItem
                      ? Colors.transparent
                      : const Color.fromRGBO(233, 233, 233, 1),
                  width: 1,
                ),
              ),
              borderRadius: BorderRadius.vertical(
                top: isFirstItem ? const Radius.circular(8) : Radius.zero,
                bottom: isLastItem ? const Radius.circular(8) : Radius.zero,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image.network(
                        stockData['logo'],
                        fit: BoxFit.fitWidth,
                        width: 24.0,
                        height: 24.0,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            decoration: ShapeDecoration(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: StyledText(
                              text: stockData['symbol'][0].toUpperCase(),
                              type: 'button',
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledText(
                          text: '${stockData['symbol']}',
                          type: 'body',
                          color: textPrimary,
                        ),
                        isCurrentPriceIncluded
                            ? StyledText(
                                text:
                                    '\$${stockData['price']['current'].toStringAsFixed(2)}',
                                type: 'functional',
                              )
                            : Container()
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: !onlySector
                      ? [
                          StyledText(
                            text: stockData['invested'] > 0
                                ? '\$${stockData['invested'].toStringAsFixed(2)}'
                                : '-\$${(stockData['invested']).abs().toStringAsFixed(2)}',
                            type: 'body',
                            color: textPrimary,
                          ),
                          Row(
                            children: [
                              StyledText(
                                text: stockData['gain'] >= 0
                                    ? '+\$${stockData['gain'].toStringAsFixed(2)} '
                                    : '-\$${(stockData['gain']).abs().toStringAsFixed(2)} ',
                                type: 'functional',
                                color: stockData['gain'] >= 0
                                    ? greenSolid
                                    : redSolid,
                              ),
                              StyledText(
                                text: stockData['gainPercent'] >= 0
                                    ? '(+${stockData['gainPercent'].toStringAsFixed(2)}%)'
                                    : '(${stockData['gainPercent'].toStringAsFixed(2)}%)',
                                type: 'functional',
                                color: stockData['gainPercent'] >= 0
                                    ? greenSolid
                                    : redSolid,
                              ),
                            ],
                          ),
                        ]
                      : [
                          StyledText(
                            text: '${stockData['sector']}',
                            type: 'body',
                            color: textPrimary,
                          ),
                        ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
