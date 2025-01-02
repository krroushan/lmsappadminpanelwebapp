// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:feather_icons/feather_icons.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/helpers/field_styles/field_styles.dart';

class EmailTopbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const EmailTopbarWidget({
    super.key,
    this.height,
    required this.scaffoldKey,
    this.isMobile = false,
    this.isAllSelected,
    this.onAllSelect,
  });
  final double? height;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isMobile;
  final bool? isAllSelected;
  final void Function(bool? value)? onAllSelect;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _textFieldStyle = AcnooInputFieldStyles(context);
    final _searchFieldBorder = _textFieldStyle.getRoundedBorder(
      borderColor: Colors.transparent,
    );
    if (isMobile) {
      return Container(
        decoration: BoxDecoration(
          color: _theme.appBarTheme.backgroundColor,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
              icon:  Tooltip(
               // message: 'Open Navigation menu',
                message: lang.openNavigationMenu,
                waitDuration: const Duration(milliseconds: 350),
                child: const Icon(FeatherIcons.menu),
              ),
            ),
            Checkbox(
              value: isAllSelected,
              onChanged: onAllSelect,
              tristate: true,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            ),
            Flexible(
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: _searchFieldBorder,
                  border: _searchFieldBorder,
                  focusedBorder: _searchFieldBorder,
                  //hintText: 'Search...',
                  hintText: '${lang.search}...',
                ),
              ),
            ),
          ],
        ),
      );
    }

    final _larSearchBorder = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
      borderRadius: BorderRadius.circular(8),
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(21, 12, 8, 12),
      decoration: BoxDecoration(
        color: _theme.appBarTheme.backgroundColor,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Checkbox(
                  value: isAllSelected,
                  onChanged: onAllSelect,
                  tristate: true,
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                ),
                Icon(
                  FeatherIcons.chevronDown,
                  color: _theme.checkboxTheme.side?.color,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(FeatherIcons.rotateCw),
                  color: _theme.colorScheme.onTertiary,
                ),
                PopupMenuButton<String>(
                  itemBuilder: (context) => [],
                  onSelected: (value) {},
                  iconColor: _theme.colorScheme.onTertiary,
                ),
                const SizedBox(width: 16),
                Flexible(
                  flex: 8,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '${lang.search}...',
                      enabledBorder: _larSearchBorder,
                      border: _larSearchBorder,
                      focusedBorder: _larSearchBorder,
                      filled: true,
                      suffixIcon: Container(
                        padding: const EdgeInsets.all(4),
                        child: IconButton.filled(
                          onPressed: () {},
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          icon: const Icon(FeatherIcons.search),
                          color: _theme.colorScheme.onPrimary,
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(
                            horizontal: -4,
                            vertical: -4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(FeatherIcons.chevronLeft),
            color: _theme.colorScheme.onTertiary,
          ),
          Text(
            '1-50 of 1500',
            style: _theme.textTheme.bodyLarge,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(FeatherIcons.chevronRight),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}
