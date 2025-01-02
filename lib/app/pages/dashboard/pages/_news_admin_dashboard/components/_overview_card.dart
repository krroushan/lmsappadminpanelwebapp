import 'package:flutter/material.dart';

import '../../../../../core/helpers/helpers.dart';

class BorderOverviewCard extends StatefulWidget {
  const BorderOverviewCard({
    super.key,
    this.iconPath,
    this.title,
    this.subtitle,
    this.iconBackgroundColor,
    this.cardBackgroundColor,
    this.border,
    this.cardType = BorderOverviewCardType.vertical,
  });
  final String? iconPath;
  final Widget? title;
  final Widget? subtitle;
  final Color? iconBackgroundColor;
  final Color? cardBackgroundColor;
  final BoxBorder? border;
  final BorderOverviewCardType cardType;

  @override
  State<BorderOverviewCard> createState() => _BorderOverviewCardState();
}

class _BorderOverviewCardState extends State<BorderOverviewCard> {
  bool isHovering = false;
  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isVerticalCard = widget.cardType == BorderOverviewCardType.vertical;

    final _border = widget.border ??
        const Border(
          top: BorderSide(
            color: Colors.amber,
            width: 6,
          ),
        );

    return MouseRegion(
      onEnter: (_) => changeHoverState(true),
      onExit: (_) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: Material(
        color:
            widget.cardBackgroundColor ?? _theme.colorScheme.primaryContainer,
        elevation: isHovering ? 4.75 : 0,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(border: _border),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          child: _isVerticalCard
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIcon(context),
                    const SizedBox.square(dimension: 16),
                    _buildContent(context, _isVerticalCard),
                  ],
                )
              : Row(
                  children: [
                    _buildIcon(context),
                    const SizedBox.square(dimension: 16),
                    Flexible(child: _buildContent(context, _isVerticalCard)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tight(
        const Size.square(48),
      ),
      padding: const EdgeInsetsDirectional.all(12),
      decoration: BoxDecoration(
        color: widget.iconBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AnimageWidget(
        imagePath: widget.iconPath,
        // fit: BoxFit.,
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isVerticalCard,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isVerticalCard ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (widget.title != null) Flexible(child: widget.title!),
        const SizedBox.square(dimension: 4),
        if (widget.subtitle != null) Flexible(child: widget.subtitle!),
      ],
    );
  }
}

enum BorderOverviewCardType { vertical, horizontal }
