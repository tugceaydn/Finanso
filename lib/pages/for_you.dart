import 'package:flutter/material.dart';
import 'package:stock_market/components/blue_section.dart';
import 'package:stock_market/components/styled_list.dart';
import 'package:stock_market/components/styled_text.dart';
import 'package:stock_market/core/app_themes.dart';
import 'package:url_launcher/url_launcher.dart';

final List<Map<String, dynamic>> stockDataList = [
  {
    'photoUrl':
        'https://cdn.logojoy.com/wp-content/uploads/20240110153809/Black-tesla-logo-600x600.png',
    'companyTicker': 'FSLA',
    'currentPrice': '\$134.72',
    'invested': '\$500.0',
    'profit': '-\$1,23(+1,1%)',
    'sector': 'Finance',
  },
  {
    'photoUrl':
        'https://cdn.logojoy.com/wp-content/uploads/20240110153809/Black-tesla-logo-600x600.png',
    'companyTicker': 'TAPL',
    'currentPrice': '\$134.72',
    'invested': '\$500.0',
    'profit': '+\$1,23(+1,1%)',
    'sector': 'Technology',
  },
  {
    'photoUrl':
        'https://cdn.logojoy.com/wp-content/uploads/20240110153809/Black-tesla-logo-600x600.png',
    'companyTicker': 'PPL',
    'currentPrice': '\$134.72',
    'invested': '\$500.0',
    'profit': '+\$1,23(+1,1%)',
    'sector': 'Popular',
  },
  {
    'photoUrl':
        'https://cdn.logojoy.com/wp-content/uploads/20240110153809/Black-tesla-logo-600x600.png',
    'companyTicker': 'PLP',
    'currentPrice': '\$134.72',
    'invested': '\$500.0',
    'profit': '+\$1,23(+1,1%)',
    'sector': 'Popular',
  },
  {
    'photoUrl':
        'https://cdn.logojoy.com/wp-content/uploads/20240110153809/Black-tesla-logo-600x600.png',
    'companyTicker': 'TCH',
    'currentPrice': '\$134.72',
    'invested': '\$500.0',
    'profit': '+\$1,23(+1,1%)',
    'sector': 'Technology',
  },
  {
    'photoUrl':
        'https://cdn.logojoy.com/wp-content/uploads/20240110153809/Black-tesla-logo-600x600.png',
    'companyTicker': 'FTCH',
    'currentPrice': '\$134.72',
    'invested': '\$500.0',
    'profit': '+\$1,23(+1,1%)',
    'sector': 'Finance',
  },
];

