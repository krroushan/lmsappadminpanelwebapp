// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../core/helpers/helpers.dart';

class ItemListTile extends StatelessWidget {
  const ItemListTile({
    super.key,
    this.imagePath,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.trailingColor,
  });
  final String? imagePath;
  final String title;
  final String subtitle;
  final String trailing;
  final Color? trailingColor;

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
      trailing: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 6,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(4),
          color: trailingColor?.withOpacity(0.1),
        ),
        child: Text(
          trailing,
          style: _theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: trailingColor,
          ),
        ),
      ),
    );
  }
}
