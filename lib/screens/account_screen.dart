import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/tmdb_api_service.dart';
import '../models/account.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';
import '../widgets/loading_widget.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Account? account;
  List<Movie> favoriteMovies = [];
  List<TVShow> favoriteTVShows = [];
  List<Movie> watchlistMovies = [];
  List<TVShow> watchlistTVShows = [];
  List<Movie> ratedMovies = [];
  List<TVShow> ratedTVShows = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
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
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: isLoading
          ? const LoadingWidget()
          : Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () => _openPrivacyPolicy(),
                ),
                const SizedBox(height: 8),
                // Terms & Conditions
                _buildSettingsTile(
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  subtitle: 'Read our terms and conditions',
                  onTap: () => _openTermsAndConditions(),
                ),
                const SizedBox(height: 8),
                // Share App
                _buildSettingsTile(
                  icon: Icons.share_outlined,
                  title: 'Share App',
                  subtitle: 'Share LockTV with friends',
                  onTap: () => _shareApp(),
                ),
                const SizedBox(height: 8),
                // Rate Us
                _buildSettingsTile(
                  icon: Icons.star_outline,
                  title: 'Rate Us',
                  subtitle: 'Rate LockTV on Play Store',
                  onTap: () => _rateApp(),
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _openPrivacyPolicy() {
    // You can replace this with your actual privacy policy URL
    _launchUrl('https://google.com/');
  }

  void _openTermsAndConditions() {
    // You can replace this with your actual terms & conditions URL
    _launchUrl('https://google.com/');
  }

  void _shareApp() {
    try {
      Share.share(
        'Check out LockTV - The best app for discovering movies and TV shows! Download it now.',
        subject: 'LockTV - Movie & TV Show Discovery App',
      );
    } catch (e) {
      // Handle share error gracefully
      print('Share error: $e');
    }
  }

  void _rateApp() {
    // You can replace this with your actual Play Store URL
    _launchUrl('https://play.google.com/store/apps/details?id=com.locktv.app');
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
