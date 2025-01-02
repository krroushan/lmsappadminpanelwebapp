// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/theme/theme.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart' as intl;
import 'package:responsive_grid/responsive_grid.dart';
import '../../../../../generated/l10n.dart' as l;
// 🌎 Project imports:
import 'package:acnoo_flutter_admin_panel/app/core/helpers/helpers.dart';

class Order extends StatelessWidget {
  const Order({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _border = BorderSide(
      color: _theme.colorScheme.outline,
    );
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      lg: 24,
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: BorderDirectional(
          start: _border,
          end: _border,
          bottom: _border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildGradientTop(
            context,
            child: Center(
              child: Text(
                lang.orderSummary,
                //'Order Summary',
                style: _theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ),

          // Overview Section
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              0,
              0,
              0,
              20,
            ),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(_padding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AcnooAppColors.kPrimary600.withOpacity(0.1),
                    ),
                    child: Column(
                      children: [
                        ..._orderList
                            .map((order) {
                              return _buildOrderTile(
                                context,
                                orderName: order.$1,
                                quantity: order.$2,
                              );
                            })
                            .toList()
                            .addBetween(const SizedBox(height: 24)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    lang.couponCode,
                    //'Coupon Code',
                    style: _theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        // hintText: 'Enter coupon code',
                        hintText: lang.enterCouponCode,
                        suffixIconConstraints:
                            const BoxConstraints.tightFor(width: 72),
                        suffixIcon: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AcnooAppColors.kSuccess,
                                padding: EdgeInsets.zero,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusDirectional.horizontal(
                                            end: Radius.circular(6)))),
                            onPressed: () {},
                            child: Center(
                              child: Text(lang.apply),
                            ))),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      // child:  Text('Proceed to Checkout'),
                      child: Text(lang.proceedToCheckout),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTile(
    BuildContext context, {
    required String orderName,
    required int quantity,
  }) {
    final _theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  orderName,
                  style: _theme.textTheme.bodyMedium?.copyWith(
                    color: _theme.colorScheme.onTertiaryContainer,
                    fontWeight: orderName == "Total"
                        ? FontWeight.bold
                        : FontWeight.normal, // Bold only for "Total"
                  ),
                ),
              ),
              Text(
                "\$${intl.NumberFormat.currency(
                  symbol: '',
                  decimalDigits: 0,
                ).format(quantity)}",
                style: _theme.textTheme.bodyMedium?.copyWith(
                  color: _theme.colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.bold, // Bold for all quantities
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildGradientTop(
  BuildContext context, {
  required Widget child,
}) {
  final _theme = Theme.of(context);
  return Container(
    padding: const EdgeInsetsDirectional.all(16),
    decoration: BoxDecoration(
      border: BorderDirectional(
        top: BorderSide(
          color: _theme.colorScheme.primary,
          width: 2,
        ),
      ),
      gradient: LinearGradient(
        begin: AlignmentDirectional.topCenter,
        end: AlignmentDirectional.bottomCenter,
        tileMode: TileMode.decal,
        stops: const [0.0, 0.75],
        colors: [
          _theme.colorScheme.primary.withOpacity(0.1),
          _theme.colorScheme.primary.withOpacity(0.02),
        ],
      ),
    ),
    child: child,
  );
}

List<(String, int)> get _orderList {
  return [
    // ("Subtotal", 143),
    // ("Discount", 0),
    // ("Shipping Charge", 0),
    // ("Tax", 0),
    // ("Total", 143),
    (l.S.current.subtotal, 143),
    (l.S.current.discount, 0),
    (l.S.current.shippingCharge, 0),
    (l.S.current.tax, 0),
    (l.S.current.total, 143),
  ];
}
