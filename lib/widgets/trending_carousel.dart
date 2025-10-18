import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TrendingCarousel extends StatefulWidget {
  final String title;
  final List<dynamic> items;
  final Function(dynamic) onItemTap;

  const TrendingCarousel({
    super.key,
    required this.title,
    required this.items,
    required this.onItemTap,
  });

  @override
  State<TrendingCarousel> createState() => _TrendingCarouselState();
}

class _TrendingCarouselState extends State<TrendingCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildCarouselItem(item),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Page indicators
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.items.length > 5 ? 5 : widget.items.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(dynamic item) {
    final String title = item.title ?? item.name ?? '';
    final String overview = item.overview ?? '';
    final String backdropUrl = item.backdropUrl ?? '';
    final double voteAverage = item.voteAverage ?? 0.0;
    final String year = item.year ?? '';

    return GestureDetector(
      onTap: () => widget.onItemTap(item),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Backdrop Image
              CachedNetworkImage(
                imageUrl: backdropUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[800]!,
                  highlightColor: Colors.grey[700]!,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey[800],
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.grey[800],
                  child: const Icon(Icons.movie, color: Colors.grey, size: 50),
                ),
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            year,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 16),
                          RatingBarIndicator(
                            rating: voteAverage / 2,
                            itemBuilder: (context, index) =>
                                const Icon(Icons.star, color: Colors.amber),
                            itemCount: 5,
                            itemSize: 16,
                            direction: Axis.horizontal,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            voteAverage.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        overview,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
