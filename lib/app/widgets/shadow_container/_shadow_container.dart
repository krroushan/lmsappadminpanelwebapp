// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../widgets.dart';

class ShadowContainer extends StatelessWidget {
  const ShadowContainer({
    super.key,
    this.headerText,
    this.showHeader = true,
    this.customHeader,
    this.decoration,
    this.headerBackgroundColor,
    this.child,
    this.leading,
    this.trailing,
    this.clipBehavior,
    this.contentPadding = const EdgeInsetsDirectional.all(16),
    this.margin,
  });

  final String? headerText;
  final bool showHeader;
  final Widget? customHeader;
  final BoxDecoration? decoration;
  final Color? headerBackgroundColor;
  final Widget? child;
  final Widget? leading;
  final Widget? trailing;
  final Clip? clipBehavior;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      margin: margin,
      decoration: decoration ??
          BoxDecoration(
            color: _theme.colorScheme.primaryContainer,
            borderRadius: BorderRadiusDirectional.circular(12),
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader)
            ColoredBox(
              color:
                  headerBackgroundColor ?? _theme.colorScheme.primaryContainer,
              child: customHeader ??
                  DialogHeader(
                    headerTitle: headerText,
                    showCloseButton: false,
                    leading: leading,
                    trailing: trailing,
                  ),
            ),
          if (child != null)
            Flexible(
              child: Padding(
                padding: contentPadding,
                child: child!,
              ),
            )
        ],
      ),
    );
  }
}
