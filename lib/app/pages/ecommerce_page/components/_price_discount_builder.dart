// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart' as intl;

// 🌎 Project imports:
import '../../../core/theme/theme.dart';

class PriceDiscountBuilder extends StatelessWidget {
  const PriceDiscountBuilder({
    super.key,
    required this.price,
    this.discountPrice,
    this.fontSize = 16,
  });
  final double fontSize;
  final num price;
  final num? discountPrice;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    final _hasDiscount = (discountPrice ?? 0) > 0;
    final _displayPrice = discountPrice ?? price;
    return Text.rich(
      TextSpan(
        text: "${_currencyFormat(_displayPrice)} ",
        children: _hasDiscount
            ? [
          TextSpan(
            text: _currencyFormat(price),
            style: TextStyle(
              fontSize: (fontSize * 0.5) + 4,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ]
            : null,
      ),
      style: _theme.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: fontSize,
      ),
    );
  }

  String _currencyFormat(num? value) {
    return intl.NumberFormat.simpleCurrency().format(value);
  }
}

class DiscountChip extends StatelessWidget {
  const DiscountChip({
    super.key,
    required this.discountAmount,
    this.isPercent = true,
    this.decimalDigits = 2,
  });

  final num discountAmount;
  final bool isPercent;
  final int decimalDigits;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _discountAmount = isPercent
        ? intl.NumberFormat.percentPattern().format(discountAmount * 0.01)
        : intl.NumberFormat.simpleCurrency(decimalDigits: decimalDigits)
        .format(discountAmount);

    return Chip(
      label: Text(
        _discountAmount,
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
        horizontal: 4,
        vertical: 2,
      ),
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    );
  }
}
