import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';
import 'dart:io' show Platform;
import 'package:cached_network_image/cached_network_image.dart';
import '../services/tmdb_api_service.dart';
import '../models/account.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';
import '../utils/common.dart';
import '../widgets/WorkingNativeAdWidget.dart';
import '../widgets/loading_widget.dart';
import '../utils/animations.dart';
import 'webview_screen.dart';
import 'favorites_list_screen.dart';
import '../services/favorites_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  Account? account;
  List<Movie> favoriteMovies = [];
  List<TVShow> favoriteTVShows = [];
  List<Movie> watchlistMovies = [];
  List<TVShow> watchlistTVShows = [];
  List<Movie> ratedMovies = [];
  List<TVShow> ratedTVShows = [];
  bool isLoading = true;

  late AnimationController _headerAnimationController;
  late AnimationController _statsAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _statsScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadData();
  }

  void _initAnimations() {
    _headerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _statsAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _headerAnimationController,
            curve: Curves.easeOut,
          ),
        );

    _statsScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _statsAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _statsAnimationController.forward();
    });
  }

  List<SettingsItem> get _settingsItems => [
    SettingsItem(
      icon: Icons.privacy_tip_outlined,
      title: 'Privacy Policy',
      subtitle: 'Read our privacy policy',
      color: Colors.purple,
      onTap: () => _openPrivacyPolicy(),
    ),
    SettingsItem(
      icon: Icons.description_outlined,
      title: 'Terms & Conditions',
      subtitle: 'Read our terms and conditions',
      color: Colors.blue,
      onTap: () => _openTermsAndConditions(),
    ),
    SettingsItem(
      icon: Icons.share_outlined,
      title: 'Share App',
      subtitle: 'Share LokTV with friends',
      color: Colors.green,
      onTap: () => _shareApp(),
    ),
    SettingsItem(
      icon: Icons.star_outline,
      title: 'Rate Us',
      subtitle: 'Rate LokTV on Play Store',
      color: Colors.orange,
      onTap: () => _rateApp(),
    ),
  ];

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _statsAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      // Load local favorites and bookmarks
      final localFavorites = await Future.wait([
        FavoritesService.getFavoriteMovies(),
        FavoritesService.getFavoriteTVShows(),
      ]);
      final localBookmarks = await Future.wait([
        FavoritesService.getBookmarkedMovies(),
        FavoritesService.getBookmarkedTVShows(),
      ]);

      // Try to load TMDB account data (may fail if not authenticated)
      try {
        final results = await Future.wait([
          TMDBAPIService.getAccountDetails(),
          TMDBAPIService.getFavoriteMovies(),
          TMDBAPIService.getFavoriteTV(),
          TMDBAPIService.getWatchlistMovies(),
          TMDBAPIService.getWatchlistTV(),
          TMDBAPIService.getRatedMovies(),
          TMDBAPIService.getRatedTV(),
        ]);

        setState(() {
          account = Account.fromJson(results[0]);
          favoriteMovies = (results[1]['results'] as List)
              .map((json) => Movie.fromJson(json))
              .toList();
          favoriteTVShows = (results[2]['results'] as List)
              .map((json) => TVShow.fromJson(json))
              .toList();
          watchlistMovies = (results[3]['results'] as List)
              .map((json) => Movie.fromJson(json))
              .toList();
          watchlistTVShows = (results[4]['results'] as List)
              .map((json) => TVShow.fromJson(json))
              .toList();
          ratedMovies = (results[5]['results'] as List)
              .map((json) => Movie.fromJson(json))
              .toList();
          ratedTVShows = (results[6]['results'] as List)
              .map((json) => TVShow.fromJson(json))
              .toList();
          isLoading = false;
        });
      } catch (e) {
        // If TMDB fails, use local data only
        setState(() {
          favoriteMovies = localFavorites[0] as List<Movie>;
          favoriteTVShows = localFavorites[1] as List<TVShow>;
          watchlistMovies = localBookmarks[0] as List<Movie>;
          watchlistTVShows = localBookmarks[1] as List<TVShow>;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: isLoading
          ? const LoadingWidget()
          : CustomScrollView(
              slivers: [
                // Custom App Bar with Gradient
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: colorScheme.primary,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    centerTitle: true,
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primary,
                            colorScheme.secondary,
                            colorScheme.tertiary,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // User Profile Header
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _headerFadeAnimation,
                    child: SlideTransition(
                      position: _headerSlideAnimation,
                      child: _buildProfileHeader(),
                    ),
                  ),
                ),
                // Statistics Section
                SliverToBoxAdapter(
                  child: ScaleTransition(
                    scale: _statsScaleAnimation,
                    child: _buildStatisticsSection(),
                  ),
                ),
                // Settings Section
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: StaggeredAnimation(
                          index: index,
                          child: _buildSettingsTile(
                            icon: _settingsItems[index].icon,
                            title: _settingsItems[index].title,
                            subtitle: _settingsItems[index].subtitle,
                            color: _settingsItems[index].color,
                            onTap: _settingsItems[index].onTap,
                          ),
                        ),
                      );
                    }, childCount: _settingsItems.length),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
      bottomNavigationBar: const WorkingNativeAdWidget(),
    );
  }

  Widget _buildProfileHeader() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          ScaleAnimation(
            duration: const Duration(milliseconds: 600),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: account?.avatarPath != null
                    ? CachedNetworkImage(
                        imageUrl: account!.avatarUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.person, size: 40, color: Colors.white),
                      )
                    : Icon(Icons.person, size: 40, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account?.name ?? 'Loc Tv',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${account?.username ?? 'loktv123'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final stats = [
      {
        'label': 'Favorites',
        'count': (favoriteMovies.length + favoriteTVShows.length).toString(),
        'icon': Icons.favorite,
        'color': Colors.red,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FavoritesListScreen(
                type: 'favorites',
                mediaType: 'all',
              ),
            ),
          );
        },
      },
      {
        'label': 'Bookmarks',
        'count': (watchlistMovies.length + watchlistTVShows.length).toString(),
        'icon': Icons.bookmark,
        'color': Colors.blue,
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FavoritesListScreen(
                type: 'bookmarks',
                mediaType: 'all',
              ),
            ),
          );
        },
      },
      {
        'label': 'Rated',
        'count': (ratedMovies.length + ratedTVShows.length).toString(),
        'icon': Icons.star,
        'color': Colors.amber,
        'onTap': () {
          // Navigate to rated items if needed
        },
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: stats.map((stat) {
          final index = stats.indexOf(stat);
          return Expanded(
            child: StaggeredAnimation(
              index: index,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: stat['onTap'] as VoidCallback?,
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: index < stats.length - 1 ? 8.0 : 0,
                    ),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: (stat['color'] as Color).withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: (stat['color'] as Color).withValues(
                              alpha: 0.1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            stat['icon'] as IconData,
                            color: stat['color'] as Color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          stat['count'] as String,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: stat['color'] as Color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stat['label'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
        ),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openPrivacyPolicy() {
    // You can replace this with your actual privacy policy URL
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: Common.privacy_policy == ""
              ? 'https://google.com/'
              : Common.privacy_policy,
          // Replace with your privacy policy URL
          title: 'Privacy Policy',
        ),
      ),
    );
  }

  void _openTermsAndConditions() {
    // You can replace this with your actual terms & conditions URL
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: Common.terms_conditions == ""
              ? 'https://google.com/'
              : Common.terms_conditions,
          // Replace with your terms & conditions URL
          title: 'Terms & Conditions',
        ),
      ),
    );
  }

  Future<void> _shareApp() async {
    try {
      final String text =
          'Check out LokTV - The best app for discovering movies and TV shows! Download it now.';
      final String subject = 'LokTV - Movie & TV Show Discovery App';

      final box = context.findRenderObject() as RenderBox?;

      if (Platform.isIOS) {
        await Share.share(
          text,
          subject: subject,
          sharePositionOrigin:
              box!.localToGlobal(Offset.zero) & box.size, // ✅ iPad fix
        );
      } else {
        await Share.share(text, subject: subject);
      }
    } catch (e) {
      print('Share error: $e');
    }
  }

  Future<void> _rateApp() async {
    try {
      final InAppReview inAppReview = InAppReview.instance;

      // Check if in-app review is available
      if (await inAppReview.isAvailable()) {
        // Show native in-app review dialog (iOS App Store / Google Play)
        await inAppReview.requestReview();
      } else {
        // Fallback to opening store page
        if (Platform.isIOS) {
          // iOS App Store URL - replace with your actual app ID
          await _launchUrl(
            Common.playstore_link == ""
                ? 'https://apps.apple.com/app/id1234567890'
                : Common.playstore_link,
          ); // Replace with your App Store ID
        } else {
          // Android Play Store URL - replace with your actual package name
          await _launchUrl(
            Common.playstore_link == ""
                ? 'https://play.google.com/store/apps/details?id=com.locktv.app'
                : Common.playstore_link,
          );
        }
      }
    } catch (e) {
      // Handle error gracefully
      print('Rate app error: $e');
      // Fallback to opening store page
      if (Platform.isIOS) {
        await _launchUrl(
          Common.playstore_link == ""
              ? 'https://apps.apple.com/app/id1234567890'
              : Common.playstore_link,
        ); // Replace with your App Store ID
      } else {
        await _launchUrl(
          Common.playstore_link == ""
              ? 'https://play.google.com/store/apps/details?id=com.locktv.app'
              : Common.playstore_link,
        );
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      // Direct launch without canLaunchUrl check to avoid channel errors
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Handle URL launch error gracefully
      print('URL launch error: $e');
      // You could show a snackbar or dialog here if needed
    }
  }
}

class SettingsItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}
