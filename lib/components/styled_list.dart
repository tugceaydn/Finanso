import 'package:flutter/material.dart';
import 'package:stock_market/components/styled_text.dart';
import 'package:stock_market/core/app_themes.dart';

class StyledList extends StatelessWidget {
  final List<Map<String, dynamic>> stockDataList;

  const StyledList({Key? key, required this.stockDataList}) : super(key: key);

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

        return Container(
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
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: primarySmoke,
                    backgroundImage: NetworkImage(stockData['photoUrl']),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StyledText(
                        text: '${stockData['companyTicker']}',
                        type: 'body',
                        color: textPrimary,
                      ),
                      StyledText(
                        text: '${stockData['currentPrice']}',
                        type: 'functional',
                      )
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: stockData.containsKey('invested')
                    ? [
                        StyledText(
                          text: '${stockData['invested']}',
                          type: 'body',
                          color: textPrimary,
                        ),
                        StyledText(
                          text: '${stockData['profit']}',
                          type: 'functional',
                          color: stockData['profit'][0] == '+'
                              ? greenSolid
                              : redSolid,
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
        );
      },
    );
  }
}
