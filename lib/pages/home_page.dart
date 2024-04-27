import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/blue_section.dart';
import 'package:stock_market/components/styled_list.dart';
import 'package:stock_market/components/styled_text.dart';

import '../core/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  User? user;

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
        Row(
          children: [
            StyledText(text: 'Hi ${user?.displayName} '),
            const Icon(Icons.waving_hand_rounded),
          ],
        ),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _renderTopSection(),
        _renderStocks(),
      ],
    );
  }
}
