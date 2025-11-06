import 'package:flutter/material.dart';
import 'package:locktv/screens/search_screen.dart';
import '../Utils/common.dart';
import '../services/ad_manager.dart';
import '../services/tmdb_api_service.dart';
import '../models/movie.dart';
import '../widgets/WorkingNativeAdWidget.dart';
import '../widgets/movie_card.dart';
import '../widgets/loading_widget.dart';
import '../utils/animations.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Movie> popularMovies = [];
  List<Movie> topRatedMovies = [];
  List<Movie> nowPlayingMovies = [];
  List<Movie> upcomingMovies = [];
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

      final results = await Future.wait([
        TMDBAPIService.getAllMovies(sortBy: 'popularity.desc'),
        TMDBAPIService.getAllMovies(sortBy: 'vote_average.desc'),
        TMDBAPIService.getAllMovies(sortBy: 'release_date.desc'),
        TMDBAPIService.getAllMovies(sortBy: 'release_date.asc'),
      ]);

      setState(() {
        popularMovies = (results[0]['results'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
        topRatedMovies = (results[1]['results'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
        nowPlayingMovies = (results[2]['results'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
        upcomingMovies = (results[3]['results'] as List)
            .map((json) => Movie.fromJson(json))
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
            Tab(text: 'Now Playing'),
            Tab(text: 'Upcoming'),
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
          icon: Icon(Icons.search, color: Colors.white,size: 30,),
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
        _buildMovieGrid(popularMovies),
        _buildMovieGrid(topRatedMovies),
        _buildMovieGrid(nowPlayingMovies),
        _buildMovieGrid(upcomingMovies),
      ],
    );
  }

  Widget _buildMovieGrid(List<Movie> movies) {
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
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return StaggeredAnimation(
            index: index,
            delay: const Duration(milliseconds: 50),
            child: ScaleAnimation(
              duration: Duration(milliseconds: 300 + (index % 10) * 30),
              child: MovieCard(
                movie: movie,
                onTap: () {
                  if (Common.adsopen == "2") {
                    Common.openUrl();
                  }
                  AdManager().showInterstitialAd();
                  Navigator.pushNamed(
                    context,
                    '/movie-details',
                    arguments: movie.id,
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
