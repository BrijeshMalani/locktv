import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoading({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: child,
    );
  }
}

class MovieCardShimmer extends StatelessWidget {
  const MovieCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 140,
            height: 210,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Container(width: 120, height: 16, color: Colors.grey[800]),
          const SizedBox(height: 4),
          Container(width: 80, height: 12, color: Colors.grey[800]),
        ],
      ),
    );
  }
}

class TVShowCardShimmer extends StatelessWidget {
  const TVShowCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 140,
            height: 210,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Container(width: 120, height: 16, color: Colors.grey[800]),
          const SizedBox(height: 4),
          Container(width: 80, height: 12, color: Colors.grey[800]),
        ],
      ),
    );
  }
}

class PersonCardShimmer extends StatelessWidget {
  const PersonCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 8),
          Container(width: 100, height: 16, color: Colors.grey[800]),
          const SizedBox(height: 4),
          Container(width: 80, height: 12, color: Colors.grey[800]),
        ],
      ),
    );
  }
}
