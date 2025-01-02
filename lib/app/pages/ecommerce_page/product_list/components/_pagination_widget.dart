import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  const PaginationWidget({
    super.key,
    required this.totalItem,
    required this.currentPage,
    required this.perPage,
    this.onPreviousPressed,
    this.onNextPressed,
    this.onPagePress,
  });
  final int totalItem;
  final int currentPage;
  final int perPage;

  final void Function(int page)? onPreviousPressed;
  final void Function(int page)? onNextPressed;
  final void Function(int page)? onPagePress;

  static int _pageCount = 0;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    _pageCount = (totalItem / perPage).ceil();

    final _iconColor = _theme.colorScheme.onTertiaryContainer;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: currentPage == 1
              ? null
              : () => onPreviousPressed?.call(currentPage - 1),
          iconSize: 20,
          color: _iconColor,
          icon: const Icon(Icons.arrow_back),
        ),
        ...List.generate(
          _pageCount,
          (index) {
            final _pageNumber = index + 1;
            final _isActive = _pageNumber == currentPage;

            return Container(
              constraints: BoxConstraints.tight(const Size.square(30)),
              margin: EdgeInsetsDirectional.only(
                end: _pageNumber == _pageCount ? 0 : 8,
              ),
              child: OutlinedButton(
                onPressed: () => onPagePress?.call(_pageNumber),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                  textStyle: _theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: !_isActive ? null : _theme.primaryColor,
                  foregroundColor: _isActive
                      ? _theme.colorScheme.onPrimary
                      : _theme.colorScheme.primary,
                  side: _isActive
                      ? BorderSide.none
                      : BorderSide(color: _theme.colorScheme.primary),
                ),
                child: Text("$_pageNumber"),
              ),
            );
          },
        ),
        IconButton(
          onPressed: currentPage == _pageCount
              ? null
              : () => onNextPressed?.call(currentPage + 1),
          iconSize: 20,
          color: _iconColor,
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  static int get pageCount => _pageCount;
}
