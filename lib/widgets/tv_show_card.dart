import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/tv_show.dart';

class TVShowCard extends StatelessWidget {
  final TVShow tvShow;
  final VoidCallback onTap;

  const TVShowCard({super.key, required this.tvShow, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity/2-10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: tvShow.posterUrl,
                width: double.infinity/2-15,
                height: 210,
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
            const SizedBox(height: 8),
            // Title
            Text(
              tvShow.name,
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
                  tvShow.year,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 12),
                    const SizedBox(width: 2),
                    Text(
                      tvShow.voteAverage.toStringAsFixed(1),
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
