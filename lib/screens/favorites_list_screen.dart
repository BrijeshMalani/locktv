import 'package:flutter/material.dart';
import '../Utils/common.dart';
import '../models/movie.dart';
import '../models/tv_show.dart';
import '../services/ad_manager.dart';
import '../widgets/WorkingNativeAdWidget.dart';
import '../widgets/movie_card.dart';
import '../widgets/tv_show_card.dart';
import '../services/favorites_service.dart';
import '../utils/animations.dart';
import '../widgets/loading_widget.dart';

class FavoritesListScreen extends StatefulWidget {
  final String type; // 'favorites' or 'bookmarks'
  final String mediaType; // 'movies' or 'tv_shows' or 'all'

  const FavoritesListScreen({
    super.key,
    required this.type,
    this.mediaType = 'all',
  });

  @override
  State<FavoritesListScreen> createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Movie> movies = [];
  List<TVShow> tvShows = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final showTabs = widget.mediaType == 'all';
    _tabController = TabController(length: showTabs ? 2 : 1, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (widget.type == 'favorites') {
        if (widget.mediaType == 'movies' || widget.mediaType == 'all') {
          movies = await FavoritesService.getFavoriteMovies();
        }
        if (widget.mediaType == 'tv_shows' || widget.mediaType == 'all') {
          tvShows = await FavoritesService.getFavoriteTVShows();
        }
      } else if (widget.type == 'bookmarks') {
        if (widget.mediaType == 'movies' || widget.mediaType == 'all') {
          movies = await FavoritesService.getBookmarkedMovies();
        }
        if (widget.mediaType == 'tv_shows' || widget.mediaType == 'all') {
          tvShows = await FavoritesService.getBookmarkedTVShows();
        }
      }
    } catch (e) {
      // Handle error
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.type == 'favorites' ? 'Favorites' : 'Bookmarks';
    final showTabs = widget.mediaType == 'all';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        bottom: showTabs
            ? TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Movies'),
                  Tab(text: 'TV Shows'),
                ],
              )
            : null,
      ),
      body: isLoading
          ? const LoadingWidget()
          : showTabs
          ? TabBarView(
              controller: _tabController,
              children: [_buildMoviesGrid(), _buildTVShowsGrid()],
            )
          : widget.mediaType == 'movies'
          ? _buildMoviesGrid()
          : _buildTVShowsGrid(),
      bottomNavigationBar: const WorkingNativeAdWidget(),
    );
  }

  Widget _buildMoviesGrid() {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.type == 'favorites'
                  ? Icons.favorite_border
                  : Icons.bookmark_border,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No ${widget.type == 'favorites' ? 'favorite' : 'bookmarked'} movies yet',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

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

  Widget _buildTVShowsGrid() {
    if (tvShows.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.type == 'favorites'
                  ? Icons.favorite_border
                  : Icons.bookmark_border,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No ${widget.type == 'favorites' ? 'favorite' : 'bookmarked'} TV shows yet',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

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
