import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/person.dart';

class PersonCard extends StatelessWidget {
  final Person person;
  final VoidCallback onTap;

  const PersonCard({super.key, required this.person, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: CachedNetworkImage(
                imageUrl: person.profileUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[800]!,
                  highlightColor: Colors.grey[700]!,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Name
            Text(
              person.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            // Known For
            Text(
              person.knownForDepartment,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
