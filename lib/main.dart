import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_market/components/circular_progress.dart';
import 'package:stock_market/components/wrapper.dart';
import 'package:stock_market/core/app_themes.dart';
import 'package:stock_market/core/jwt_provider.dart';
import 'package:stock_market/pages/for_you.dart';
import 'package:stock_market/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stock_market/pages/login.dart';
import 'package:stock_market/pages/onboarding.dart';
import 'package:stock_market/pages/profile.dart';
import 'package:stock_market/pages/search.dart';
import 'package:stock_market/user_auth/generate_token.dart';
import 'core/firebase_options.dart';
import 'package:provider/provider.dart';
import 'core/user_provider.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => JWTProvider()),
    ],
    child: const Main(),
  ));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

Future<bool> _isUserOnboarded(String? token) async {
  String? serverUrl = dotenv.env['SERVER_URL'];

  Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  final response =
      await http.get(Uri.parse('$serverUrl/lookup'), headers: headers);

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

class _MainState extends State<Main> {
  int _selectedPageIndex = 0;
  bool isUserLoading = true;
  bool userOnboarded = false;
  bool isOnboardingLoading = true;

  final List _pages = [
    const HomePage(),
    const ForYou(),
    const Search(),
    const Profile(),
  ];

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.userChanges().listen((User? user) async {
      if (user == null) {
        // user logged out
        _selectedPageIndex = 0;
        userOnboarded = false;
        isOnboardingLoading = true;
        isUserLoading = false;
      }

      Provider.of<UserProvider>(context, listen: false).setUser(user);

      String? token = await generateJWT();

      // ignore: use_build_context_synchronously
      Provider.of<JWTProvider>(context, listen: false).setToken(token);

      if (isUserLoading || user != null) {
        // request
        final onboarded = await _isUserOnboarded(token);

        // ignore: use_build_context_synchronously
        Provider.of<UserProvider>(context, listen: false)
            .setOnboarded(onboarded);

        setState(() {
          if (isUserLoading) {
            isUserLoading = false;
          }

          isOnboardingLoading = false;

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
            icon: Icon(Icons.explore_outlined),
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
    return const Scaffold(body: CircularProgress());
  }

  Widget _onboardingScreen() {
    return const Wrapper(
      child: Onboarding(),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;
    userOnboarded = Provider.of<UserProvider>(context).isOnboarded;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finanso',
      navigatorKey: navigatorKey,
      theme: CommonThemes.appTheme,
      home: isUserLoading
          ? _loadingScreen()
          : user == null
              ? _authScreen()
              : isOnboardingLoading
                  ? _loadingScreen()
                  : !userOnboarded
                      ? _onboardingScreen()
                      : _mainScreen(),
    );
  }
}
