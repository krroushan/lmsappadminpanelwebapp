// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:feather_icons/feather_icons.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/theme/theme.dart';

class AiChatSidebar extends StatelessWidget {
  const AiChatSidebar({super.key, required this.page});
  final StatefulNavigationShell page;

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final _searchBorder = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    );

    return Drawer(
      shape: const RoundedRectangleBorder(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: _theme.colorScheme.outline,
            ),
          ),
        ),
        child: Column(
          children: [
            // Search Field
            Container(
              margin: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: _searchBorder,
                  focusedBorder: _searchBorder,
                  filled: true,
                  fillColor: _theme.colorScheme.tertiaryContainer,
                  //hintText: 'Search',
                  hintText: lang.search,
                  prefixIcon: const Icon(FeatherIcons.search),
                ),
              ),
            ),

            // Chat List
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 30,
                itemBuilder: (context, index) {
                  return AiChatTileWidget(
                    tileColor: index % 3 <= 0
                        ? (_isDark
                            ? AcnooAppColors.kDark3
                            : AcnooAppColors.kPrimary50)
                        : null,
                  );
                },
              ),
            ),

            // New Conversation Button
            Container(
              margin: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -1,
                  ),
                  // padding: EdgeInsets.zero,
                ),
                //child: const Text('New Conversation'),
                child:  Text(lang.newConversation),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AiChatTileWidget extends StatefulWidget {
  const AiChatTileWidget({
    super.key,
    this.tileColor,
  });
  final Color? tileColor;

  @override
  State<AiChatTileWidget> createState() => _AiChatTileWidgetState();
}

class _AiChatTileWidgetState extends State<AiChatTileWidget> {
  bool isHovering = false;
  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    final _actionButtonStyle = IconButton.styleFrom(
      visualDensity: const VisualDensity(
        horizontal: -4,
        vertical: -4,
      ),
      padding: const EdgeInsets.all(8),
    );
    final _actionButtonColor =
        _isDark ? AcnooAppColors.kNeutral400 : AcnooAppColors.kNeutral500;

    return MouseRegion(
      onEnter: (event) => changeHoverState(true),
      onExit: (event) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.tileColor,
            border: Border(
              bottom: BorderSide(
                color: _theme.colorScheme.outline,
              ),
            ),
          ),
          child: ListTile(
            tileColor: Colors.transparent,
            title: Row(
              children: [
                Text(
                  lang.newConversation,
                  //'New Conversation',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),

                // Actions Button
                if (isHovering) ...[
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(FeatherIcons.edit),
                    style: _actionButtonStyle,
                    color: _actionButtonColor,
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(FeatherIcons.trash2),
                    style: _actionButtonStyle,
                    color: _actionButtonColor,
                    iconSize: 20,
                  ),
                ],
              ],
            ),
            minVerticalPadding: 12,
            subtitle: Row(
              children: [
                Text(
                  //lang.messagen,
                   lang.message,
                  style: _theme.textTheme.bodyMedium?.copyWith(
                    color: _theme.colorScheme.onTertiary,
                  ),
                ),
                const Spacer(),
                Text(
                  lang.hoursAgo,
                  //'15 hours ago',
                  style: _theme.textTheme.bodyMedium?.copyWith(
                    color: _actionButtonColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
