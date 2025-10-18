import 'package:flutter/material.dart';
import '../services/tmdb_api_service.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';
import '../models/person.dart';
import '../widgets/movie_card.dart';
import '../widgets/tv_show_card.dart';
import '../widgets/person_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<Movie> searchMovies = [];
  List<TVShow> searchTVShows = [];
  List<Person> searchPeople = [];
  bool isLoading = false;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        searchMovies.clear();
        searchTVShows.clear();
        searchPeople.clear();
        _currentQuery = '';
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      _currentQuery = query;
    });

    try {
      final results = await Future.wait([
        TMDBAPIService.searchMovies(query: query),
        TMDBAPIService.searchTV(query: query),
        TMDBAPIService.searchPeople(
          query: query,
        ), // Now using proper people search
      ]);

      setState(() {
        searchMovies = (results[0]['results'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
        searchTVShows = (results[1]['results'] as List)
            .map((json) => TVShow.fromJson(json))
            .toList();
        searchPeople = (results[2]['results'] as List)
            .map((json) => Person.fromJson(json))
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
      appBar: AppBar(
        title: const Text('Search'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search movies, TV shows, people...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[800],
                  ),
                  onChanged: (value) {
                    setState(() {});
                    if (value.length > 2) {
                      _performSearch(value);
                    }
                  },
                  onSubmitted: _performSearch,
                ),
              ),
              // Tab Bar
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Movies'),
                  Tab(text: 'TV Shows'),
                  Tab(text: 'People'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _currentQuery.isEmpty
          ? _buildEmptyState()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSearchResults(
                  'Movies',
                  searchMovies,
                  (movie) => Navigator.pushNamed(
                    context,
                    '/movie-details',
                    arguments: movie.id,
                  ),
                ),
                _buildSearchResults(
                  'TV Shows',
                  searchTVShows,
                  (tvShow) => Navigator.pushNamed(
                    context,
                    '/tv-details',
                    arguments: tvShow.id,
                  ),
                ),
                _buildPeopleResults(),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Search for movies, TV shows, and people',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Type at least 3 characters to start searching',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(
    String title,
    List<dynamic> items,
    Function(dynamic) onTap,
  ) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No $title found for "$_currentQuery"',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _performSearch(_currentQuery),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return item is Movie
              ? MovieCard(movie: item, onTap: () => onTap(item))
              : TVShowCard(tvShow: item, onTap: () => onTap(item));
        },
      ),
    );
  }

  Widget _buildPeopleResults() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchPeople.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_search, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No people found for "$_currentQuery"',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _performSearch(_currentQuery),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: searchPeople.length,
        itemBuilder: (context, index) {
          final person = searchPeople[index];
          return PersonCard(
            person: person,
            onTap: () {
              // Navigate to person details
            },
          );
        },
      ),
    );
  }
}
