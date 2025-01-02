import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../../../generated/l10n.dart' as l;
import '../../../../../core/helpers/helpers.dart';

class Amount extends StatelessWidget {
  const Amount({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    final _innerSpacing = responsiveValue<double>(
      context,
      xs: 16,
      lg: 24,
    );

    return Container(
      padding: const EdgeInsets.only(right: 10, left: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(_innerSpacing),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _theme.colorScheme.tertiaryContainer,
                ),
                child: Column(
                  children: [
                    ..._orderList
                        .map(
                          (order) {
                            return _buildOrderTile(
                              context,
                              orderName: order.$1,
                              quantity: order.$2,
                            );
                          },
                        )
                        .toList()
                        .addBetween(
                          const SizedBox(height: 10),
                        ),
                  ],
                ),
              ),
            ],
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
          //flex: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  orderName,
                  style: _theme.textTheme.bodyMedium?.copyWith(
                    color: _theme.colorScheme.onTertiaryContainer,
                    fontWeight: orderName == "Total Amount"
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

List<(String, int)> get _orderList {
  return [
    (l.S.current.subTotal, 143),
    (l.S.current.discount, 0),
    (l.S.current.tax, 0),
    (l.S.current.shipping, 0),
    (l.S.current.totalAmount, 143),
  ];
}
