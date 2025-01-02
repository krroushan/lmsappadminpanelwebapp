// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart';

// 🌎 Project imports:
import '../../../../../../generated/l10n.dart' as l;
import '../../../../../core/theme/theme.dart';

class OrderListTile extends StatelessWidget {
  const OrderListTile({
    super.key,
    required this.orderNumber,
    required this.orderTitle,
    required this.orderDate,
    required this.orderStatus,
  });
  final String orderNumber;
  final String orderTitle;
  final DateTime orderDate;
  final OrderStatus orderStatus;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  orderNumber,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _theme.textTheme.bodySmall?.copyWith(
                    color: _isDark
                        ? AcnooAppColors.kPrimary200
                        : _theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  orderTitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: _theme.textTheme.bodyLarge?.copyWith(
                    color: _theme.colorScheme.onTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  _getFormattedDate(orderDate),
                  style: _theme.textTheme.bodyMedium?.copyWith(
                    color: _theme.colorScheme.onTertiary,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: orderStatus.statusColor?.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  orderStatus.getLocalizedDisplayName(),
                  style: _theme.textTheme.bodyMedium?.copyWith(
                    color: orderStatus.statusColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getFormattedDate(DateTime date) {
    final _today = DateTime.parse(DateTime.now().toString().substring(0, 10));
    final _date = DateTime.parse(date.toString().substring(0, 10));
    String _formatter = 'dd MMM yy';

    if (_date.isAtSameMomentAs(_today)) {
      _formatter = 'hh:mm a';
    }

    return DateFormat(_formatter).format(date);
  }
}

enum OrderStatus {
  pending(
    displayName: 'Pending',
    statusColor: AcnooAppColors.kWarning,
  ),
  approved(
    displayName: 'Approved',
    statusColor: AcnooAppColors.kSuccess,
  ),
  canceled(
    displayName: 'Canceled',
    statusColor: AcnooAppColors.kError,
  );

  final String displayName;
  final Color? statusColor;
  const OrderStatus({
    required this.displayName,
    this.statusColor,
  });

  String getLocalizedDisplayName() {
    return switch (this) {
      OrderStatus.pending => l.S.current.pending,
      OrderStatus.approved => l.S.current.approved,
      OrderStatus.canceled => l.S.current.cancel,
    };
  }
}
