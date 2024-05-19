import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/styled_button.dart';
import 'package:stock_market/components/styled_input.dart';
import 'package:stock_market/components/styled_text.dart';
import 'package:stock_market/core/app_themes.dart';
import 'package:stock_market/core/jwt_provider.dart';
import 'package:http/http.dart' as http;

class Transaction extends StatefulWidget {
  final String logo;
  final String name;
  final String type;
  final String symbol;
  final num amount;

  const Transaction({
    super.key,
    required this.logo,
    required this.name,
    required this.type,
    required this.symbol,
    required this.amount,
  });

  @override
  State<Transaction> createState() => _Transaction();
}

String removeLeadingZeroes(String x) {
  if (x.trim().isEmpty) return '0';

  int i = 0;

  if (x[x.length - 1] == '.') {
    x = x.substring(0, x.length - 1);
  }

  for (; i < x.length; i++) {
    if (x[i] != '0' || (i < x.length - 1 && x[i + 1] == '.')) break;
  }

  return i == x.length ? '0' : x.substring(i);
}

class _Transaction extends State<Transaction> {
  late TextEditingController _dateInputController;
  late TextEditingController _amountInputController;

  String? token;
  String? serverUrl = dotenv.env['SERVER_URL'];

  bool isLoading = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    _dateInputController = TextEditingController();
    _amountInputController = TextEditingController();
    _dateInputController.text = "${selectedDate.toLocal()}".split(' ')[0];

    token = Provider.of<JWTProvider>(context, listen: false).token;
  }

  @override
  void dispose() {
    _amountInputController.dispose();
    _dateInputController.dispose();

    super.dispose();
  }

  void onAmountChange(String value) {
    setState(() {});

    if (widget.type == 'buy') return;

    final userValue = num.parse(removeLeadingZeroes(value));

    if (userValue > widget.amount) {
      _amountInputController.text = widget.amount.toString();
    }
  }

  void _postNewInvestment() async {
    setState(() {
      isLoading = true;
    });

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final amount = num.parse(removeLeadingZeroes(_amountInputController.text));

    dynamic body = {
      'date': _dateInputController.text,
      'amount': amount,
      'company_ticker': widget.symbol,
      'type': widget.type
    };

    try {
      final response = await http.post(
        Uri.parse('$serverUrl/investments/'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        // redirect back
        Navigator.pop(context, true);
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      throw Exception(error);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: primary, // Header background color
              onPrimary: background, // Header text color
              onSurface: textPrimary, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateInputController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Widget _renderTopSection() {
    return Column(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context, false);
              },
              child: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 12),
            StyledText(
              text: widget.symbol,
              type: 'title_bold',
            ),
          ],
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 40,
          width: 40,
          child: CircleAvatar(
            backgroundColor: primarySmoke,
            backgroundImage: NetworkImage(widget.logo),
          ),
        ),
        const SizedBox(height: 8),
        StyledText(
          text: widget.name,
          type: 'title',
        ),
      ],
    );
  }

  Widget _renderForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StyledText(text: 'Amount'),
        const SizedBox(height: 8),
        StyledInput(
          handleChange: onAmountChange,
          controller: _amountInputController,
          isNumber: true,
          hint: '0.56',
        ),
        const SizedBox(height: 32),
        const StyledText(text: 'Date'),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: StyledInput(
              controller: _dateInputController,
              hint: 'Select Date',
              prefixIcon: const Icon(Icons.calendar_today, size: 16),
            ),
          ),
        ),
        const SizedBox(height: 32),
        widget.type == "sell"
            ? StyledButton(
                handlePress: _postNewInvestment,
                text: 'Enter Sell',
                type: 'delete',
                isDisabled: isLoading ||
                    num.parse(
                          removeLeadingZeroes(_amountInputController.text),
                        ) ==
                        0,
              )
            : StyledButton(
                handlePress: _postNewInvestment,
                text: 'Enter Buy',
                isActive: true,
                isDisabled: isLoading ||
                    num.parse(
                          removeLeadingZeroes(_amountInputController.text),
                        ) ==
                        0,
              ),
      ],
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
            child: Column(
              children: [
                _renderTopSection(),
                const SizedBox(height: 32),
                _renderForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
