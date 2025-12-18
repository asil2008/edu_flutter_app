// lib/widgets/rating_widget.dart
import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int count;
  final double starSize;
  final bool showCount;

  const RatingWidget({
    super.key,
    required this.rating,
    this.count = 0,
    this.starSize = 18,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.25 && (rating - fullStars) < 0.75;
    int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Yulduzlar
        ...List.generate(fullStars, (index) {
          return Icon(Icons.star_rounded, color: Colors.amber, size: starSize);
        }),
        if (halfStar)
          Icon(Icons.star_half_rounded, color: Colors.amber, size: starSize),
        ...List.generate(emptyStars, (index) {
          return Icon(Icons.star_border_rounded, color: Colors.amber, size: starSize);
        }),

        const SizedBox(width: 6),

        // Rating qiymati
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: starSize * 0.8,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),

        // Sharhlar soni
        if (showCount && count > 0)
          Text(
            ' ($count)',
            style: TextStyle(
              fontSize: starSize * 0.7,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }
}