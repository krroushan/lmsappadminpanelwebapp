part of '_pricing_card.dart';

class BasicPricingCard extends StatefulWidget {
  const BasicPricingCard({
    super.key,
    this.isActive = false,
    required this.cardModel,
  });
  final bool isActive;
  final PricingCardModel cardModel;

  @override
  State<BasicPricingCard> createState() => _BasicPricingCardState();
}

class _BasicPricingCardState extends State<BasicPricingCard> {
  bool isHovering = false;
  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    const _activeForegroundColor = Colors.white;

    final _cardPadding = responsiveValue<double>(
      context,
      xs: 18,
      lg: 24,
    );

    return MouseRegion(
      onEnter: (event) => changeHoverState(true),
      onExit: (event) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: Material(
        color: widget.isActive
            ? _theme.colorScheme.primary
            : const Color(0xffDAC0FE),
        elevation: isHovering ? 4.75 : 0,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            _cardPadding,
            _cardPadding * 1.25,
            _cardPadding,
            _cardPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Info
              Container(
                padding: EdgeInsets.only(
                  bottom: responsiveValue<double>(
                    context,
                    xs: 12,
                    md: 14,
                    lg: 24,
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: widget.isActive
                          ? _activeForegroundColor
                          : AcnooAppColors.kNeutral400,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Card Icon
                    Container(
                      constraints: BoxConstraints.tight(
                        Size.square(
                          responsiveValue<double>(
                            context,
                            xs: 50,
                            sm: 50,
                            md: 50,
                            lg: 60,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: widget.isActive
                            ? _activeForegroundColor
                            : _theme.colorScheme.primary,
                      ),
                      child: widget.cardModel.icon == null
                          ? null
                          : Icon(
                              widget.cardModel.icon,
                              color: widget.isActive
                                  ? _theme.colorScheme.primary
                                  : _activeForegroundColor,
                              size: responsiveValue<double?>(
                                context,
                                xs: 24,
                                md: 24,
                                lg: 32,
                              ),
                            ),
                    ),
                    SizedBox(
                      width: responsiveValue<double>(
                        context,
                        xs: 12,
                        sm: 12,
                        md: 16,
                        lg: 20,
                      ),
                    ),

                    // Plan Name & Description
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              color: widget.isActive
                                  ? _activeForegroundColor
                                  : AcnooAppColors.kNeutral900,
                            ),
                          ),
                          Text(
                            widget.cardModel.planDescription ?? 'N/A',
                            style: _theme.textTheme.bodyLarge?.copyWith(
                              fontSize: responsiveValue<double?>(
                                context,
                                xs: 12,
                                lg: null,
                              ),
                              color: widget.isActive
                                  ? _activeForegroundColor
                                  : AcnooAppColors.kNeutral700,
                            ),
                          ),
                        ],
                      ),
                    )
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
                            xs: 16,
                            md: 18,
                            lg: 20,
                          ),
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: widget.isActive
                              ? _activeForegroundColor
                              : AcnooAppColors.kNeutral900,
                        ),
                      ),
                    TextSpan(
                      text: '/${widget.cardModel.subscriptionType}',
                      style: TextStyle(
                        fontSize: responsiveValue<double?>(
                          context,
                          xs: 16,
                          lg: 18,
                        ),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                style: _theme.textTheme.headlineMedium?.copyWith(
                  fontSize: responsiveValue<double?>(
                    context,
                    xs: 24,
                    md: 28,
                    lg: null,
                  ),
                  fontWeight: FontWeight.w700,
                  color: widget.isActive
                      ? _activeForegroundColor
                      : AcnooAppColors.kNeutral900,
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
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '\u2022 ${feature.key}',
                          textAlign: TextAlign.start,
                          style: _theme.textTheme.bodyLarge?.copyWith(
                            color: widget.isActive
                                ? _activeForegroundColor
                                : feature.value
                                    ? AcnooAppColors.kNeutral900
                                    : AcnooAppColors.kNeutral600,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                  onPressed: () {},
                  icon: const Icon(IconsaxPlusLinear.arrow_right),
                  //label:  Text('Choose Plan'),
                  label:  Text(l.S.of(context).choosePlan),
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
    required VoidCallback onPressed,
    required Widget icon,
    required Widget label,
    IconAlignment iconAlignment = IconAlignment.end,
  }) {
    final _theme = Theme.of(context);
    final ButtonStyle style = isActive
        ? ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: _theme.colorScheme.primary,
          )
        : OutlinedButton.styleFrom();

    return isActive
        ? ElevatedButton.icon(
            onPressed: onPressed,
            iconAlignment: iconAlignment,
            icon: icon,
            label: label,
            style: style,
          )
        : OutlinedButton.icon(
            onPressed: onPressed,
            icon: icon,
            iconAlignment: iconAlignment,
            label: label,
            style: style,
          );
  }
}
