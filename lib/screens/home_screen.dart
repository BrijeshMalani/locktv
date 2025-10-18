import 'package:flutter/material.dart';
import '../services/tmdb_api_service.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';
import '../models/person.dart';
import '../widgets/movie_card.dart';
import '../widgets/tv_show_card.dart';
import '../widgets/person_card.dart';
import '../widgets/trending_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> trendingMovies = [];
  List<TVShow> trendingTVShows = [];
  List<Person> trendingPeople = [];
  List<Movie> popularMovies = [];
  List<TVShow> popularTVShows = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final results = await Future.wait([
        TMDBAPIService.getTrendingMovies(),
        TMDBAPIService.getTrendingTV(),
        TMDBAPIService.getTrendingPeople(),
        TMDBAPIService.getAllMovies(),
        TMDBAPIService.getAllSeries(),
      ]);

      setState(() {
        trendingMovies = (results[0]['results'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
        trendingTVShows = (results[1]['results'] as List)
            .map((json) => TVShow.fromJson(json))
            .toList();
        trendingPeople = (results[2]['results'] as List)
            .map((json) => Person.fromJson(json))
            .toList();
        popularMovies = (results[3]['results'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
        popularTVShows = (results[4]['results'] as List)
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
        title: const Text('LockTV'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Show loader until data loads successfully
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trending Movies Carousel
            if (trendingMovies.isNotEmpty)
              TrendingCarousel(
                title: 'Trending Movies',
                items: trendingMovies,
                onItemTap: (movie) {
                  Navigator.pushNamed(
                    context,
                    '/movie-details',
                    arguments: movie.id,
                  );
                },
              ),

            const SizedBox(height: 20),

            // Popular Movies
            if (popularMovies.isNotEmpty)
              _buildSection(
                'Popular Movies',
                popularMovies,
                (movie) => Navigator.pushNamed(
                  context,
                  '/movie-details',
                  arguments: movie.id,
                ),
              ),

            const SizedBox(height: 20),

            // Popular TV Shows
            if (popularTVShows.isNotEmpty)
              _buildSection(
                'Popular TV Shows',
                popularTVShows,
                (tvShow) => Navigator.pushNamed(
                  context,
                  '/tv-details',
                  arguments: tvShow.id,
                ),
              ),

            const SizedBox(height: 20),

            // Trending People
            if (trendingPeople.isNotEmpty) _buildPeopleSection(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    List<dynamic> items,
    Function(dynamic) onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: item is Movie
                    ? MovieCard(movie: item, onTap: () => onTap(item))
                    : TVShowCard(tvShow: item, onTap: () => onTap(item)),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPeopleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Trending People',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: trendingPeople.length,
            itemBuilder: (context, index) {
              final person = trendingPeople[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: PersonCard(
                  person: person,
                  onTap: () {
                    // Navigate to person details
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
