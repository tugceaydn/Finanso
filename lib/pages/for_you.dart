import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:stock_market/components/blue_section.dart';
import 'package:stock_market/components/circular_progress.dart';
import 'package:stock_market/components/styled_list.dart';
import 'package:stock_market/components/styled_text.dart';
import 'package:stock_market/core/app_themes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../core/jwt_provider.dart';

class NewsElement {
  String title;
  String date;
  String image;
  String link;
  List<dynamic> tags;
  String publisher;

  NewsElement({
    required this.title,
    required this.date,
    required this.image,
    required this.link,
    required this.tags,
    required this.publisher,
  });

  static NewsElement fromJson(Map<String, dynamic> json) {
    return NewsElement(
      title: json['title'] as String,
      date: json['date'] as String,
      image: json['image'] as String,
      link: json['link'] as String,
      tags: json['tags'] as List<dynamic>,
      publisher: json['publisher'] as String,
    );
  }
}

class ForYou extends StatefulWidget {
  const ForYou({super.key});

  @override
  State<ForYou> createState() => _ForYou();
}

class _ForYou extends State<ForYou> {
  String? serverUrl = dotenv.env['SERVER_URL'];
  String? token;

  bool isRecommendStockListLoading = true;
  bool isNewsLoading = true;

  late Map<String, List<Map<String, dynamic>>> stockList;

  List<Map<String, Object>> recommendStocksList = [];
  List<NewsElement> news = [];

  int _selectedIndex = 0;

  void _sortRecommendedStocks() {
    stockList = {};

    List<Map<String, dynamic>> companies = [];

    for (var company in recommendStocksList) {
      companies.add(company);
    }

    // Sort other companies alphabetically
    companies.sort((a, b) => a['symbol'].compareTo(b['symbol']));

    // Populate the stockList map with companies
    for (var company in companies) {
      var sector = company['sector'];
      if (!stockList.containsKey(sector)) {
        stockList[sector] = [];
      }
      stockList[sector]!.add(company);
    }
  }

  Future<void> _fetchRecommendedStocks() async {
    setState(() {
      isRecommendStockListLoading = true;
    });
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse('$serverUrl/recommend/stocks?amount=20'),
        headers: headers,
      );
      if (!mounted) return;

      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> data = responseData['data'];

      setState(() {
        recommendStocksList =
            data.map((item) => Map<String, Object>.from(item)).toList();
        isRecommendStockListLoading = false;
      });

      _calculateTotalGain();
      _sortRecommendedStocks();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> _fetchNews() async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse('$serverUrl/recommend/news'),
        headers: headers,
      );
      if (!mounted) return;

      Map<String, dynamic> responseData = jsonDecode(response.body);

      List<dynamic> data = responseData['data'];

      setState(() {
        news = data.map((item) => NewsElement.fromJson(item)).toList();
        isNewsLoading = false;
      });
    } catch (error) {
      throw Exception(error);
    }
  }

  void _calculateTotalGain() {
    for (var value in recommendStocksList) {
      Map<String, dynamic>? valueMap = value;
      List<dynamic> gains = _calculateCompanyGain(value);

      value['invested'] = valueMap["price"]["current"];
      value['gain'] = gains[0];
      value['gainPercent'] = gains[1];
    }
  }

  List<double> _calculateCompanyGain(Map<String, dynamic> companyData) {
    double gain =
        companyData["price"]["current"] - companyData["price"]["prev"];
    double percent = (gain / companyData["price"]["prev"]) * 100;

    return [gain, percent];
  }

  @override
  void initState() {
    super.initState();
    token = Provider.of<JWTProvider>(context, listen: false).token;
    _fetchRecommendedStocks();
    _fetchNews();
  }

  Widget _buildTab(String title, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _selectedIndex == index ? primary : Colors.transparent,
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: StyledText(
            text: title,
            color: _selectedIndex == index ? primary : textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _renderNews() {
    return BlueSection(
      padding: 16,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: news.length,
        itemBuilder: (context, index) {
          final newsItem = news[index];
          final bool isFirstItem = index == 0;
          final bool isLastItem = index == news.length - 1;

          return InkWell(
            onTap: () async {
              if (await canLaunchUrl(Uri.parse(newsItem.link))) {
                await launchUrl(Uri.parse(newsItem.link));
              }
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
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledText(
                          text: newsItem.title,
                          color: textPrimary,
                          maximumLines: 2,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            newsItem.tags.length,
                            (tagIndex) {
                              final tag = newsItem.tags[tagIndex];
                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: 8.0,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primarySmoke,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: StyledText(
                                    text: tag,
                                    type: 'small',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 68,
                        width: 68,
                        child: Image.network(
                          newsItem.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _renderStockList() {
    int i = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: stockList.entries.map(
        (e) {
          return i++ % 2 == 0
              ? SizedBox(
                  width: double.infinity,
                  child: BlueSection(
                    padding: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledText(
                          text: e.key,
                          type: 'title_bold',
                        ),
                        const SizedBox(height: 16),
                        StyledList(
                          stockDataList: e.value,
                          onlySector: false,
                          isCurrentPriceIncluded: false,
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    StyledText(
                      text: e.key,
                      type: 'title_bold',
                    ),
                    const SizedBox(height: 16),
                    StyledList(
                      stockDataList: e.value,
                      onlySector: false,
                      isCurrentPriceIncluded: false,
                    ),
                    const SizedBox(height: 16),
                  ],
                );
        },
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StyledText(
          text: 'For You',
          type: 'header',
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTab("News", 0),
            _buildTab("Stocks", 1),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: _selectedIndex == 0
              ? isNewsLoading
                  ? const Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgress(),
                    )
                  : _renderNews()
              : isRecommendStockListLoading
                  ? const Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgress(),
                    )
                  : _renderStockList(),
        ),
      ],
    );
  }
}
