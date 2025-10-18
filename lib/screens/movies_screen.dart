import 'package:flutter/material.dart';
import '../services/tmdb_api_service.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import '../widgets/loading_widget.dart';

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
        title: const Text('Movies'),
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
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return MovieCard(
            movie: movie,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/movie-details',
                arguments: movie.id,
              );
            },
          );
        },
      ),
    );
  }
}
