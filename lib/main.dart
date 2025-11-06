import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:locktv/services/app_open_ad_manager.dart';
import 'package:locktv/widgets/NativeAdService.dart';
import 'package:locktv/widgets/SmallNativeAdService.dart';
import 'Utils/common.dart';
import 'helper/TrackingPermissionHelper.dart';
import 'screens/splash_screen.dart';
import 'screens/movie_details_screen.dart';
import 'screens/person_details_screen.dart';
import 'screens/tv_show_details_screen.dart';
import 'screens/search_screen.dart';
import 'utils/custom_page_transition.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Request tracking permission with error handling
  try {
    await TrackingPermissionHelper.requestTrackingPermission();
  } catch (e) {
    // Handle errors gracefully - this is expected on Android or when not configured
    print('Tracking permission request failed: $e');
  }

  runApp(const LockTVApp());
}

class LockTVApp extends StatefulWidget with WidgetsBindingObserver {
  const LockTVApp({super.key});

  @override
  State<LockTVApp> createState() => _LockTVAppState();
}

class _LockTVAppState extends State<LockTVApp> with WidgetsBindingObserver {
  final AppOpenAdManager _appOpenAdManager = AppOpenAdManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize native ad service safely
    _initializeAds();
  }

  void _initializeAds() async {
    try {
      // Only initialize ads if they are enabled and IDs are provided
      if (Common.addOnOff && Common.native_ad_id.isNotEmpty) {
        SmallNativeAdService().initialize();
        NativeAdService().initialize();
      } else {
        print('Ads disabled or no ad IDs provided, skipping ad initialization');
      }
    } catch (e) {
      print('Error initializing ads: $e');
      // Continue without ads if initialization fails
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App is going to background
      Common.isAppInBackground = true;
    } else if (state == AppLifecycleState.resumed) {
      // App is resuming from background
      if (!Common.inAppPurchase &&
          Common.addOnOff &&
          Common.isAppInBackground &&
          Common.app_open_ad_id.isNotEmpty) {
        if (!_recentlyShownInterstitial()) {
          try {
            _appOpenAdManager.showAdIfAvailable();
          } catch (e) {
            print('Error showing app open ad: $e');
          }
        }
      }
      // Reset background flag after handling resume
      Common.isAppInBackground = false;
    }
  }

  bool _recentlyShownInterstitial() {
    // Check if recently opened flag is true
    if (Common.recentlyOpened) {
      return true;
    }

    // Check if interstitial ad was shown within the last 15 seconds
    if (Common.lastInterstitialAdTime != null) {
      final timeSinceLastAd = DateTime.now().difference(
        Common.lastInterstitialAdTime!,
      );
      if (timeSinceLastAd.inSeconds < 15) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    return MaterialApp(
      title: 'LockTV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder(),
          },
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF161B22),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF161B22),
          selectedItemColor: Color(0xFF1E88E5),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF21262D),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const SplashScreen(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics), // ✅ track navigation
      ],
      routes: {
        '/movie-details': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          return MovieDetailsScreen(movieId: args as int);
        },
        '/person-details': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          return PersonDetailsScreen(personId: args as int);
        },
        '/tv-details': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          return TVShowDetailsScreen(tvShowId: args as int);
        },
        '/search': (context) => const SearchScreen(),
      },
    );
  }
}
