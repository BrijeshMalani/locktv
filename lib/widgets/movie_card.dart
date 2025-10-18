import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity / 2 - 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: movie.posterUrl,
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
                  child: const Icon(Icons.movie, color: Colors.grey, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              movie.title,
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
                  movie.year,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 12),
                    const SizedBox(width: 2),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
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
