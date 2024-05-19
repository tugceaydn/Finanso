import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/styled_text.dart';
import 'package:stock_market/core/app_themes.dart';
import 'package:http/http.dart' as http;
import 'package:stock_market/core/jwt_provider.dart';
import 'package:stock_market/core/user_provider.dart';

import '../components/styled_button.dart';

const List<dynamic> screens = [
  {
    'key': 'experience',
    'question': 'What is your experience in investment?',
    'image': 'assets/onboarding2.svg',
    'options': [
      {'key': 0, 'value': 'I\'m just a newbie'},
      {'key': 1, 'value': '1-2 years'},
      {'key': 2, 'value': '3-5 years'},
      {'key': 3, 'value': '6-10 years'},
      {'key': 4, 'value': '10+ years'},
    ],
  },
  {
    'key': 'risk_profitability',
    'question': 'Which one is more you?',
    'image': 'assets/onboarding2.svg',
    'options': [
      {'key': 'low', 'value': 'Low risk and low profitability'},
      {'key': 'high', 'value': 'High risk and high profitability'},
    ],
  },
  {
    'key': 'sectors',
    'question': 'Choose at least 3 sectors you are interested in',
    'image': 'assets/onboarding2.svg',
    'options': [
      {'key': 'Technology', 'value': 'Technology'},
      {'key': 'Financial Services', 'value': 'Financial Services'},
      {'key': 'Industrials', 'value': 'Industrials'},
      {'key': 'Healthcare', 'value': 'Healthcare'},
      {'key': 'Consumer Cyclical', 'value': 'Consumer Cyclical'},
      {'key': 'Energy', 'value': 'Energy'},
      {'key': 'Consumer Defensive', 'value': 'Consumer Defensive'},
      {'key': 'Basic Materials', 'value': 'Basic Materials'},
      {'key': 'Communication Services', 'value': 'Communication Services'},
      {'key': 'Utilities', 'value': 'Utilities'},
      {'key': 'Real Estate', 'value': 'Real Estate'},
    ],
  }
];

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  String? token;
  String? serverUrl = dotenv.env['SERVER_URL'];

  bool isLoading = false;
  int currentScreenIndex = 0;

  dynamic preferences = {
    'experience': '',
    'risk_profitability': '',
    'sectors': <String>[],
  };

  @override
  void initState() {
    super.initState();
    token = Provider.of<JWTProvider>(context, listen: false).token;
  }

  Future<void> _postOnboard() async {
    setState(() {
      isLoading = true;
    });

    dynamic investmentPreferences = {
      'investment': {
        'risk': preferences['risk_profitability'],
        'profitability': preferences['risk_profitability'],
        'experience': 'expert',
        'sectors': preferences['sectors'],
      }
    };

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      dynamic response = await http.post(
        Uri.parse('$serverUrl/onboard/'),
        headers: headers,
        body: jsonEncode(investmentPreferences),
      );
      if (!mounted) return;

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Provider.of<UserProvider>(context, listen: false).setOnboarded(true);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  bool _validateStep() {
    if (currentScreenIndex == 0) return false;
    if (currentScreenIndex == 3) return preferences['sectors'].length < 3;

    return preferences[screens[currentScreenIndex - 1]['key']] == '';
  }

  Widget _renderOptions(dynamic screen) {
    if (currentScreenIndex == 3) {
      return SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: 8,
          runSpacing: 16,
          children: screen['options']
              .map<Widget>(
                (option) => StyledButton(
                  handlePress: () {
                    bool isActive =
                        preferences[screen['key']].contains(option['key']);

                    List<String> newSectors = preferences['sectors'];

                    if (isActive) {
                      newSectors.removeWhere((item) => item == option['key']);
                    } else {
                      newSectors.add(option['key']);
                    }

                    setState(() {
                      preferences = {...preferences, 'sectors': newSectors};
                    });
                  },
                  text: option['value'],
                  type: 'tertiary',
                  isActive: preferences[screen['key']].contains(option['key']),
                ),
              )
              .toList(),
        ),
      );
    }

    return Column(
      children: screen['options']
          .map<Widget>(
            (option) => Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: StyledButton(
                    handlePress: () {
                      setState(() {
                        preferences = {
                          ...preferences,
                          screen['key']: option['key']
                        };
                      });
                    },
                    text: option['value'],
                    type: 'tertiary',
                    isActive: preferences[screen['key']] == option['key'],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _renderQuestionScreen(dynamic screen) {
    return Column(
      children: [
        SvgPicture.asset(
          screen['image'],
          height: 181,
        ),
        const SizedBox(height: 32),
        StyledText(
          text: screen['question'],
          type: 'header',
        ),
        const SizedBox(height: 24),
        _renderOptions(screen)
      ],
    );
  }

  Widget _renderScreen() {
    if (currentScreenIndex == 0) {
      return _renderFirstStep();
    }

    return _renderQuestionScreen(screens[currentScreenIndex - 1]);
  }

  Widget _renderProgress() {
    String buttonText = currentScreenIndex == 0
        ? 'Start'
        : currentScreenIndex == 3
            ? 'Done'
            : 'Next';

    return SizedBox(
      height: 92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(children: [
            Container(
              height: 5,
              width: (MediaQuery.of(context).size.width - 64),
              decoration: BoxDecoration(
                color: primarySmoke,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Container(
              height: 5,
              width: (MediaQuery.of(context).size.width - 64) *
                  (25 * (currentScreenIndex + 1)) /
                  100,
              decoration: BoxDecoration(
                color: textPrimary,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          StyledButton(
            handlePress: () => _onNextScreen(),
            text: buttonText,
            type: 'secondary',
            isDisabled: _validateStep() || isLoading,
          ),
          const SizedBox(height: 16),
          const StyledText(
            text: 'Your answers will shape your app experience',
            type: 'functional',
          ),
        ],
      ),
    );
  }

  Widget _renderFirstStep() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/onboarding1.svg',
            height: 455,
          ),
          const SizedBox(height: 44),
          const StyledText(
            text: 'Welcome!',
            type: 'header',
          ),
          const SizedBox(height: 16),
          const StyledText(text: 'Let\'s get you onboarded', type: 'title'),
        ],
      ),
    );
  }

  void _onNextScreen() {
    if (currentScreenIndex == 3) {
      _postOnboard();
    }

    setState(() {
      if (currentScreenIndex < screens.length) {
        currentScreenIndex++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SizedBox(height: double.infinity),
        _renderScreen(),
        Positioned(
          left: 0,
          right: 0,
          bottom: 32,
          child: _renderProgress(),
        ),
        isLoading
            ? const CircularProgressIndicator(color: primary)
            : Container(),
        // TODO :: isLoading && positioned -> circularProgress
      ],
    );
  }
}
