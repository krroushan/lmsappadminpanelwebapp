// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../core/helpers/helpers.dart';
import '../../../../models/models.dart' show eCommerceMockproducts;

// [ NOTE: This import is only for fake data, and can be removed]

class ProductImageViewer extends StatefulWidget {
  const ProductImageViewer({super.key, this.imageURLs = const []});

  final List<String> imageURLs;

  @override
  State<ProductImageViewer> createState() => _ProductImageViewerState();
}

class _ProductImageViewerState extends State<ProductImageViewer> {
  final List<String> imageURLs = [];

  double _scale = 1.0;
  Offset _position = Offset.zero;

  String currentImage = '';
  void changeImage(String path) {
    setState(() => currentImage = path);
  }

  @override
  void initState() {
    imageURLs.clear();
    imageURLs.addAll(
      widget.imageURLs.isEmpty
          ? eCommerceMockproducts.map((e) => e.imagePath)
          : widget.imageURLs,
    );
    currentImage = imageURLs.isNotEmpty ? imageURLs.first : '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Column(
      children: [
        // Image Slider
        AspectRatio(
          aspectRatio: 1.2,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              border: Border.all(
                color: _theme.colorScheme.outline,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final _maxedZoom = _scale >= 3;
                return MouseRegion(
                  cursor: _maxedZoom
                      ? SystemMouseCursors.zoomOut
                      : SystemMouseCursors.zoomIn,
                  onEnter: (_) => setState(() => _scale = 1.25),
                  onExit: (_) => setState(() {
                    _scale = 1.0;
                    _position = Offset.zero;
                  }),
                  onHover: (event) {
                    final localPosition = event.localPosition;
                    setState(() => _position = localPosition);
                  },
                  child: Listener(
                    onPointerDown: (event) {
                      if (event.buttons == 1 && _scale < 3) {
                        setState(() => _scale += 1);
                      } else if (event.buttons == 2) {
                        setState(
                              () => _scale = (_scale < 2) ? 1 : (_scale -= 1),
                        );
                      }
                    },
                    child: Transform(
                      alignment: Alignment(
                        (_position.dx / constraints.maxWidth) * 2 - 1,
                        (_position.dy / constraints.maxHeight) * 2 - 1,
                      ),
                      transform: Matrix4.identity()..scale(_scale),
                      child: AnimageWidget(imagePath: currentImage),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Image List
        AspectRatio(
          aspectRatio: 3.015,
          // aspectRatio: 3.225,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0.35),
            scrollDirection: Axis.horizontal,
            itemCount: imageURLs.length,
            itemBuilder: (context, index) {
              final _image = imageURLs[index];

              return DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _theme.colorScheme.outline,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
                child: InkWell(
                  onTap: () => changeImage(_image),
                  mouseCursor: SystemMouseCursors.click,
                  child: AnimageWidget(imagePath: _image),
                ),
              );
            },
            separatorBuilder: (c, i) => const SizedBox.square(dimension: 16),
          ),
        ),
      ],
    );
  }
}
