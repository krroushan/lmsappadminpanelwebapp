// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/static/static.dart';
import '../../../core/theme/theme.dart';

class EmailSidebarWidget extends StatefulWidget {
  const EmailSidebarWidget({super.key, this.onSelect});

  final void Function()? onSelect;

  @override
  State<EmailSidebarWidget> createState() => _EmailSidebarWidgetState();
}

class _EmailSidebarWidgetState extends State<EmailSidebarWidget> {
  List<EmailSidebarNavItem> get navItems {
    return <EmailSidebarNavItem>[
      EmailSidebarNavItem(
        navigationPath: '/email/inbox',
        iconPath: AcnooSVGIcons.emailIcon,
        // title: 'Inbox',
        title: l.S.current.inbox,
        label: '10',
      ),
      EmailSidebarNavItem(
        navigationPath: '/email/starred',
        iconPath: AcnooSVGIcons.starIcon,
        // title: 'Starred',
        title: l.S.current.starred,
      ),
      EmailSidebarNavItem(
        navigationPath: '/email/sent',
        iconPath: AcnooSVGIcons.sendIcon,
        //title: 'Sent',
        title: l.S.current.sent,
      ),
      EmailSidebarNavItem(
        navigationPath: '/email/drafts',
        iconPath: AcnooSVGIcons.editIcon,
        label: '17',
        //title: 'Drafts',
        title: l.S.current.drafts,
      ),
      EmailSidebarNavItem(
        navigationPath: '/email/spam',
        iconPath: AcnooSVGIcons.infoIcon,
        //title: 'Spam',
        title: l.S.current.spam,
      ),
      EmailSidebarNavItem(
        navigationPath: '/email/trash',
        iconPath: AcnooSVGIcons.trashCanIcon,
        // title: 'Trash',
        title: l.S.current.trash,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final _lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _mqSize = MediaQuery.sizeOf(context);
    final _isDesktop = _mqSize.width >= 1240;

    return Drawer(
      width: _isDesktop ? 360 : null,
      shape: RoundedRectangleBorder(
        borderRadius:
            _isDesktop ? BorderRadius.circular(12) : BorderRadius.zero,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(_isDesktop ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compose Button
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton.icon(
                onPressed: () {},
                // label:  Text('Compose'),
                label: Text(_lang.compose),
                icon: const Icon(Icons.add_circle_outline_rounded),
              ),
            ),
            const SizedBox(height: 16),

            // Navigation Buttons
            ListView.separated(
              itemCount: navItems.length,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                final _navItem = navItems[index];
                return _buildNavigationTile(
                  context,
                  item: _navItem,
                  isSelected: () {
                    final _currentRoute = GoRouter.of(context)
                        .routerDelegate
                        .currentConfiguration
                        .fullPath;
                    if (_currentRoute == _navItem.navigationPath) {
                      return true;
                    }

                    return false;
                  },
                  onTap: () async {
                    if (widget.onSelect != null) {
                      widget.onSelect?.call();
                      await Future.delayed(
                        const Duration(milliseconds: 150),
                      );
                    }

                    if (context.mounted) {
                      context.go(_navItem.navigationPath);
                      setState(() {});
                    }
                  },
                );
              },
              separatorBuilder: (c, i) => const SizedBox(height: 4),
            ),
            const SizedBox(height: 12),

            // Tags
            Text(
              _lang.tags,
              //'Tags',
              style: _theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 7),

            ...{
              // "Personal": AcnooAppColors.kPrimary600,
              // "Business": AcnooAppColors.kSuccess,
              // "Family": AcnooAppColors.kWarning,
              // "Promotions": AcnooAppColors.kInfo,
              // "Social": AcnooAppColors.kError,

              _lang.personal: AcnooAppColors.kPrimary600,
              _lang.business: AcnooAppColors.kSuccess,
              _lang.family: AcnooAppColors.kWarning,
              _lang.promotions: AcnooAppColors.kInfo,
              _lang.social: AcnooAppColors.kError,
            }.entries.map(
              (tag) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: _buildTag(
                    context,
                    label: tag.key,
                    color: tag.value,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationTile(
    BuildContext context, {
    required EmailSidebarNavItem item,
    bool Function()? isSelected,
    void Function()? onTap,
  }) {
    final _theme = Theme.of(context);

    final _isSelected = isSelected?.call() ?? false;
    final _selectedColor = _isSelected
        ? _theme.colorScheme.primary
        : _theme.colorScheme.onTertiary;

    final _leadingWidget = item.icon != null
        ? Icon(item.icon, color: _selectedColor)
        : item.iconPath != null
            ? SvgPicture.asset(
                item.iconPath!,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(_selectedColor, BlendMode.srcIn),
              )
            : const SizedBox.shrink();

    return ListTile(
      onTap: onTap,
      tileColor: (_isSelected ? _selectedColor : null)?.withOpacity(0.20),
      contentPadding: const EdgeInsets.only(left: 16, right: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      leading: _leadingWidget,
      title: Text(
        item.title,
        style: _theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: _isSelected ? _selectedColor : _theme.colorScheme.onTertiary,
        ),
      ),
      trailing: item.label == null
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: _isSelected
                    ? _theme.colorScheme.tertiaryContainer
                    : _theme.colorScheme.primary.withOpacity(0.20),
              ),
              child: Text(
                item.label ?? '',
                style: _theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _theme.colorScheme.primary,
                ),
              ),
            ),
    );
  }

  Widget _buildTag(
    BuildContext context, {
    String label = 'N/A',
    Color color = Colors.red,
  }) {
    final _theme = Theme.of(context);
    return Row(
      children: [
        Container(
          constraints: BoxConstraints.tight(const Size.square(8)),
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: _theme.textTheme.bodyLarge?.copyWith(
            color: _theme.colorScheme.onTertiary,
          ),
        ),
      ],
    );
  }
}

class EmailSidebarNavItem {
  final String navigationPath;
  final IconData? icon;
  final String? iconPath;
  final String title;
  final String? label;
  const EmailSidebarNavItem({
    required this.navigationPath,
    this.icon,
    this.iconPath,
    required this.title,
    this.label,
  }) : assert(icon == null || iconPath == null);
}
