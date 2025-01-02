part of 'card_widgets.dart';

class TestimonialCard extends StatefulWidget {
  const TestimonialCard({
    super.key,
    required this.title,
    this.description,
    this.imagePath,
  });
  final String title;
  final String? description;
  final String? imagePath;

  @override
  State<TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<TestimonialCard> {
  bool isHovering = false;
  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);

    final _iconSize = responsiveValue<double>(
      context,
      xs: 24,
      sm: 24,
      md: 28,
      lg: 32,
    );

    return MouseRegion(
      onEnter: (event) => changeHoverState(true),
      onExit: (event) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsetsDirectional.all(16),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: _theme.colorScheme.primaryContainer,
          border: Border.all(
            color:
                isHovering ? _theme.primaryColor : _theme.colorScheme.outline,
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsetsDirectional.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _theme.primaryColor.withOpacity(0.25),
              ),
              child: getImageType(
                widget.imagePath,
                width: _iconSize,
                height: _iconSize,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              widget.title,
              style: _theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: responsiveValue<double?>(
                  context,
                  xs: 16,
                  sm: 16,
                  md: 24,
                  lg: 24,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              widget.description ?? 'No description provided',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: _theme.textTheme.bodyLarge?.copyWith(
                fontSize: responsiveValue<double?>(
                  context,
                  xs: 12,
                  sm: 12,
                  md: 16,
                  lg: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Read More Nav Button
            Text.rich(
              TextSpan(
                //text: 'Read More',
                text: lang.readMore,
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      FeatherIcons.chevronRight,
                      color: isHovering ? _theme.primaryColor : null,
                    ),
                  ),
                ],
              ),
              style: _theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: isHovering ? _theme.primaryColor : null,
                fontSize: responsiveValue<double?>(
                  context,
                  xs: 12,
                  sm: 12,
                  md: 16,
                  lg: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
