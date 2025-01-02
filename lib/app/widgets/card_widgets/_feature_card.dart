part of 'card_widgets.dart';

class FeatureCardWidget extends StatefulWidget {
  const FeatureCardWidget({
    super.key,
    required this.title,
    this.description,
    this.imagePath,
    this.actions,
  });
  final String title;
  final String? description;
  final String? imagePath;
  final List<Widget>? actions;

  @override
  State<FeatureCardWidget> createState() => _FeatureCardWidgetState();
}

class _FeatureCardWidgetState extends State<FeatureCardWidget> {
  bool isHovering = false;
  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    final (double, double, double) _buttonPadding =
        responsiveValue<(double, double, double)>(
      context,
      xs: (8, 8, 12),
      sm: (8, 8, 12),
      md: (10, 10, 14),
      lg: (10, 10, 14),
    );

    return MouseRegion(
      onEnter: (event) => changeHoverState(true),
      onExit: (event) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: _theme.colorScheme.primaryContainer,
          border:
              isHovering ? null : Border.all(color: _theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
          image: !isHovering
              ? null
              : const DecorationImage(
                  image: AssetImage(AcnooStaticImage.featureCardBg),
                  fit: BoxFit.cover,
                ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            ClipRRect(
              child: getImageType(
                widget.imagePath,
              ),
            ),
            const SizedBox(width: 4),

            // Card Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    widget.title,
                    style: _theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isHovering ? Colors.white : null,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    widget.description ?? 'No description Provided',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: _theme.textTheme.labelLarge?.copyWith(
                      color: isHovering ? Colors.white : null,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // CTA Button
                      ElevatedButton.icon(
                        onPressed: () {},
                        //label:  Text('Get Started'),
                        label: Text(lang.getStarted),
                        icon: const Icon(FeatherIcons.arrowUpRight),
                        iconAlignment: IconAlignment.end,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: _buttonPadding.$1,
                            vertical: _buttonPadding.$2,
                          ),
                          textStyle: _theme.textTheme.bodyLarge?.copyWith(
                            fontSize: _buttonPadding.$3,
                            fontWeight: FontWeight.w500,
                          ),
                          visualDensity: const VisualDensity(
                            horizontal: -3,
                            vertical: -0.75,
                          ),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          side: isHovering
                              ? const BorderSide(color: Colors.white)
                              : null,
                          backgroundColor: (isHovering
                                  ? Colors.white
                                  : _isDark
                                      ? AcnooAppColors.kPrimary200
                                      : _theme.primaryColor)
                              .withOpacity(
                            0.20,
                          ),
                          foregroundColor: isHovering
                              ? Colors.white
                              : _isDark
                                  ? AcnooAppColors.kPrimary200
                                  : _theme.primaryColor,
                        ),
                      ),

                      // Other Actions
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [...?widget.actions],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