final List<dynamic> newsList = [
  {
    'id': 0,
    'url': 'https://engoo.com.tr/app/daily-news',
    'title': 'News Title',
    'description': 'news description bla bla news description bla bla',
    'tags': ['Tag1', 'Technology'],
    'photoUrl':
        'https://media.istockphoto.com/id/1369150014/tr/vekt%C3%B6r/breaking-news-with-world-map-background-vector.jpg?s=612x612&w=0&k=20&c=6hT8qh1fKffE63gJmQ-KFrJ4CZ4of0zKuJ2Ip6t5bfo=',
  },
  {
    'id': 1,
    'url': 'https://engoo.com.tr/app/daily-news',
    'title': 'News Title',
    'description': 'news description bla bla news description bla bla',
    'tags': ['Tag1', 'Technology'],
    'photoUrl':
        'https://media.istockphoto.com/id/1369150014/tr/vekt%C3%B6r/breaking-news-with-world-map-background-vector.jpg?s=612x612&w=0&k=20&c=6hT8qh1fKffE63gJmQ-KFrJ4CZ4of0zKuJ2Ip6t5bfo=',
  },
  {
    'id': 2,
    'url': 'https://engoo.com.tr/app/daily-news',
    'title': 'News Title',
    'description': 'news description bla bla news description bla bla',
    'tags': ['Tag1', 'Technology'],
    'photoUrl':
        'https://media.istockphoto.com/id/1369150014/tr/vekt%C3%B6r/breaking-news-with-world-map-background-vector.jpg?s=612x612&w=0&k=20&c=6hT8qh1fKffE63gJmQ-KFrJ4CZ4of0zKuJ2Ip6t5bfo=',
  },
  {
    'id': 3,
    'url': 'https://engoo.com.tr/app/daily-news',
    'title': 'News Title',
    'description': 'news description bla bla news description bla bla',
    'tags': ['Tag1', 'Technology'],
    'photoUrl':
        'https://media.istockphoto.com/id/1369150014/tr/vekt%C3%B6r/breaking-news-with-world-map-background-vector.jpg?s=612x612&w=0&k=20&c=6hT8qh1fKffE63gJmQ-KFrJ4CZ4of0zKuJ2Ip6t5bfo=',
  },
  {
    'id': 4,
    'url': 'https://engoo.com.tr/app/daily-news',
    'title': 'News Title',
    'description': 'news description bla bla news description bla bla',
    'tags': ['Tag1', 'Technology'],
    'photoUrl':
        'https://media.istockphoto.com/id/1369150014/tr/vekt%C3%B6r/breaking-news-with-world-map-background-vector.jpg?s=612x612&w=0&k=20&c=6hT8qh1fKffE63gJmQ-KFrJ4CZ4of0zKuJ2Ip6t5bfo=',
  },
  {
    'id': 5,
    'url': 'https://engoo.com.tr/app/daily-news',
    'title': 'News Title',
    'description': 'news description bla bla news description bla bla',
    'tags': ['Tag1', 'Technology'],
    'photoUrl':
        'https://media.istockphoto.com/id/1369150014/tr/vekt%C3%B6r/breaking-news-with-world-map-background-vector.jpg?s=612x612&w=0&k=20&c=6hT8qh1fKffE63gJmQ-KFrJ4CZ4of0zKuJ2Ip6t5bfo=',
  },
  {
    'id': 6,
    'url': 'https://engoo.com.tr/app/daily-news',
    'title': 'News Title',
    'description': 'news description bla bla news description bla bla',
    'tags': ['Tag1', 'Technology'],
    'photoUrl':
        'https://media.istockphoto.com/id/1369150014/tr/vekt%C3%B6r/breaking-news-with-world-map-background-vector.jpg?s=612x612&w=0&k=20&c=6hT8qh1fKffE63gJmQ-KFrJ4CZ4of0zKuJ2Ip6t5bfo=',
  },
  {
    'id': 7,
    'url': 'https://engoo.com.tr/app/daily-news',
    'title': 'News Title',
    'description': 'news description bla bla news description bla bla',
    'tags': ['Tag1', 'Technology'],
    'photoUrl':
        'https://media.istockphoto.com/id/1369150014/tr/vekt%C3%B6r/breaking-news-with-world-map-background-vector.jpg?s=612x612&w=0&k=20&c=6hT8qh1fKffE63gJmQ-KFrJ4CZ4of0zKuJ2Ip6t5bfo=',
  },
  {
    'id': 8,
    'url': 'https://engoo.com.tr/app/daily-news',
    'title': 'News Title',
    'description': 'news description bla bla news description bla bla',
    'tags': ['Tag1', 'Technology'],
    'photoUrl':
        'https://media.istockphoto.com/id/1369150014/tr/vekt%C3%B6r/breaking-news-with-world-map-background-vector.jpg?s=612x612&w=0&k=20&c=6hT8qh1fKffE63gJmQ-KFrJ4CZ4of0zKuJ2Ip6t5bfo=',
  },
  {
    'id': 9,
    'url': 'https://engoo.com.tr/app/daily-news',
    'title': 'News Title',
    'description': 'news description bla bla news description bla bla',
    'tags': ['Tag1', 'Technology'],
    'photoUrl':
        'https://media.istockphoto.com/id/1369150014/tr/vekt%C3%B6r/breaking-news-with-world-map-background-vector.jpg?s=612x612&w=0&k=20&c=6hT8qh1fKffE63gJmQ-KFrJ4CZ4of0zKuJ2Ip6t5bfo=',
  },
];

class ForYou extends StatefulWidget {
  const ForYou({super.key});

  State<ForYou> createState() => _ForYou();
}

class _ForYou extends State<ForYou> {
  late Map<String, List<Map<String, dynamic>>> stockList;
  int _selectedIndex = 0;

  void sortList() {
    stockList = {};

    // Separate popular companies from others
    List<Map<String, dynamic>> popularCompanies = [];
    List<Map<String, dynamic>> otherCompanies = [];

    for (var company in stockDataList) {
      if (company['sector'] == 'Popular') {
        popularCompanies.add(company);
      } else {
        otherCompanies.add(company);
      }
    }

    // Sort other companies alphabetically
    otherCompanies
        .sort((a, b) => a['companyTicker'].compareTo(b['companyTicker']));

    // Update the stockList map
    stockList['Popular'] = popularCompanies;

    // Populate the stockList map with companies
    for (var company in otherCompanies) {
      var sector = company['sector'];
      if (!stockList.containsKey(sector)) {
        stockList[sector] = [];
      }
      stockList[sector]!.add(company);
    }
  }

  @override
  void initState() {
    sortList();
    super.initState();
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
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          final newsItem = newsList[index];
          final bool isFirstItem = index == 0;
          final bool isLastItem = index == newsList.length - 1;

          return InkWell(
            onTap: () async {
              if (await canLaunchUrl(Uri.parse(newsItem['url']))) {
                await launchUrl(
                  Uri.parse(newsItem['url']),
                  mode: LaunchMode.externalApplication,
                );
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
                          text: newsItem['title'],
                          color: textPrimary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          newsItem['description'],
                          style: const TextStyle(
                            fontFamily: 'San Francisco',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            height: 1.25,
                            overflow: TextOverflow.ellipsis,
                            color: textSmoke,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            newsItem['tags'].length,
                            (tagIndex) {
                              final tag = newsItem['tags'][tagIndex];
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
                          newsItem['photoUrl'],
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
              ? BlueSection(
                  padding: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StyledText(
                        text: e.key,
                        type: 'title_bold',
                      ),
                      const SizedBox(height: 16),
                      StyledList(stockDataList: e.value),
                    ],
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
                    StyledList(stockDataList: e.value),
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
        Container(
          child: _selectedIndex == 0 ? _renderNews() : _renderStockList(),
        ),
      ],
    );
  }
}
