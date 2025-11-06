import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:intl/intl.dart';
import '../services/tmdb_api_service.dart';
import '../models/movie.dart';
import '../widgets/WorkingNativeAdWidget.dart';
import '../widgets/movie_card.dart';
import '../widgets/loading_widget.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  MovieDetails? movieDetails;
  bool isLoading = true;
  bool isLoadingMore = false;
  int _currentVideoIndex = -1;
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _loadMovieDetails();
  }

  Future<void> _loadMovieDetails() async {
    try {
      setState(() {
        isLoading = true;
      });

      final results = await Future.wait([
        TMDBAPIService.getMovieDetails(movieId: widget.movieId.toString()),
        TMDBAPIService.getMovieCredits(movieId: widget.movieId.toString()),
        TMDBAPIService.getMovieVideos(movieId: widget.movieId.toString()),
        TMDBAPIService.getMovieImages(movieId: widget.movieId.toString()),
        TMDBAPIService.getSimilarMovies(movieId: widget.movieId.toString()),
        TMDBAPIService.getMovieRecommendations(
          movieId: widget.movieId.toString(),
        ),
        TMDBAPIService.getMovieReviews(movieId: widget.movieId.toString()),
        TMDBAPIService.getMovieWatchProviders(
          movieId: widget.movieId.toString(),
        ),
      ]);

      // Combine all data into a single JSON object
      final combinedData = {
        ...results[0],
        'credits': results[1],
        'videos': results[2],
        'images': results[3],
        'similar': results[4],
        'recommendations': results[5],
        'reviews': results[6],
        'watch_providers': results[7], // API returns {id: ..., results: {...}}
      };

      setState(() {
        movieDetails = MovieDetails.fromJson(combinedData);
        isLoading = false;
      });
    } catch (e) {
      // Keep showing loader and retry automatically
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _loadMovieDetails();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const LoadingWidget()
          : movieDetails == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMovieHeader(),
                      _buildMovieInfo(),
                      _buildOverview(),
                      _buildTrailers(),
                      _buildCast(),
                      _buildCrew(),
                      _buildImages(),
                      _buildWatchProviders(),
                      _buildSimilarMovies(),
                      _buildRecommendations(),
                      _buildReviews(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const WorkingNativeAdWidget(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: movieDetails!.backdropUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: Container(color: Colors.grey[800]),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[800],
                child: const Icon(Icons.movie, color: Colors.grey, size: 50),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildMovieHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: movieDetails!.posterUrl,
              width: 120,
              height: 180,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: Container(
                  width: 120,
                  height: 180,
                  color: Colors.grey[800],
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 120,
                height: 180,
                color: Colors.grey[800],
                child: const Icon(Icons.movie, color: Colors.grey, size: 50),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Title and Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movieDetails!.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                if (movieDetails!.tagline.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    movieDetails!.tagline,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      movieDetails!.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${movieDetails!.voteCount} votes)',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${movieDetails!.year} • ${_formatRuntime()} • ${_getGenres()}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          if (movieDetails!.runtime > 0)
            _buildInfoChip(Icons.access_time, '${movieDetails!.runtime} min'),
          if (movieDetails!.budget > 0)
            _buildInfoChip(
              Icons.attach_money,
              _formatCurrency(movieDetails!.budget),
            ),
          if (movieDetails!.revenue > 0)
            _buildInfoChip(
              Icons.trending_up,
              _formatCurrency(movieDetails!.revenue),
            ),
          if (movieDetails!.status.isNotEmpty)
            _buildInfoChip(Icons.info_outline, movieDetails!.status),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.blue),
      label: Text(text, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.grey[800],
      labelStyle: const TextStyle(color: Colors.white70),
    );
  }

  Widget _buildOverview() {
    if (movieDetails!.overview.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movieDetails!.overview,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailers() {
    final trailers = movieDetails!.videos
        .where(
          (v) =>
              v.site == 'YouTube' &&
              (v.type == 'Trailer' || v.type == 'Teaser'),
        )
        .toList();

    if (trailers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Trailers & Videos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: trailers.length,
            itemBuilder: (context, index) {
              final video = trailers[index];
              final isSelected = _currentVideoIndex == index;
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: isSelected && _webViewController != null
                                ? WebViewWidget(controller: _webViewController!)
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              'https://img.youtube.com/vi/${video.key}/hqdefault.jpg',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                color: Colors.grey[800],
                                                child: const Icon(
                                                  Icons.play_circle_outline,
                                                  size: 50,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.play_circle_filled,
                                          size: 60,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                          if (isSelected)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _currentVideoIndex = -1;
                                    _webViewController = null;
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      video.name,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _currentVideoIndex = index;
                          _webViewController = WebViewController()
                            ..setJavaScriptMode(JavaScriptMode.unrestricted)
                            ..setBackgroundColor(Colors.black)
                            ..loadRequest(
                              Uri.parse(
                                'https://www.youtube.com/embed/${video.key}?autoplay=1',
                              ),
                            );
                        });
                      },
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: const Text('Play'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCast() {
    if (movieDetails!.cast.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Cast',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movieDetails!.cast.length,
            itemBuilder: (context, index) {
              final cast = movieDetails!.cast[index];
              return Container(
                width: 120,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: cast.profileUrl,
                        width: 120,
                        height: 150,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[800]!,
                          highlightColor: Colors.grey[700]!,
                          child: Container(
                            width: 120,
                            height: 150,
                            color: Colors.grey[800],
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 120,
                          height: 150,
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cast.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      cast.character,
                      style: TextStyle(color: Colors.grey[400], fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCrew() {
    final directors = movieDetails!.crew
        .where((c) => c.job == 'Director')
        .take(3)
        .toList();
    final writers = movieDetails!.crew
        .where((c) => c.job == 'Writer' || c.job == 'Screenplay')
        .take(3)
        .toList();

    if (directors.isEmpty && writers.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (directors.isNotEmpty) ...[
            Text(
              'Director${directors.length > 1 ? 's' : ''}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: directors.map((director) {
                return Chip(
                  label: Text(director.name),
                  backgroundColor: Colors.grey[800],
                  labelStyle: const TextStyle(color: Colors.white70),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          if (writers.isNotEmpty) ...[
            Text(
              'Writer${writers.length > 1 ? 's' : ''}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: writers.map((writer) {
                return Chip(
                  label: Text(writer.name),
                  backgroundColor: Colors.grey[800],
                  labelStyle: const TextStyle(color: Colors.white70),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImages() {
    if (movieDetails!.images.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Images',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movieDetails!.images.length,
            itemBuilder: (context, index) {
              final image = movieDetails!.images[index];
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: image.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: Container(color: Colors.grey[800]),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildWatchProviders() {
    if (movieDetails!.watchProviders == null ||
        movieDetails!.watchProviders!.results.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get providers for US region (you can customize this)
    final usProviders = movieDetails!.watchProviders!.results['US'];
    if (usProviders == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Watch Providers',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          if (usProviders.flatrate.isNotEmpty) ...[
            const Text(
              'Stream',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: usProviders.flatrate.map((provider) {
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: provider.logoUrl,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => Center(
                        child: Text(
                          provider.providerName.substring(0, 1),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          if (usProviders.rent.isNotEmpty) ...[
            const Text(
              'Rent',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: usProviders.rent.map((provider) {
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: provider.logoUrl,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => Center(
                        child: Text(
                          provider.providerName.substring(0, 1),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          if (usProviders.buy.isNotEmpty) ...[
            const Text(
              'Buy',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: usProviders.buy.map((provider) {
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: provider.logoUrl,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => Center(
                        child: Text(
                          provider.providerName.substring(0, 1),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSimilarMovies() {
    if (movieDetails!.similar.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Similar Movies',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movieDetails!.similar.length,
            itemBuilder: (context, index) {
              final movie = movieDetails!.similar[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: MovieCard(
                  movie: movie,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailsScreen(movieId: movie.id),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRecommendations() {
    if (movieDetails!.recommendations.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Recommendations',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movieDetails!.recommendations.length,
            itemBuilder: (context, index) {
              final movie = movieDetails!.recommendations[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: MovieCard(
                  movie: movie,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailsScreen(movieId: movie.id),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildReviews() {
    if (movieDetails!.reviews.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reviews',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ...movieDetails!.reviews.take(5).map((review) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage:
                              review.authorDetails.avatarPath != null
                              ? CachedNetworkImageProvider(
                                  review.authorDetails.avatarUrl,
                                )
                              : null,
                          child: review.authorDetails.avatarPath == null
                              ? Text(
                                  review.authorDetails.name.isNotEmpty
                                      ? review.authorDetails.name[0]
                                            .toUpperCase()
                                      : 'A',
                                  style: const TextStyle(fontSize: 14),
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.authorDetails.name.isNotEmpty
                                    ? review.authorDetails.name
                                    : review.authorDetails.username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (review.authorDetails.rating != null)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 14,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      review.authorDetails.rating!
                                          .toStringAsFixed(1),
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.content,
                      style: TextStyle(color: Colors.grey[300], fontSize: 14),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  String _formatRuntime() {
    if (movieDetails!.runtime == 0) return 'N/A';
    final hours = movieDetails!.runtime ~/ 60;
    final minutes = movieDetails!.runtime % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String _getGenres() {
    if (movieDetails!.genres.isEmpty) return 'N/A';
    return movieDetails!.genres.map((g) => g.name).join(', ');
  }

  String _formatCurrency(int amount) {
    if (amount == 0) return 'N/A';
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return formatter.format(amount);
  }
}
