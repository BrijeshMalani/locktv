import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/tv_show.dart';
import '../services/favorites_service.dart';

class TVShowCard extends StatefulWidget {
  final TVShow tvShow;
  final VoidCallback onTap;

  const TVShowCard({super.key, required this.tvShow, required this.onTap});

  @override
  State<TVShowCard> createState() => _TVShowCardState();
}

class _TVShowCardState extends State<TVShowCard> {
  bool _isFavorite = false;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final isFavorite = await FavoritesService.isFavoriteTVShow(
      widget.tvShow.id,
    );
    final isBookmarked = await FavoritesService.isBookmarkedTVShow(
      widget.tvShow.id,
    );
    setState(() {
      _isFavorite = isFavorite;
      _isBookmarked = isBookmarked;
    });
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await FavoritesService.removeFavoriteTVShow(widget.tvShow.id);
    } else {
      await FavoritesService.addFavoriteTVShow(widget.tvShow);
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Future<void> _toggleBookmark() async {
    if (_isBookmarked) {
      await FavoritesService.removeBookmarkedTVShow(widget.tvShow.id);
    } else {
      await FavoritesService.addBookmarkedTVShow(widget.tvShow);
    }
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity / 2 - 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster with action buttons
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: widget.tvShow.posterUrl,
                    width: double.infinity / 2 - 15,
                    height: 130,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: Container(
                        width: 140,
                        height: 210,
                        color: Colors.grey[800],
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 140,
                      height: 210,
                      color: Colors.grey[800],
                      child: const Icon(Icons.tv, color: Colors.grey, size: 50),
                    ),
                  ),
                ),
                // Action buttons overlay
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Favorite button
                      GestureDetector(
                        onTap: _toggleFavorite,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Bookmark button
                      GestureDetector(
                        onTap: _toggleBookmark,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: _isBookmarked ? Colors.amber : Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              widget.tvShow.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Year and Rating
            Row(
              children: [
                Text(
                  widget.tvShow.year,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 12),
                    const SizedBox(width: 2),
                    Text(
                      widget.tvShow.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
