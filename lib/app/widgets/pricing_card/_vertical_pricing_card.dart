part of '_pricing_card.dart';

class VerticalPricingCard extends StatefulWidget {
  const VerticalPricingCard({
    super.key,
    this.isActive = false,
    required this.cardModel,
  });
  final bool isActive;
  final PricingCardModel cardModel;

  @override
  State<VerticalPricingCard> createState() => _VerticalPricingCardState();
}

class _VerticalPricingCardState extends State<VerticalPricingCard> {
  bool isHovering = false;
  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    const _activeForegroundColor = Colors.white;

    final _cardPadding = responsiveValue<double>(
      context,
      xs: 18,
      lg: 24,
    );

    final _theme = Theme.of(context);
    return MouseRegion(
      onEnter: (event) => changeHoverState(true),
      onExit: (event) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: Material(
        color: widget.isActive
            ? _theme.colorScheme.primary
            : _theme.colorScheme.primaryContainer,
        elevation: isHovering ? 4.75 : 0,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            _cardPadding,
            _cardPadding * 1.25,
            _cardPadding,
            _cardPadding,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: _theme.colorScheme.outline,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plan Name
              ConstrainedBox(
                constraints: BoxConstraints.loose(const Size.fromWidth(375)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.cardModel.planName,
                      style: _theme.textTheme.headlineSmall?.copyWith(
                        fontSize: responsiveValue<double?>(
                          context,
                          xs: 16,
                          md: 18,
                          lg: null,
                        ),
                        fontWeight: FontWeight.w700,
                        color: widget.isActive ? _activeForegroundColor : null,
                      ),
                    ),

                    // Plan Description
                    Text(
                      widget.cardModel.planDescription ?? 'N/A',
                      style: _theme.textTheme.bodyLarge?.copyWith(
                        fontSize: responsiveValue<double?>(
                          context,
                          xs: 14,
                          md: 16,
                        ),
                        color: widget.isActive ? _activeForegroundColor : null,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: responsiveValue<double>(
                  context,
                  xs: 12,
                  sm: 12,
                  md: 16,
                  lg: 20,
                ),
              ),

              // Plan Pricing
              Text.rich(
                TextSpan(
                  text:
                      '\$${widget.cardModel.discountPrice ?? widget.cardModel.planPrice} ',
                  children: [
                    if (widget.cardModel.discountPrice != null)
                      TextSpan(
                        text: "\$${widget.cardModel.planPrice}",
                        style: TextStyle(
                          fontSize: responsiveValue<double?>(
                            context,
                            xs: 18,
                            md: 20,
                            lg: 24,
                          ),
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.lineThrough,
                          decorationColor:
                              widget.isActive ? _activeForegroundColor : null,
                        ),
                      ),
                    TextSpan(
                      text: '/${widget.cardModel.subscriptionType}',
                      style: TextStyle(
                        fontSize: responsiveValue<double?>(
                          context,
                          xs: 18,
                          lg: 20,
                        ),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                style: _theme.textTheme.displaySmall?.copyWith(
                  fontSize: responsiveValue<double?>(
                    context,
                    xs: 36,
                    md: null,
                    lg: 52,
                  ),
                  fontWeight: FontWeight.w700,
                  color: widget.isActive ? _activeForegroundColor : null,
                ),
              ),
              SizedBox(
                height: responsiveValue<double>(
                  context,
                  xs: 12,
                  sm: 12,
                  md: 16,
                  lg: 20,
                ),
              ),

              // CTA Button
              SizedBox(
                width: double.infinity,
                child: _buildButton(
                  context,
                  isActive: widget.isActive,
                  isHovering: isHovering,
                  onPressed: () {},
                  //label:  Text('Get Started Now'),
                  label:  Text(l.S.of(context).getStartedNow),
                ),
              ),
              SizedBox(
                height: responsiveValue<double>(
                  context,
                  xs: 12,
                  sm: 12,
                  md: 16,
                  lg: 20,
                ),
              ),

              // Features
              ...widget.cardModel.features.entries.map(
                (feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: feature.value
                              ? const Color(0xffDAC0FE)
                              : _theme.colorScheme.tertiaryContainer,
                        ),
                        child: Icon(
                          feature.value ? Icons.check : Icons.close,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          feature.key,
                          textAlign: TextAlign.start,
                          style: _theme.textTheme.bodyLarge?.copyWith(
                            color: widget.isActive
                                ? _activeForegroundColor
                                : feature.value
                                    ? null
                                    : AcnooAppColors.kNeutral600,
                          ),
                        ),
                      ),
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

  Widget _buildButton(
    BuildContext context, {
    bool isActive = false,
    bool isHovering = false,
    required VoidCallback onPressed,
    required Widget label,
  }) {
    final _theme = Theme.of(context);
    final ButtonStyle style = isActive || isHovering
        ? ElevatedButton.styleFrom(
            backgroundColor: isHovering && !isActive
                ? _theme.colorScheme.primary
                : Colors.white,
            foregroundColor: isHovering && !isActive
                ? Colors.white
                : _theme.colorScheme.primary,
          )
        : OutlinedButton.styleFrom();

    return isActive
        ? ElevatedButton(
            onPressed: onPressed,
            style: style,
            child: label,
          )
        : OutlinedButton(
            onPressed: onPressed,
            style: style,
            child: label,
          );
  }
}
