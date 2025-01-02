// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../core/theme/theme.dart';
import '../../../../widgets/widgets.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    this.userImagePath,
    this.showMyImage = false,
    required this.message,
    this.isSendByMe = false,
  });
  final String? userImagePath;
  final bool showMyImage;
  final String message;
  final bool isSendByMe;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    final _lightBubbleColor =
        isSendByMe ? _theme.colorScheme.primary : AcnooAppColors.kNeutral100;
    final _darkBubbleColor =
        isSendByMe ? _theme.colorScheme.primary : AcnooAppColors.kDark3;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          isSendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSendByMe) ...[
          _buildAvatar(),
          const SizedBox(width: 16),
        ],
        Flexible(
          child: IntrinsicWidth(
            child: Container(
              alignment:
                  isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
              decoration: BoxDecoration(
                color: _isDark ? _darkBubbleColor : _lightBubbleColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                message,
                style: _theme.textTheme.bodyMedium?.copyWith(
                  color: isSendByMe
                      ? _theme.colorScheme.onPrimary
                      : _theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          ),
        ),
        if (showMyImage && isSendByMe) ...[
          const SizedBox(width: 16),
          _buildAvatar()
        ],
      ],
    );
  }

  Widget _buildAvatar() {
    return AvatarWidget(
      imagePath: userImagePath,
      size: const Size.square(40),
    );
  }
}
