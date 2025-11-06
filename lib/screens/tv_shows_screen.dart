import 'package:flutter/material.dart';
import 'package:locktv/screens/search_screen.dart';
import '../Utils/common.dart';
import '../services/ad_manager.dart';
import '../services/tmdb_api_service.dart';
import '../models/tv_show.dart';
import '../widgets/WorkingNativeAdWidget.dart';
import '../widgets/tv_show_card.dart';
import '../widgets/loading_widget.dart';
import '../utils/animations.dart';

class TVShowsScreen extends StatefulWidget {
  const TVShowsScreen({super.key});

  @override
  State<TVShowsScreen> createState() => _TVShowsScreenState();
}

class _TVShowsScreenState extends State<TVShowsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<TVShow> popularTVShows = [];
  List<TVShow> topRatedTVShows = [];
  List<TVShow> airingTodayTVShows = [];
  List<TVShow> onTheAirTVShows = [];
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
      setState(() {
        isLoading = true;
      });

      // Load data with individual error handling for each request
      final List<Future<Map<String, dynamic>>> futures = [
        TMDBAPIService.discoverTV(sortBy: 'popularity.desc'),
        TMDBAPIService.discoverTV(sortBy: 'vote_average.desc'),
        TMDBAPIService.getTVAiringToday(),
        TMDBAPIService.getTVOnTheAir(),
      ];

      final results = await Future.wait(futures);

      setState(() {
        popularTVShows = (results[0]['results'] as List)
            .map((json) => TVShow.fromJson(json))
            .toList();
        topRatedTVShows = (results[1]['results'] as List)
            .map((json) => TVShow.fromJson(json))
            .toList();
        airingTodayTVShows = (results[2]['results'] as List)
            .map((json) => TVShow.fromJson(json))
            .toList();
        onTheAirTVShows = (results[3]['results'] as List)
            .map((json) => TVShow.fromJson(json))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      // Keep showing loader and retry automatically
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _loadData();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Popular'),
            Tab(text: 'Top Rated'),
            Tab(text: 'Airing Today'),
            Tab(text: 'On The Air'),
          ],
        ),
      ),
      body: _buildBody(),
      floatingActionButton: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: IconButton(
          onPressed: () {
            if (Common.adsopen == "2") {
              Common.openUrl();
            }
            AdManager().showInterstitialAd();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
          icon: Icon(Icons.search, color: Colors.white, size: 30),
        ),
      ),
      bottomNavigationBar: const WorkingNativeAdWidget(),
    );
  }

  Widget _buildBody() {
    // Show loader until data loads successfully
    if (isLoading) {
      return const LoadingWidget();
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildTVShowGrid(popularTVShows),
        _buildTVShowGrid(topRatedTVShows),
        _buildTVShowGrid(airingTodayTVShows),
        _buildTVShowGrid(onTheAirTVShows),
      ],
    );
  }

  Widget _buildTVShowGrid(List<TVShow> tvShows) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: tvShows.length,
        itemBuilder: (context, index) {
          final tvShow = tvShows[index];
          return StaggeredAnimation(
            index: index,
            delay: const Duration(milliseconds: 50),
            child: ScaleAnimation(
              duration: Duration(milliseconds: 300 + (index % 10) * 30),
              child: TVShowCard(
                tvShow: tvShow,
                onTap: () {
                  if (Common.adsopen == "2") {
                    Common.openUrl();
                  }
                  AdManager().showInterstitialAd();
                  Navigator.pushNamed(
                    context,
                    '/tv-details',
                    arguments: tvShow.id,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
