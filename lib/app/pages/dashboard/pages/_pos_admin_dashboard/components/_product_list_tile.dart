// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart';

// 🌎 Project imports:
import '../../../../../core/helpers/fuctions/helper_functions.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    super.key,
    this.imagePath,
    required this.title,
    required this.subtitle,
    required this.amount,
  });
  final String? imagePath;
  final String title;
  final String subtitle;
  final num amount;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return ListTile(
      leading: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        constraints: BoxConstraints.tight(const Size.square(40)),
        child: AnimageWidget(
          imagePath: imagePath,
          fit: BoxFit.cover,
          height: double.maxFinite,
          width: double.maxFinite,
        ),
      ),
      title: Text(
        title,
        style: _theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: _theme.textTheme.bodySmall?.copyWith(
          color: _theme.checkboxTheme.side?.color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        NumberFormat.simpleCurrency().format(amount),
        style: _theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
