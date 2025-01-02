// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../widgets/widgets.dart';

part 'data/_pricing_mock_data.dart';

class PricingView extends StatelessWidget {
  const PricingView({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _mqSize = MediaQuery.sizeOf(context);
    final _padding = responsiveValue<double>(
      context,
      xs: 16 / 2,
      sm: 16 / 2,
      md: 16 / 2,
      lg: 24 / 2,
    );

    final _centerLarge = _mqSize.width >= 1240;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_padding * 2),
        child: Column(
          children: [
            ShadowContainer(
              //headerText: 'Basic Pricing Plan',
              headerText: lang.basicPricingPlan,
              child: Column(
                children: [
                  Align(
                    child: Text(
                      lang.chooseYourBestPlan,
                      //'Choose Your Best Plan',
                      style: _theme.textTheme.headlineMedium?.copyWith(
                        fontSize: responsiveValue<double?>(
                          context,
                          xs: 22,
                          sm: 22,
                          md: 24,
                          lg: null,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints.loose(
                      const Size.fromWidth(1240),
                    ),
                    child: ResponsiveGridRow(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => ResponsiveGridCol(
                          lg: 4,
                          md: 6,
                          sm: 12,
                          child: Padding(
                            padding: EdgeInsets.all(
                              _padding + (_centerLarge ? 10 : 0),
                            ),
                            child: Transform.scale(
                              scale: _centerLarge && index == 1 ? 1.125 : 1,
                              child: BasicPricingCard(
                                isActive: index == 1,
                                cardModel: basicPricingPlan[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: _padding * 2),
            ShadowContainer(
              // headerText: 'Default Pricing Plan ',
              headerText: lang.defaultPricingPlan,
              child: Column(
                children: [
                  _buildDefaultPricingPlanHeader(context),
                  const SizedBox(height: 24),
                  Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints.loose(
                      const Size.fromWidth(1240),
                    ),
                    child: ResponsiveGridRow(
                      children: [
                        ...List.generate(
                          4,
                          (index) => ResponsiveGridCol(
                            lg: 3,
                            md: 6,
                            child: Padding(
                              padding: EdgeInsets.all(_padding),
                              child: VerticalPricingCard(
                                isActive: index == 2,
                                cardModel: defaultPricingPlan[index],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultPricingPlanHeader(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _showMobile = responsiveValue(
      context,
      xs: true,
      sm: true,
      md: false,
    );

    Widget _buildDiscountWidget() {
      final lang = l.S.of(context);
      final _content = [
        Transform.rotate(
          angle: _showMobile ? (35 * (3.1416 / 180)) : 0,
          child: CustomPaint(
            // size: _showMobile ? const Size(40, 25) : const Size(92, 56),
            size: responsiveValue<Size>(
              context,
              xs: const Size(40, 25),
              md: const Size(92, 56),
              lg: const Size(92, 56),
            ),
            painter: ArrowPainter(),
          ),
        ),
        Align(
          alignment:
              _showMobile ? Alignment.centerRight : const Alignment(0, 0.85),
          child: Text(
            '${lang.save} 25%',
            style: _theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: _theme.colorScheme.primary,
              fontSize: _showMobile ? 16 : 18,
            ),
          ),
        ),
      ];
      return Container(
        constraints: BoxConstraints.loose(
          Size.fromHeight(_showMobile ? 50 : 88),
        ),
        alignment: Alignment.bottomLeft,
        child: _showMobile
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _content,
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _content,
              ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Heading Text
        Text.rich(
          TextSpan(
            // Powerful Features & Pricing plan
            children: [
              if (responsiveValue<bool>(context, xs: false, md: true))
                TextSpan(
                  // text: 'Powerful',
                  text: l.S.current.powerful,
                ),
              TextSpan(
                // text: ' Features ',
                text: l.S.current.features,
                style: TextStyle(
                  color: _theme.colorScheme.primary,
                ),
              ),
              TextSpan(
                // text: '\n& Pricing plan',
                text: l.S.current.pricingPlan,
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: _theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.2,
            fontSize: responsiveValue<double?>(
              context,
              xs: 24,
              sm: 24,
              md: 36,
              lg: 48,
            ),
          ),
        ),
        SizedBox(
          height: responsiveValue<double>(
            context,
            xs: 24,
            md: 0,
            lg: 0,
          ),
        ),

        // Toggler
        Align(
          alignment: _showMobile
              ? AlignmentDirectional.center
              : const AlignmentDirectional(0.15, 0),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: _showMobile
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                // const Text('Pay Monthly'),
                Text(lang.payMonthly),
                SizedBox(
                  width: 44,
                  height: 24,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: CupertinoSwitch(
                      value: true,
                      applyTheme: true,
                      onChanged: (bool value1) {},
                    ),
                  ),
                ),
                if (_showMobile)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomPaint(
                        painter: const CurveUnderlinePainter(),
                        child: Text(
                          lang.payYearly,
                          // 'Pay Yearly',
                          style: _theme.textTheme.bodyLarge?.copyWith(),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _buildDiscountWidget(),
                      ),
                    ],
                  )
                else ...[
                  CustomPaint(
                    painter: const CurveUnderlinePainter(),
                    child: Text(
                      lang.payYearly,
                      // 'Pay Yearly',
                      style: _theme.textTheme.bodyLarge?.copyWith(),
                    ),
                  ),
                  _buildDiscountWidget(),
                ],
              ],
            ),
          ),
        )
      ],
    );
  }
}

class CurveUnderlinePainter extends CustomPainter {
  const CurveUnderlinePainter({
    this.underlineColor,
  });
  final Color? underlineColor;
  @override
  void paint(Canvas canvas, Size size) {
    Path path0 = Path();

    path0.moveTo(
      size.width * 0.075,
      size.height,
    );
    path0.cubicTo(
      size.width * 0.025,
      size.height,
      size.width * 0.50,
      size.height * 1.25,
      size.width * 0.915,
      size.height,
    );

    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02941176;
    paint0Stroke.color = underlineColor ?? const Color(0xff7500FD);
    paint0Stroke.strokeCap = StrokeCap.round;

    canvas.drawPath(path0, paint0Stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path0 = Path();
    path0.moveTo(size.width * 0.8920234, size.height * 0.6999852);
    path0.cubicTo(
        size.width * 0.7771720,
        size.height * 0.7347989,
        size.width * 0.6400364,
        size.height * 0.7414148,
        size.width * 0.5391028,
        size.height * 0.6534909);
    path0.cubicTo(
        size.width * 0.4745991,
        size.height * 0.5973011,
        size.width * 0.4403477,
        size.height * 0.4836818,
        size.width * 0.4644533,
        size.height * 0.3914591);
    path0.cubicTo(
        size.width * 0.4872206,
        size.height * 0.3043602,
        size.width * 0.5403860,
        size.height * 0.2278341,
        size.width * 0.6200542,
        size.height * 0.2301670);
    path0.cubicTo(
        size.width * 0.6615804,
        size.height * 0.2313818,
        size.width * 0.6973860,
        size.height * 0.2546125,
        size.width * 0.7049449,
        size.height * 0.3077864);
    path0.cubicTo(
        size.width * 0.7164944,
        size.height * 0.3890239,
        size.width * 0.6498430,
        size.height * 0.4730909,
        size.width * 0.5968505,
        size.height * 0.5084284);
    path0.cubicTo(
        size.width * 0.4314701,
        size.height * 0.6187091,
        size.width * 0.1975159,
        size.height * 0.6125727,
        size.width * 0.03997187,
        size.height * 0.4845670);

    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02803738;
    paint0Stroke.color = const Color(0xff7500FD).withOpacity(1.0);
    paint0Stroke.strokeCap = StrokeCap.round;
    canvas.drawPath(path0, paint0Stroke);

    Path path1 = Path();
    path1.moveTo(size.width * 0.1094093, size.height * 0.6345886);
    path1.cubicTo(
        size.width * 0.09013850,
        size.height * 0.6018466,
        size.width * 0.04805682,
        size.height * 0.5254636,
        size.width * 0.03389542,
        size.height * 0.4818693);

    Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02803738;
    paint1Stroke.color = const Color(0xff7500FD).withOpacity(1.0);
    paint1Stroke.strokeCap = StrokeCap.round;
    canvas.drawPath(path1, paint1Stroke);

    Path path2 = Path();
    path2.moveTo(size.width * 0.03389673, size.height * 0.4818886);
    path2.cubicTo(
        size.width * 0.06672523,
        size.height * 0.4766227,
        size.width * 0.1413458,
        size.height * 0.4617841,
        size.width * 0.1771991,
        size.height * 0.4445648);

    Paint paint2Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02803738;
    paint2Stroke.color = const Color(0xff7500FD).withOpacity(1.0);
    paint2Stroke.strokeCap = StrokeCap.round;
    canvas.drawPath(path2, paint2Stroke);

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = const Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path2, paint2Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
