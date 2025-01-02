import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart' as intl;

import '../../../../../core/helpers/helpers.dart';

class HorizontalNewsCard extends StatefulWidget {
  const HorizontalNewsCard({
    super.key,
    required this.data,
    this.onTap,
  });

  final HorizontalNewsCardData data;
  final void Function()? onTap;

  @override
  State<HorizontalNewsCard> createState() => _HorizontalNewsCardState();
}

class _HorizontalNewsCardState extends State<HorizontalNewsCard> {
  bool isHovering = false;
  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => changeHoverState(true),
      onExit: (_) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: _theme.colorScheme.primaryContainer,
            border: Border.all(
              color: _theme.colorScheme.outline,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              // Image
              Container(
                constraints: BoxConstraints.tight(
                  const Size(88, 94),
                ),
                color: Colors.blueGrey,
                child: AnimageWidget(
                  imagePath: widget.data.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),

              // Content
              Flexible(
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        // Category Name
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 10,
                                width: 2.5,
                                decoration: BoxDecoration(
                                  color: widget.data.categoryColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.data.categoryName ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: _theme.textTheme.bodyMedium?.copyWith(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),

                          // Headlines
                          Flexible(
                            child: Text(
                              widget.data.headline ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // Overviews
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildOverviewBase(
                              context,
                              value: intl.NumberFormat.compact().format(
                                widget.data.totalViews,
                              ),
                              icon: FeatherIcons.eye,
                              gradientColor: [
                                const Color(0xff0F77EB).withOpacity(0.10),
                                const Color(0xff12C0FF).withOpacity(0.10),
                              ],
                            ),
                            const SizedBox(width: 8),
                            _buildOverviewBase(
                              context,
                              value: intl.NumberFormat.compact().format(
                                widget.data.totalComments,
                              ),
                              icon: FeatherIcons.messageCircle,
                              gradientColor: [
                                const Color(0xffFEB36D).withOpacity(0.10),
                                const Color(0xffFD800E).withOpacity(0.10),
                              ],
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
      ),
    );
  }

  Widget _buildOverviewBase(
    BuildContext context, {
    IconData? icon,
    required String value,
    List<Color>? gradientColor,
  }) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter,
          colors: gradientColor ?? [Colors.blue, Colors.white],
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                icon,
                size: 14,
              ),
            ),
            TextSpan(text: " $value"),
          ],
        ),
      ),
    );
  }
}

class HorizontalNewsCardData {
  final String? imageUrl;
  final Color? categoryColor;
  final String? categoryName;
  final String? headline;
  final num? totalViews;
  final num? totalComments;

  const HorizontalNewsCardData({
    this.imageUrl,
    this.categoryColor,
    this.categoryName,
    this.headline,
    this.totalViews,
    this.totalComments,
  });
}
