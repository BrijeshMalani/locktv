import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/common.dart';
import '../services/ad_manager.dart';
import '../services/api_service.dart';
import '../services/app_open_ad_manager.dart';
import '../utils/initialization_helper.dart';
import '../widgets/NativeAdService.dart';
import '../widgets/SmallNativeAdService.dart';
import 'main_navigation.dart';
import 'intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  final _initializationHelper = InitializationHelper();

  Future<void> _initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializationHelper.initialize();
    });
  }

  final AppOpenAdManager _appOpenAdManager = AppOpenAdManager();

  @override
  void initState() {
    super.initState();
    _initialize();
    setupRemoteConfig();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Scale animation
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Rotation animation (subtle)
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    // Start animation
    _controller.forward();

    // Navigate to intro or main screen after animation completes
    Timer(const Duration(milliseconds: 2500), () {
      _checkIntroStatus();
    });
  }

  Future<void> _checkIntroStatus() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final introCompleted = prefs.getBool('intro_completed') ?? false;

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              introCompleted ? const MainNavigation() : const IntroScreen(),
          transitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> setupRemoteConfig() async {
    try {
      final data = await AppDataService.fetchAppData();
      print('API Response: $data');

      if (data != null) {
        if (data.rewardedFull.isNotEmpty) {
          print('Setting privacy policy: ${data.rewardedFull}');
          Common.privacy_policy = data.rewardedFull;
        }
        if (data.rewardedFull2.isNotEmpty) {
          print('Setting terms and conditions: ${data.rewardedFull2}');
          Common.terms_conditions = data.rewardedFull2;
        }
        if (data.startAppFull.isNotEmpty) {
          print('Setting playstore link: ${data.startAppFull}');
          Common.playstore_link = data.startAppFull;
        }
        if (data.gamezopId.isNotEmpty) {
          print('Interstitial show count: ${data.gamezopId}');
          Common.ads_int_open_count = int.parse(data.gamezopId);
        }
        if (data.rewardedFull1.isNotEmpty) {
          print('Ads Open Count: ${data.rewardedFull1}');
          // Common.ads_open_count = data.rewardedFull1;
        }
        if (data.startAppNative.isNotEmpty) {
          print('video show: ${data.startAppNative}');
          Common.showvideos = data.startAppNative;
        }
        if (data.startAppId.isNotEmpty) {
          print('Ads Open qreka Count: ${data.startAppId}');
          Common.ads_open_qreka_count = data.startAppId;
        }
        if (data.startAppRewarded.isNotEmpty) {
          print('Ads open area: ${data.startAppRewarded}');
          Common.adsopen = data.startAppRewarded;
        }

        if (data.qurekaId.isNotEmpty) {
          print('qureka link: ${data.qurekaId}');
          Common.Qurekaid = data.qurekaId;
        }
        if (data.fbFull.isNotEmpty) {
          print('Apple app bundle Id: ${data.fbFull}');
          Common.appBundleId = data.fbFull;
        }
        //Google ads
        if (data.admobId.isNotEmpty) {
          print('Setting banner ad ID: ${data.admobId}');
          Common.bannar_ad_id = data.admobId;
          // Common.bannar_ad_id = "ca-app-pub-3940256099942544/6300978111";
        }
        if (data.admobFull.isNotEmpty) {
          print('Setting interstitial ad ID: ${data.admobFull}');
          Common.interstitial_ad_id = data.admobFull;
          // Common.interstitial_ad_id = "ca-app-pub-3940256099942544/1033173712";
        }
        if (data.admobFull1.isNotEmpty) {
          print('Setting interstitial ad ID1: ${data.admobFull1}');
          Common.interstitial_ad_id1 = data.admobFull1;
          // Common.interstitial_ad_id1 = "ca-app-pub-3940256099942544/1033173712";
        }
        if (data.admobFull2.isNotEmpty) {
          print('Setting interstitial ad ID2: ${data.admobFull2}');
          Common.interstitial_ad_id2 = data.admobFull2;
        }
        if (data.admobNative.isNotEmpty) {
          print('Setting native ad ID: ${data.admobNative}');
          Common.native_ad_id = data.admobNative;
          // Common.native_ad_id = "ca-app-pub-3940256099942544/2247696110";
        }
        if (data.rewardedInt.isNotEmpty) {
          print('Setting app open ad ID: ${data.rewardedInt}');
          Common.app_open_ad_id = data.rewardedInt;
          // Common.app_open_ad_id = "ca-app-pub-3940256099942544/9257395921";
        }
      }

      // Initialize Mobile Ads SDK
      try {
        await MobileAds.instance.initialize();
        print('MobileAds initialized successfully in splash screen');
      } catch (e) {
        print('Error initializing MobileAds in splash screen: $e');
      }

      Common.addOnOff = true;

      try {
        // Initialize only the necessary ad services
        AdManager().initialize();
        SmallNativeAdService().initialize();
        NativeAdService().initialize();
        _appOpenAdManager.loadAd();
      } catch (e) {
        print('Error initializing ad services: $e');
      }
    } catch (e) {
      print('Error in setupRemoteConfig: $e');
      // Initialize MobileAds even if API fails
      try {
        await MobileAds.instance.initialize();
      } catch (initError) {
        print('Error initializing MobileAds after API failure: $initError');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0D1117),
              const Color(0xFF161B22),
              const Color(0xFF1E88E5).withValues(alpha: 0.3),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with glow effect
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF1E88E5,
                                ).withOpacity(0.5 * _fadeAnimation.value),
                                blurRadius: 50,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Icon(Icons.movie,size: 60,color: Colors.pinkAccent,)
                        ),
                        const SizedBox(height: 30),
                        // App Name with fade animation
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              const Text(
                                'Loklok TV',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: 100,
                                height: 3,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF1E88E5),
                                      const Color(
                                        0xFF1E88E5,
                                      ).withValues(alpha: 0.0),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        // Loading indicator
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color(0xFF1E88E5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
