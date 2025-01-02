// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart' as l;

class RatingNReviews extends StatelessWidget {
  const RatingNReviews({
    super.key,
    this.rating = 0,
    this.reviews,
  });

  final double rating;
  final int? reviews;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    return Text.rich(
      TextSpan(
        children: [
          ...List.generate(
            rating.toInt(),
                (i) => const WidgetSpan(
              child: Icon(
                Icons.star,
                size: 16,
                color: Colors.amber,
              ),
            ),
          ),
          if (reviews != null)
            TextSpan(
              text: " ($reviews ${lang.review}${(reviews ?? 0) > 1 ? 's' : ''})",
            ),
        ],
      ),
      style: _theme.textTheme.bodyMedium?.copyWith(
        color: _theme.colorScheme.onTertiaryContainer,
      ),
    );
  }
}
