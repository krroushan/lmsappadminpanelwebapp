// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../../../generated/l10n.dart' as l;
// 🌎 Project imports:
import '../../../../core/helpers/fuctions/helper_functions.dart';
import '../../../../core/theme/theme.dart';
import '../../../../models/models.dart';

import '../components.dart'
    show PriceDiscountBuilder, DiscountChip, RatingNReviews;

class LisTileProductCard extends StatefulWidget {
  const LisTileProductCard({
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
  State<LisTileProductCard> createState() => _LisTileProductCardState();
}

class _LisTileProductCardState extends State<LisTileProductCard> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _mqSize = MediaQuery.sizeOf(context);
    final _isDark = _theme.brightness == Brightness.dark;

    final _hasDiscount = (widget.product.discountPrice ?? 0) > 0 &&
        (widget.product.discountInPercent ?? 0) > 0;

    final _imageSize = responsiveValue<double>(
      context,
      xs: _mqSize.width < 480 ? 120 : 160,
      md: _mqSize.width < 992 ? 180 : 210,
    );

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
        child: Row(
          children: [
            // Product Image
            SizedBox(
              height: _imageSize,
              width: _imageSize,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AnimageWidget(
                      imagePath: widget.product.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (_hasDiscount)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: DiscountChip(
                        discountAmount: widget.product.discountInPercent!,
                      ),
                    ),
                ],
              ),
            ),

            // Product Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(
                  responsiveValue<double>(context, xs: 12, md: 16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      widget.product.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Stock Indicator
                    Text(
                      widget.product.inStock ? 'In Stock' : 'Out of Stock',
                      style: _theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: widget.product.inStock
                            ? AcnooAppColors.kSuccess
                            : AcnooAppColors.kError,
                      ),
                    ),

                    // Rating & Reviews
                    RatingNReviews(
                      rating: widget.product.rating,
                      reviews: widget.product.reviews,
                    ),

                    // Pricing
                    PriceDiscountBuilder(
                      price: widget.product.price,
                      discountPrice: widget.product.discountPrice,
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      height: 42,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Add To Cart Button
                          Flexible(
                            child: SizedBox(
                              width: 150,
                              child: OutlinedButton(
                                onPressed: widget.onAddCartTap,
                                style: OutlinedButton.styleFrom(
                                  textStyle:
                                  _theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  backgroundColor:
                                  !isHovering ? null : _theme.primaryColor,
                                  foregroundColor: isHovering
                                      ? _theme.colorScheme.onPrimary
                                      : _theme.colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: isHovering
                                      ? BorderSide.none
                                      : BorderSide(
                                    color: _theme.colorScheme.primary,
                                  ),
                                  padding: responsiveValue<EdgeInsetsGeometry?>(
                                    context,
                                    xs: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    md: null,
                                  ),
                                  visualDensity: const VisualDensity(
                                    horizontal: -4,
                                  ),
                                ),
                                // child: const Text('Add to Cart'),
                                child: Text(lang.addToCart),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Favorite Button
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
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
