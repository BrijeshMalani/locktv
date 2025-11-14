import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:intl/intl.dart';
import '../Utils/common.dart';
import '../services/ad_manager.dart';
import '../services/tmdb_api_service.dart';
import '../models/tv_show.dart';
import '../widgets/WorkingNativeAdWidget.dart';
import '../widgets/tv_show_card.dart';
import '../widgets/loading_widget.dart';

class TVShowDetailsScreen extends StatefulWidget {
  final int tvShowId;

  const TVShowDetailsScreen({super.key, required this.tvShowId});

  @override
  State<TVShowDetailsScreen> createState() => _TVShowDetailsScreenState();
}

class _TVShowDetailsScreenState extends State<TVShowDetailsScreen> {
  TVShowDetails? tvShowDetails;
  bool isLoading = true;
  int _currentVideoIndex = -1;
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _loadTVShowDetails();
  }

  Future<void> _loadTVShowDetails() async {
    try {
      setState(() {
        isLoading = true;
      });

      final results = await Future.wait([
        TMDBAPIService.getTVSeriesDetails(seriesId: widget.tvShowId.toString()),
        TMDBAPIService.getTVSeriesCredits(seriesId: widget.tvShowId.toString()),
        TMDBAPIService.getTVSeriesVideos(seriesId: widget.tvShowId.toString()),
        TMDBAPIService.getTVSeriesImages(seriesId: widget.tvShowId.toString()),
        TMDBAPIService.getTVSeriesSimilar(seriesId: widget.tvShowId.toString()),
        TMDBAPIService.getTVSeriesRecommendations(
          seriesId: widget.tvShowId.toString(),
        ),
        TMDBAPIService.getTVSeriesReviews(seriesId: widget.tvShowId.toString()),
        TMDBAPIService.getTVSeriesWatchProviders(
          seriesId: widget.tvShowId.toString(),
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
        'watch/providers': results[7], // API returns {id: ..., results: {...}}
      };

      setState(() {
        tvShowDetails = TVShowDetails.fromJson(combinedData);
        isLoading = false;
      });
    } catch (e) {
      // Keep showing loader and retry automatically
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _loadTVShowDetails();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const LoadingWidget()
          : tvShowDetails == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTVShowHeader(),
                      _buildTVShowInfo(),
                      _buildOverview(),
                      if (Common.showvideos == "2") _buildTrailers(),
                      _buildCast(),
                      _buildCrew(),
                      _buildImages(),
                      _buildWatchProviders(),
                      _buildSimilarTVShows(),
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
              imageUrl: tvShowDetails!.backdropUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: Container(color: Colors.grey[800]),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[800],
                child: const Icon(Icons.tv, color: Colors.grey, size: 50),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
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

  Widget _buildTVShowHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: tvShowDetails!.posterUrl,
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
                child: const Icon(Icons.tv, color: Colors.grey, size: 50),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tvShowDetails!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      tvShowDetails!.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${tvShowDetails!.voteCount} votes)',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (tvShowDetails!.firstAirDate.isNotEmpty) ...[
                  Text(
                    'First Air Date: ${tvShowDetails!.firstAirDate.split('-')[0]}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
                if (tvShowDetails!.numberOfSeasons > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${tvShowDetails!.numberOfSeasons} Seasons • ${tvShowDetails!.numberOfEpisodes} Episodes',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTVShowInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (tvShowDetails!.status.isNotEmpty)
            _buildInfoChip('Status: ${tvShowDetails!.status}'),
          if (tvShowDetails!.type.isNotEmpty)
            _buildInfoChip('Type: ${tvShowDetails!.type}'),
          if (tvShowDetails!.inProduction)
            _buildInfoChip('In Production', Colors.green),
          if (tvShowDetails!.languages.isNotEmpty)
            _buildInfoChip('Languages: ${tvShowDetails!.languages.join(', ')}'),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, [Color? color]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? Colors.blue).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (color ?? Colors.blue).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color ?? Colors.blue,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildOverview() {
    if (tvShowDetails!.overview.isEmpty) return const SizedBox.shrink();

    return Container(
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
            tvShowDetails!.overview,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailers() {
    if (tvShowDetails!.videos.isEmpty) return const SizedBox.shrink();

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
            itemCount: tvShowDetails!.videos.length,
            itemBuilder: (context, index) {
              final video = tvShowDetails!.videos[index];
              if (video.site != 'YouTube') return const SizedBox.shrink();

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentVideoIndex = index;
                    _webViewController = WebViewController()
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..loadRequest(Uri.parse(video.youtubeUrl));
                  });
                  _showVideoDialog(video);
                },
                child: Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[900],
                  ),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            'https://img.youtube.com/vi/${video.key}/maxresdefault.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[900],
                          child: const Icon(
                            Icons.play_circle_outline,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Text(
                          video.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showVideoDialog(dynamic video) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _webViewController != null
                      ? WebViewWidget(controller: _webViewController!)
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCast() {
    if (tvShowDetails!.cast.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Cast',
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
            itemCount: tvShowDetails!.cast.length,
            itemBuilder: (context, index) {
              final cast = tvShowDetails!.cast[index];
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
                            size: 50,
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
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (cast.character.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        cast.character,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCrew() {
    if (tvShowDetails!.crew.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Crew',
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
            itemCount: tvShowDetails!.crew.length,
            itemBuilder: (context, index) {
              final crew = tvShowDetails!.crew[index];
              return Container(
                width: 120,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: crew.profileUrl,
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
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      crew.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (crew.job.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        crew.job,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImages() {
    if (tvShowDetails!.images.isEmpty) return const SizedBox.shrink();

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
            itemCount: tvShowDetails!.images.length,
            itemBuilder: (context, index) {
              final image = tvShowDetails!.images[index];
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[900],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: image.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: Container(
                        width: 300,
                        height: 200,
                        color: Colors.grey[800],
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 300,
                      height: 200,
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
      ],
    );
  }

  Widget _buildWatchProviders() {
    if (tvShowDetails!.watchProviders == null ||
        tvShowDetails!.watchProviders!.results.isEmpty) {
      return const SizedBox.shrink();
    }

    final providers = tvShowDetails!.watchProviders!.results;
    if (providers.isEmpty) return const SizedBox.shrink();

    // Get first country's providers
    final firstCountry = providers.keys.first;
    final countryProviders = providers[firstCountry]!;

    if (countryProviders.flatrate.isEmpty &&
        countryProviders.rent.isEmpty &&
        countryProviders.buy.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Where to Watch',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        if (countryProviders.flatrate.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Stream',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: countryProviders.flatrate.length,
              itemBuilder: (context, index) {
                final provider = countryProviders.flatrate[index];
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: provider.logoUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.tv,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSimilarTVShows() {
    if (tvShowDetails!.similar.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Similar TV Shows',
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
            itemCount: tvShowDetails!.similar.length,
            itemBuilder: (context, index) {
              final tvShow = tvShowDetails!.similar[index];
              return TVShowCard(
                tvShow: tvShow,
                onTap: () {
                  if (Common.adsopen == "2") {
                    Common.openUrl();
                  }
                  AdManager().showInterstitialAd();
                  Navigator.pushReplacementNamed(
                    context,
                    '/tv-details',
                    arguments: tvShow.id,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    if (tvShowDetails!.recommendations.isEmpty) return const SizedBox.shrink();

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
            itemCount: tvShowDetails!.recommendations.length,
            itemBuilder: (context, index) {
              final tvShow = tvShowDetails!.recommendations[index];
              return TVShowCard(
                tvShow: tvShow,
                onTap: () {
                  if (Common.adsopen == "2") {
                    Common.openUrl();
                  }
                  AdManager().showInterstitialAd();
                  Navigator.pushReplacementNamed(
                    context,
                    '/tv-details',
                    arguments: tvShow.id,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviews() {
    if (tvShowDetails!.reviews.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Reviews',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: tvShowDetails!.reviews.length,
          itemBuilder: (context, index) {
            final review = tvShowDetails!.reviews[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: review.authorDetails.avatarPath != null
                            ? CachedNetworkImageProvider(
                                review.authorDetails.avatarUrl,
                              )
                            : null,
                        child: review.authorDetails.avatarPath == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.author,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (review.authorDetails.rating != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    review.authorDetails.rating!
                                        .toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    review.content,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
