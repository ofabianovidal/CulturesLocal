import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CultureReferenceCrop extends StatelessWidget {
  const CultureReferenceCrop({
    super.key,
    required this.assetPath,
    required this.sourceWidth,
    required this.sourceHeight,
    required this.cropLeft,
    required this.cropTop,
    required this.cropWidth,
    required this.cropHeight,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  final String assetPath;
  final double sourceWidth;
  final double sourceHeight;
  final double cropLeft;
  final double cropTop;
  final double cropWidth;
  final double cropHeight;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final scale = math.max(width / cropWidth, height / cropHeight);

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Transform.translate(
              offset: Offset(-cropLeft * scale, -cropTop * scale),
              child: Image.asset(
                assetPath,
                width: sourceWidth * scale,
                height: sourceHeight * scale,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CultureEventPoster extends StatelessWidget {
  const CultureEventPoster({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
  });

  final double width;
  final double height;
  final BorderRadius borderRadius;

  static const _assetPath = 'assets/images/favorites_reference.png';

  @override
  Widget build(BuildContext context) {
    return CultureReferenceCrop(
      assetPath: _assetPath,
      sourceWidth: 432,
      sourceHeight: 900,
      cropLeft: 52,
      cropTop: 231,
      cropWidth: 195,
      cropHeight: 126,
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }
}

class CultureEventCard extends StatelessWidget {
  const CultureEventCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.description,
    required this.dateLabel,
    this.showPrice = true,
    this.showFavoriteBadge = true,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.posterWidth = 154,
    this.posterHeight = 118,
    this.priceLabel = '',
    this.topRight,
  });

  final VoidCallback onTap;
  final String title;
  final String description;
  final String dateLabel;
  final bool showPrice;
  final bool showFavoriteBadge;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final double posterWidth;
  final double posterHeight;
  final String priceLabel;
  final Widget? topRight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CultureEventPoster(width: posterWidth, height: posterHeight),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: AppColors.green,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (topRight != null)
                            topRight!
                          else if (showFavoriteBadge)
                            GestureDetector(
                              onTap: onFavoriteTap,
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2, left: 8),
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite
                                      ? Colors.red
                                      : AppColors.green,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dateLabel,
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (showPrice) ...[
                        const SizedBox(height: 14),
                        Text(
                          priceLabel,
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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
