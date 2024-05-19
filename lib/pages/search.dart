import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/blue_section.dart';
import 'package:stock_market/components/circular_progress.dart';
import 'package:stock_market/components/styled_input.dart';
import 'package:stock_market/components/styled_list.dart';
import 'package:stock_market/components/styled_text.dart';
import 'package:http/http.dart' as http;
import 'package:stock_market/core/app_themes.dart';
import 'package:stock_market/core/jwt_provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _Search();
}

class _Search extends State<Search> {
  String? token;
  String? serverUrl = dotenv.env['SERVER_URL'];

  Timer? _debounce;
  bool isLoading = false;
  late TextEditingController _searchInputController;
  List<Map<String, Object>> recommendStocksList = [];

  void _fetchSearchedStocks() async {
    setState(() {
      isLoading = true;
    });

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final url = '$serverUrl/search?query=${_searchInputController.text}';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
      );
      if (!mounted) return;

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> data = responseData['data'];

        setState(() {
          recommendStocksList = _searchInputController.text.isNotEmpty
              ? data.map((item) => Map<String, Object>.from(item)).toList()
              : [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });

        throw Exception('Failed to load data');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      throw Exception(error);
    }
  }

  @override
  void initState() {
    super.initState();
    _searchInputController = TextEditingController();
    _searchInputController.addListener(_onSearchChanged);
    token = Provider.of<JWTProvider>(context, listen: false).token;
  }

  @override
  void dispose() {
    _searchInputController.removeListener(_onSearchChanged);
    _searchInputController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (_searchInputController.text.isNotEmpty) {
        _fetchSearchedStocks();
      } else {
        setState(() {
          recommendStocksList = [];
        });
      }
    });
  }

  Widget _renderTopSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StyledText(
          text: 'Search',
          type: 'header',
        ),
        const SizedBox(height: 10),
        StyledInput(
          controller: _searchInputController,
          hint: 'Search stocks...',
          prefixIcon: const Icon(
            Icons.search,
            color: textSmoke,
            size: 19.71,
          ),
        ),
      ],
    );
  }

  Widget _renderSearchList() {
    return SizedBox(
      width: double.infinity,
      child: BlueSection(
          child: StyledList(
        stockDataList: recommendStocksList,
        onlySector: true,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _renderTopSection(),
        const SizedBox(height: 32),
        isLoading
            ? const CircularProgress()
            : recommendStocksList.isNotEmpty
                ? _renderSearchList()
                : Container()
      ],
    );
  }
}
