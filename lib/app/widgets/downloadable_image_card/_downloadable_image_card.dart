// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:feather_icons/feather_icons.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../core/helpers/fuctions/helper_functions.dart';

class DownloadableImageCard extends StatefulWidget {
  const DownloadableImageCard({
    super.key,
    required this.imagePath,
    this.name,
    this.action = const [
      DownloadableImageCardAction.download,
      DownloadableImageCardAction.preview,
      DownloadableImageCardAction.delete,
    ],
  });

  final String imagePath;
  final String? name;
  final List<DownloadableImageCardAction> action;

  @override
  State<DownloadableImageCard> createState() => _DownloadableImageCardState();
}

class _DownloadableImageCardState extends State<DownloadableImageCard> {
  bool isHovering = false;
  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  bool get _hasDownload =>
      widget.action.contains(DownloadableImageCardAction.download);
  bool get _hasPreview =>
      widget.action.contains(DownloadableImageCardAction.preview);
  bool get _hasDelete =>
      widget.action.contains(DownloadableImageCardAction.delete);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => changeHoverState(true),
      onExit: (event) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => changeHoverState(!isHovering),
        child: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimageWidget(
                  imagePath: widget.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              if (isHovering)
                Positioned.fill(
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    color: Colors.black.withOpacity(0.375),
                    child: _buildHoverOverlay(context, name: widget.name),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHoverOverlay(
    BuildContext context, {
    String? name,
  }) {
    final _theme = Theme.of(context);
    const _foregroundColor = Colors.white;

    Widget _buildIconHolder(IconData icon) {
      return Container(
        padding: EdgeInsets.all(
          responsiveValue<double>(context, xs: 4, lg: 8),
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _foregroundColor.withOpacity(0.40),
          border: Border.all(
            color: _foregroundColor,
          ),
        ),
        child: Icon(
          icon,
          color: _foregroundColor,
          size: responsiveValue<double>(context, xs: 18, md: 20, lg: 24),
        ),
      );
    }

    final _buttonStyle = IconButton.styleFrom(
      padding: EdgeInsets.zero,
      visualDensity: const VisualDensity(
        horizontal: -4,
        vertical: -4,
      ),
    );

    final _spacer = responsiveValue<double>(context, xs: 6, lg: 16);

    return LayoutBuilder(
      builder: (context, constraints) {
        final _size = constraints.biggest;

        return Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_hasDownload)
                    IconButton(
                      onPressed: () {},
                      style: _buttonStyle,
                      icon: _buildIconHolder(FeatherIcons.download),
                    ),
                  if (_hasDownload) SizedBox(width: _spacer),
                  if (_hasPreview)
                    IconButton(
                      onPressed: () {},
                      style: _buttonStyle,
                      icon: _buildIconHolder(FeatherIcons.eye),
                    ),
                  if (_hasPreview) SizedBox(width: _spacer),
                  if (_hasDelete)
                    IconButton(
                      onPressed: () {},
                      style: _buttonStyle,
                      icon: _buildIconHolder(FeatherIcons.trash2),
                    ),
                ],
              ),
            ),
            if (name != null)
              Positioned(
                left: 16,
                bottom: 12,
                right: 8,
                child: SizedBox(
                  width: _size.width - (16 + 8),
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _theme.textTheme.bodyMedium?.copyWith(
                      color: _foregroundColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

enum DownloadableImageCardAction { download, preview, delete }
