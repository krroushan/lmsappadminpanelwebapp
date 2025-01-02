// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../../generated/l10n.dart' as l;
// 🌎 Project imports:
import '../../../../core/theme/theme.dart';
import '../../../../models/models.dart';

class GridProductCard extends StatefulWidget {
  const GridProductCard({
    super.key,
    required this.product,
    this.showHoverEffect = true,
    this.onTap,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onAddCartTap,
  });
  final MockProduct product;
  final bool showHoverEffect;
  final void Function()? onTap;

  final bool isFavorite;
  final void Function()? onFavoriteTap;
  final void Function()? onAddCartTap;

  @override
  State<GridProductCard> createState() => _GridProductCardState();
}

class _GridProductCardState extends State<GridProductCard> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    final _hasDiscount = (widget.product.discountPrice ?? 0) > 0 &&
        (widget.product.discountInPercent ?? 0) > 0;

    final _displayPrice =
        _hasDiscount ? widget.product.discountPrice! : widget.product.price;

    return LayoutBuilder(
      builder: (context, constraints) {
        final _size = constraints.biggest;

        return InkWell(
          onTap: widget.onTap,
          onHover: (v) => setState(() => isHovering = v),
          mouseCursor: SystemMouseCursors.click,
          child: Material(
            elevation: widget.showHoverEffect ? (isHovering ? 4 : 0) : 0,
            clipBehavior: widget.showHoverEffect ? Clip.antiAlias : Clip.none,
            shape: widget.showHoverEffect
                ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                : null,
            type: MaterialType.card,
            color: _theme.colorScheme.primaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ConstrainedBox(
                  constraints: BoxConstraints.tight(
                    Size(double.maxFinite, _size.height / 1.80),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          widget.product.imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        right: 12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_hasDiscount)
                              Chip(
                                label: Text(
                                  intl.NumberFormat.percentPattern().format(
                                      (widget.product.discountInPercent ?? 0) /
                                          100),
                                  style: _theme.textTheme.bodyMedium?.copyWith(
                                    color: AcnooAppColors.kWhiteColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                color: WidgetStateProperty.all<Color?>(
                                  AcnooAppColors.kError,
                                ),
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                              )
                            else
                              const SizedBox.shrink(),
                            IconButton.outlined(
                              onPressed: widget.onFavoriteTap,
                              icon: Icon(
                                widget.isFavorite
                                    ? IconsaxPlusBold.heart
                                    : IconsaxPlusLinear.heart,
                              ),
                              color: widget.isFavorite
                                  ? _theme.colorScheme.primary
                                  : (_isDark
                                      ? _theme.colorScheme.tertiaryContainer
                                      : null),
                              style: IconButton.styleFrom(
                                side: BorderSide(
                                  color: _theme.colorScheme.outline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Product Info
                Expanded(
                  child: Container(
                    margin: const EdgeInsetsDirectional.fromSTEB(
                      16,
                      10,
                      16,
                      20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            Text(
                              widget.product.productName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: _theme.textTheme.bodyLarge?.copyWith(
                                color: isHovering
                                    ? _theme.colorScheme.primary
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Stock Indicator
                            Text(
                              widget.product.inStock
                                  ? 'In Stock'
                                  : 'Out of Stock',
                              style: _theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: widget.product.inStock
                                    ? AcnooAppColors.kSuccess
                                    : AcnooAppColors.kError,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Rating & Reviews
                            _buildRatingReviews(
                              context,
                              rating: widget.product.rating,
                              reviews: widget.product.reviews,
                            ),
                            const SizedBox(height: 8),

                            // Price
                            Text.rich(
                              TextSpan(
                                text: "${_currencyFormat(_displayPrice)} ",
                                children: _hasDiscount
                                    ? [
                                        TextSpan(
                                          text: _currencyFormat(
                                            widget.product.price,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ]
                                    : null,
                              ),
                              style: _theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Add To Cart Button
                        SizedBox(
                          width: double.maxFinite,
                          child: OutlinedButton(
                            onPressed: widget.onAddCartTap,
                            style: OutlinedButton.styleFrom(
                              textStyle: _theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              backgroundColor:
                                  !isHovering ? null : _theme.primaryColor,
                              foregroundColor: isHovering
                                  ? _theme.colorScheme.onPrimary
                                  : _theme.colorScheme.primary,
                              side: isHovering
                                  ? BorderSide.none
                                  : BorderSide(
                                      color: _theme.colorScheme.primary,
                                    ),
                            ),
                            //child:  Text('Add to Cart'),
                            child: Text(lang.addToCart),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingReviews(
    BuildContext context, {
    double rating = 0,
    int reviews = 0,
  }) {
    final _theme = Theme.of(context);
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
          TextSpan(
            text: " ($reviews)",
          ),
        ],
      ),
      style: _theme.textTheme.bodyMedium?.copyWith(
        color: _theme.colorScheme.onTertiaryContainer,
      ),
    );
  }

  String _currencyFormat(num? value) {
    return intl.NumberFormat.simpleCurrency().format(value);
  }
}
