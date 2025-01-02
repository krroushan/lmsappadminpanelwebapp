// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/theme/theme.dart';
import '../../../models/models.dart';

class EmailTile extends StatelessWidget {
  const EmailTile({
    super.key,
    required this.email,
    this.isSelected = false,
    this.onTap,
    this.onSelect,
    this.onStarTap,
  });
  final EmailModel email;
  final bool isSelected;
  final void Function()? onTap;
  final void Function(bool? value)? onSelect;
  final void Function()? onStarTap;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final lang = l.S.of(context);
    final _mqSize = MediaQuery.sizeOf(context);
    final _isMobile = _mqSize.width < 768;

    final _isNew = email.timestamp.isAfter(
      DateTime.now().subtract(
        const Duration(days: 2),
      ),
    );

    final _textStyle = _theme.textTheme.bodyLarge?.copyWith(
      color: email.hasRead ? _theme.colorScheme.onTertiary : null,
      fontWeight: FontWeight.w500,
    );
    final _tileDecoration = BoxDecoration(
      color: email.hasRead
          ? (_isDark ? AcnooAppColors.kDark3 : AcnooAppColors.kNeutral50)
              .withOpacity(0.75)
          : _theme.colorScheme.primaryContainer,
      border: Border(
        bottom: BorderSide(
          color: _theme.colorScheme.outline,
          width: 0.75,
        ),
      ),
    );

    if (_isMobile) {
      return InkWell(
        onTap: onTap,
        child: Container(
          key: const ValueKey('Small_Device_Design'),
          padding: const EdgeInsets.all(10),
          decoration: _tileDecoration,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: isSelected,
                onChanged: onSelect,
                visualDensity:
                    const VisualDensity(horizontal: -4, vertical: -4),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              email.sender,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _textStyle?.copyWith(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Text(
                            getFormatedDate(email.timestamp),
                            style: _textStyle?.copyWith(
                              fontSize: 13.5,
                              color: _theme.colorScheme.onTertiary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              email.body,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: onStarTap,
                            iconSize: 20,
                            visualDensity: const VisualDensity(
                              horizontal: -4,
                              vertical: -4,
                            ),
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            icon: Icon(
                              email.isStarred
                                  ? IconlyBold.star
                                  : IconlyLight.star,
                              color: email.isStarred
                                  ? _theme.colorScheme.primary
                                  : _theme.checkboxTheme.side?.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        key: const ValueKey('Large_Device_Design'),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: _tileDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 16),
            Checkbox(value: isSelected, onChanged: onSelect),
            IconButton(
              onPressed: onStarTap,
              icon: Icon(
                email.isStarred ? IconlyBold.star : IconlyLight.star,
                color: email.isStarred
                    ? _theme.colorScheme.primary
                    : _theme.checkboxTheme.side?.color,
              ),
            ),
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      email.sender,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _textStyle,
                    ),
                  ),
                  if (_isNew)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        lang.New,
                        //'New',
                        style: _theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: _theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                ],
              ),
            ),
            Expanded(
              flex: 12,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Text.rich(
                  TextSpan(
                    text: '${email.subject} - ',
                    children: [
                      TextSpan(
                        text: email.body,
                        style: TextStyle(
                          color: _isDark
                              ? AcnooAppColors.kNeutral500
                              : AcnooAppColors.kNeutral700.withOpacity(0.80),
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _textStyle,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 24),
              child: Text(
                getFormatedDate(email.timestamp),
                style: _textStyle,
              ),
            )
          ],
        ),
      ),
    );
  }

  String getFormatedDate(DateTime date) {
    final _today = DateTime.now();
    final _isToday = DateTime.parse(date.toString().substring(0, 10)) ==
        DateTime.parse(_today.toString().substring(0, 10));
    if (_isToday) {
      return DateFormat(DateFormat.HOUR_MINUTE).format(date);
    }

    return DateFormat('MMM d').format(date);
  }
}
