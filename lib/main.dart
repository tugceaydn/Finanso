import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_market/components/wrapper.dart';
import 'package:stock_market/core/app_themes.dart';
import 'package:stock_market/pages/for_you.dart';
import 'package:stock_market/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stock_market/pages/login.dart';
import 'package:stock_market/pages/profile.dart';
import 'package:stock_market/pages/search.dart';
import 'core/firebase_options.dart';
import 'package:provider/provider.dart';
import 'core/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: const Main(),
  ));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedPageIndex = 0;
  bool isUserLoading = true;

  final List _pages = [
    const HomePage(),
    const ForYou(),
    const Search(),
    const Profile(),
  ];

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        _selectedPageIndex = 0;
        isUserLoading = false;
      }

      Provider.of<UserProvider>(context, listen: false).setUser(user);

      if (isUserLoading || user != null) {
        setState(() {
          if (isUserLoading) {
            isUserLoading = false;
          }

          if (user != null && navigatorKey.currentState!.canPop()) {
            navigatorKey.currentState?.pop();
          }
        });
      }
    });
  }

  Widget _mainScreen() {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: _pages[_selectedPageIndex],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedPageIndex,
        iconSize: 27,
        onTap: (value) {
          setState(() {
            _selectedPageIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home Page',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.search),
            icon: Icon(Icons.search_outlined),
            label: 'For You',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.search),
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _authScreen() {
    return const Wrapper(
      child: LoginPage(),
    );
  }

  Widget _loadingScreen() {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finanso',
      navigatorKey: navigatorKey,
      theme: CommonThemes.appTheme,
      home: isUserLoading
          ? _loadingScreen()
          : user == null
              ? _authScreen()
              : _mainScreen(),
    );
  }
}
