import 'package:flutter/material.dart';
import 'package:stock_market/components/styled_button.dart';
import 'package:stock_market/components/styled_input.dart';
import 'package:stock_market/components/styled_text.dart';
import 'package:stock_market/core/app_themes.dart';
import 'package:stock_market/main.dart';

class Transaction extends StatefulWidget {
  final String logo;
  final String name;
  final String type;
  final String symbol;

  const Transaction({
    super.key,
    required this.logo,
    required this.name,
    required this.type,
    required this.symbol,
  });

  @override
  State<Transaction> createState() => _Transaction();
}

class _Transaction extends State<Transaction> {
  late TextEditingController _dateInputController;
  late TextEditingController _amountInputController;

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateInputController = TextEditingController();
    _amountInputController = TextEditingController();
    _amountInputController.addListener(_updateButtonState);
    _dateInputController.text = "${selectedDate.toLocal()}".split(' ')[0];
  }

  @override
  void dispose() {
    _amountInputController.removeListener(_updateButtonState);
    _amountInputController.dispose();
    _dateInputController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {});
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
                navigatorKey.currentState?.pop(context);
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
        StyledInput(controller: _amountInputController, hint: '0.56'),
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
                handlePress: () {},
                text: 'Enter Sell',
                type: 'delete',
                isDisabled: _amountInputController.text == "",
              )
            : StyledButton(
                handlePress: () {},
                text: 'Enter Buy',
                isActive: true,
                isDisabled: _amountInputController.text == "",
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
