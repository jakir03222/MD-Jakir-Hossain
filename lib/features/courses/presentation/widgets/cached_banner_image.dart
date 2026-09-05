import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Reusable cached banner with placeholder / error (SRP for image UI).
class CachedBannerImage extends StatelessWidget {
  const CachedBannerImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.iconSize = 36,
  });

  final String imageUrl;
  final BoxFit fit;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => Container(
        color: const Color(0xFFE2E8F0),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
      errorWidget: (context, url, error) => Container(
        color: const Color(0xFFE2E8F0),
        alignment: Alignment.center,
        child: Icon(
          Icons.broken_image_outlined,
          size: iconSize,
          color: const Color(0xFF94A3B8),
        ),
      ),
    );
  }
}
