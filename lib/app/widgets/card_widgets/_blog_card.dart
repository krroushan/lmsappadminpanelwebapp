part of 'card_widgets.dart';

class BlogCardWidget extends StatefulWidget {
  const BlogCardWidget({
    super.key,
    required this.title,
    this.description,
    this.image,
    this.cardWidgetType = BlogCardWidgetType.contentBL,
    this.isLoading = true,
    this.lectureId,
    this.className,
    this.board,
    this.subject,
    this.lectureType,
    this.createdBy,
    this.createdDate,
    required this.onDelete,
    this.streamId,
  });
  final String title;
  final String? description;
  final ImageProvider<Object>? image;
  final BlogCardWidgetType cardWidgetType;
  final bool isLoading;
  final String? lectureId;
  final String? createdBy;
  final DateTime? createdDate;
  final String? board;
  final String? className;
  final String? subject;
  final Future<void> Function(String?) onDelete;  // Add this line
  final String? lectureType;
  final String? streamId;
  @override
  State<BlogCardWidget> createState() => _BlogCardWidgetState();
}

class _BlogCardWidgetState extends State<BlogCardWidget> {
  bool isHovering = false;
  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    final _contentTextAlign = switch (widget.cardWidgetType) {
      BlogCardWidgetType.contentBL ||
      BlogCardWidgetType.contentTL =>
        TextAlign.left,
      BlogCardWidgetType.contentBR ||
      BlogCardWidgetType.contentTR =>
        TextAlign.right,
      BlogCardWidgetType.contentBC ||
      BlogCardWidgetType.contentTC =>
        TextAlign.center,
    };
    final _columCrossAxisAlignment = switch (widget.cardWidgetType) {
      BlogCardWidgetType.contentBC ||
      BlogCardWidgetType.contentTC =>
        CrossAxisAlignment.center,
      BlogCardWidgetType.contentBR ||
      BlogCardWidgetType.contentTR =>
        CrossAxisAlignment.end,
      BlogCardWidgetType.contentBL ||
      BlogCardWidgetType.contentTL =>
        CrossAxisAlignment.start,
    };

    final _shimmerLoadingColor =
        _isDark ? AcnooAppColors.kDark3 : AcnooAppColors.kNeutral200;

    final _cardContents = [
      // Image Container
      if (widget.isLoading)
        ShimmerPlaceholder(
          height: 140,
          width: double.maxFinite,
          color: _shimmerLoadingColor,
        )
      else
        Container(
          height: 140,
          decoration: BoxDecoration(
            image: widget.image == null
                ? null
                : DecorationImage(image: widget.image!, fit: BoxFit.cover),
          ),
        ),

      // Text Contents
      Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: _columCrossAxisAlignment,
          children: [
            // Title Text
            if (widget.isLoading)
              ShimmerPlaceholder(
                color: _shimmerLoadingColor,
              )
            else
              Row(
                children: [
                  ElevatedButton(
                    onPressed: null,
                    child: Text(
                      widget.board ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      disabledBackgroundColor: Colors.blue.shade50,
                      disabledForegroundColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 4),
                  ElevatedButton(
                    onPressed: null,
                    child: Text(
                      widget.className ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade50,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      disabledBackgroundColor: Colors.green.shade50,
                      disabledForegroundColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 4),
                  ElevatedButton(
                    onPressed: null,
                    child: Text(
                      widget.subject ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      disabledBackgroundColor: Colors.red.shade50,
                      disabledForegroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SelectableText(
                widget.title,
                textAlign: _contentTextAlign,
                style: _theme.textTheme.headlineLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 4),

            // Description
            if (widget.isLoading)
              Column(
                crossAxisAlignment: _columCrossAxisAlignment,
                children: [
                  ShimmerPlaceholder(
                    color: _shimmerLoadingColor,
                    width: double.maxFinite,
                  ),
                  ShimmerPlaceholder(
                    color: _shimmerLoadingColor,
                    width: 300,
                  ),
                  ShimmerPlaceholder(
                    color: _shimmerLoadingColor,
                    width: double.maxFinite,
                  ),
                  ShimmerPlaceholder(
                    color: _shimmerLoadingColor,
                    width: double.maxFinite,
                  ),
                ]
                    .map((e) => Padding(
                        padding:
                            const EdgeInsetsDirectional.symmetric(vertical: 2),
                        child: e))
                    .toList(),
              )
            else
              Text('Created By: ${widget.createdBy ?? ''}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                'Created Date: ${widget.createdDate?.toLocal().toString().split(' ')[0] ?? ''}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            const SizedBox(height: 16),

            if (widget.isLoading)
              ShimmerPlaceholder(
                height: 48,
                decoration: BoxDecoration(
                  color: _shimmerLoadingColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      context.go('/dashboard/lectures/view-lecture/${widget.lectureId}');
                    },
                    icon: const Icon(Icons.visibility),
                    color: Colors.grey,
                  ),
                  IconButton(
                    onPressed: () {
                      context.go('/dashboard/lectures/edit-lecture/${widget.lectureId}');
                    },
                    icon: const Icon(Icons.edit),
                    color: Colors.blue,
                  ),
                  IconButton(
                    onPressed: () async {
                      await widget.onDelete(widget.lectureId);
                    },
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                  ),
                  if (widget.lectureType == 'live')
                    IconButton(
                      onPressed: () {
                        context.go('/dashboard/lectures/publish-live-stream/${widget.streamId}');
                      },
                      icon: const Icon(Icons.video_call),
                      color: Colors.green,
                    )
                  else
                    IconButton(
                      onPressed: () {
                        context.go('/dashboard/lectures/play-lecture/${widget.lectureId}');
                      },
                      icon: const Icon(Icons.play_arrow),
                      color: Colors.green,
                  ),
                ],
              ),
          ],
        ),
      ),
    ];

    return MouseRegion(
      onEnter: (event) => changeHoverState(true),
      onExit: (event) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: Material(
        color: _theme.colorScheme.primaryContainer,
        elevation: isHovering ? 4.75 : 0,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: _columCrossAxisAlignment,
          children: switch (widget.cardWidgetType) {
            BlogCardWidgetType.contentTC ||
            BlogCardWidgetType.contentTL ||
            BlogCardWidgetType.contentTR =>
              _cardContents.reversed.toList(),
            _ => _cardContents,
          },
        ),
      ),
    );
  }
}

enum BlogCardWidgetType {
  /// Content Bottom Left
  contentBL,

  /// Content Bottom Right
  contentBR,

  /// Content Bottom Center
  contentBC,

  /// Content Top Left
  contentTL,

  /// Content Top Right
  contentTR,

  /// Content Top Center
  contentTC,
}
