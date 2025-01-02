part of 'card_widgets.dart';

class HorizontalCardWidget extends StatefulWidget {
  const HorizontalCardWidget({
    super.key,
    required this.title,
    this.description,
    this.image,
    this.imageAlignment = ImageAlignment.start,
    this.isLoading = true,
  });
  final String title;
  final String? description;
  final ImageProvider<Object>? image;
  final ImageAlignment imageAlignment;
  final bool isLoading;
  @override
  State<HorizontalCardWidget> createState() => _HorizontalCardWidgetState();
}

class _HorizontalCardWidgetState extends State<HorizontalCardWidget> {
  bool isHovering = false;
  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final _lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    final _shimmerLoadingColor =
        _isDark ? AcnooAppColors.kDark3 : AcnooAppColors.kNeutral200;

    final (double, double) _fontSize = responsiveValue<(double, double)>(
      context,
      xs: (14, 12),
      sm: (14, 12),
      md: (14, 12),
      lg: (18, 16),
    );

    final _imageSize = responsiveValue<double>(
      context,
      xs: 110,
      sm: 110,
      md: 115,
      lg: 150,
    );

    final (double, double, double) _buttonPadding =
        responsiveValue<(double, double, double)>(
      context,
      xs: (12, 10, 12),
      sm: (12, 10, 12),
      md: (16, 16, 12),
      lg: (16, 16, 14),
    );

    final _content = [
      // Image
      widget.isLoading
          ? ShimmerPlaceholder(
              height: _imageSize,
              width: _imageSize,
              decoration: BoxDecoration(
                color: _shimmerLoadingColor,
                borderRadius: BorderRadius.circular(6),
              ),
            )
          : Container(
              clipBehavior: Clip.hardEdge,
              constraints: BoxConstraints.tight(
                Size.square(_imageSize),
              ),
              decoration: BoxDecoration(
                color: _shimmerLoadingColor,
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                  image: widget.image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
      SizedBox(width: _fontSize.$1 / 1.5),

      // Card Content
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            if (widget.isLoading)
              ShimmerPlaceholder(
                color: _shimmerLoadingColor,
                width: 60,
                height: _fontSize.$1 * 1.25,
              )
            else
              Text(
                widget.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: _theme.textTheme.headlineLarge?.copyWith(
                  fontSize: _fontSize.$1,
                  fontWeight: FontWeight.bold,
                ),
              ),

            // Description
            if (widget.isLoading)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  3,
                  (index) => ShimmerPlaceholder(
                    color: _shimmerLoadingColor,
                    height: _fontSize.$2 * 1.50,
                    width: switch (index) {
                      0 => 120 * (index + 1),
                      1 => 75 * (index + 1),
                      2 => 65 * (index + 1),
                      _ => double.maxFinite,
                    },
                  ),
                ),
              )
            else
              Text(
                widget.description ?? 'No description provided',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: _theme.textTheme.bodyLarge?.copyWith(
                  fontSize: _fontSize.$2,
                ),
              ),
            SizedBox(height: _fontSize.$2 / 1.5),

            // Action Button
            if (widget.isLoading)
              ShimmerPlaceholder(
                color: _shimmerLoadingColor,
                width: 120,
                height: 24,
              )
            else
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: _buttonPadding.$1,
                    vertical: _buttonPadding.$2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  textStyle: _theme.textTheme.bodyLarge?.copyWith(
                    fontSize: _buttonPadding.$3,
                    fontWeight: FontWeight.w500,
                  ),
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -2,
                  ),
                  backgroundColor: !isHovering ? null : _theme.primaryColor,
                  foregroundColor: isHovering
                      ? _theme.colorScheme.onPrimary
                      : _theme.colorScheme.onTertiaryContainer,
                  side: isHovering
                      ? BorderSide.none
                      : BorderSide(
                          color: _theme.colorScheme.outline,
                        ),
                ),
                //child:  Text('Read More'),
                child: Text(_lang.readMore),
              )
          ],
        ),
      ),
    ];

    return MouseRegion(
      onEnter: (event) => changeHoverState(true),
      onExit: (event) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: Material(
        color: _theme.colorScheme.primaryContainer,
        elevation: isHovering ? 4.75 : 0,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: Container(
          constraints: BoxConstraints.loose(
            const Size(double.maxFinite, 280),
          ),
          padding: widget.imageAlignment == ImageAlignment.start
              ? const EdgeInsetsDirectional.all(8)
              : const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
          child: Row(
            children: widget.imageAlignment == ImageAlignment.start
                ? _content
                : _content.reversed.toList(),
          ),
        ),
      ),
    );
  }
}

enum ImageAlignment { start, end }
