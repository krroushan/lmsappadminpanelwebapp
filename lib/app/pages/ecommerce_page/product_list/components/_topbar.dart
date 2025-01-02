// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:iconly/iconly.dart';
import '../../../../../generated/l10n.dart' as l;

// 🌎 Project imports:
import '../../../../core/helpers/fuctions/_overlay_helper.dart';
import '../../../../core/helpers/helpers.dart';

class Topbar extends StatefulWidget {
  const Topbar({
    super.key,
    required this.scaffoldKey,
    this.showDesktop = true,
    this.selectedLayout = ProductLayoutType.tile,
    this.onLayoutSelect,
    this.perPage = 10,
    this.onPerpageChange,
    this.filterId = 1,
    this.onFilterChange,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool showDesktop;
  final ProductLayoutType selectedLayout;
  final void Function(ProductLayoutType value)? onLayoutSelect;
  final int perPage;
  final void Function(int? value)? onPerpageChange;

  final int filterId;
  final void Function(int? value)? onFilterChange;

  @override
  State<Topbar> createState() => _TopbarState();
}

class _TopbarState extends State<Topbar> {
  //--------------------Search Field Props--------------------//
  late final searchFieldFocus = FocusNode();
  bool get showSearch {
    return searchFieldFocus.hasPrimaryFocus || searchController.text.isNotEmpty;
  }

  late final searchController = TextEditingController();
  //--------------------Search Field Props--------------------//

  List<String> get filterList => [
    //'Sort by Popularity',
    l.S.current.sortByPopularity,
    // 'Sort by Newest First',
    l.S.current.sortByNewestFirst,
    //'Sort by Oldest First',
    l.S.current.sortByOldestFirst,
    //'Sort by Price: Low to High',
    l.S.current.sortByPriceLowToHigh,
    //'Sort by Price: High to Low',
    l.S.current.sortByPriceHighToLow,
    //'Sort by Best Rating',
    l.S.current.sortByBestRating,
    //'Sort by Most Reviewed',
    l.S.current.sortByMostReviewed,
    //'Sort by Featured',
    l.S.current.sortByFeatured,
    //'Sort by Relevance',
    l.S.current.sortByRelevance,
    //'Sort by Discount',
    l.S.current.sortByDiscount,
    // 'Sort by Alphabetical: A-Z',
    l.S.current.sortByAlphabeticalAZ,
    //'Sort by Alphabetical: Z-A',
    l.S.current.sortByAlphabeticalZA,
    //'Sort by Closest Location',
    l.S.current.sortByClosestLocation,
    //'Sort by Trending',
    l.S.current.sortByTrending,
    //'Sort by Most Liked',
    l.S.current.sortByMostLiked,
  ];

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _border = BorderSide(color: _theme.colorScheme.outline);
    final _overlayHelper = OverlayHelper(context);

    return CompositedTransformTarget(
      link: _overlayHelper.layerLink,
      child: Container(
        constraints: BoxConstraints.loose(const Size.fromHeight(48)),
        decoration: BoxDecoration(
          color: _theme.colorScheme.primaryContainer,
          border: widget.selectedLayout == ProductLayoutType.border
              ? BorderDirectional(
            start: _border.copyWith(width: 0.5),
            end: _border,
            top: _border,
            bottom: _border,
          )
              : (widget.showDesktop ? BorderDirectional(start: _border) : null),
          borderRadius: const BorderRadiusDirectional.horizontal(
            end: Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Leading Items
            if (widget.showDesktop)
              _buildLayoutSelector(context)
            // Drawer Opener
            else
              IconButton(
                onPressed: () {
                  return widget.scaffoldKey.currentState?.openDrawer();
                },
                icon: const Icon(Icons.menu),
              ),

            // Trailing Items
            Flexible(
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: widget.showDesktop
                    ? IntrinsicWidth(child: _buildBasicFilter(context))
                    : Container(
                  margin: const EdgeInsets.all(8),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (_overlayHelper.overlayEntry == null) {
                        _overlayHelper.showOverlay(
                          offset: const Offset(0, 4),
                          child: _buildMobileFilter(context),
                        );
                      } else {
                        _overlayHelper.hideOverlay();
                      }
                    },
                    // label: const Text('Filter'),
                    label:  Text(lang.filter),
                    icon: const Icon(IconlyLight.filter_2, size: 16),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      visualDensity: const VisualDensity(
                        vertical: -2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLayoutSelector(BuildContext context) {
    final ThemeData(:checkboxTheme) = Theme.of(context);

    return Row(
      children: ProductLayoutType.values.map((layout) {
        final _isSelected = layout == widget.selectedLayout;
        return IconButton(
          onPressed: () => widget.onLayoutSelect?.call(layout),
          isSelected: _isSelected,
          icon: Icon(layout.icon),
          color: _isSelected ? null : checkboxTheme.side?.color,
          iconSize: 20,
          visualDensity: const VisualDensity(),
          padding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final lang = l.S.of(context);
    const _border = OutlineInputBorder(
      borderSide: BorderSide.none,
    );
    return TextField(
      controller: searchController,
      autofocus: true,
      decoration:  InputDecoration(
        //hintText: 'Search...',
        hintText: '${lang.search}...',
        filled: true,
        enabledBorder: _border,
        focusedBorder: _border,
      ),
    );
  }

  Widget _buildBasicFilter(BuildContext context) {
    final ThemeData(:colorScheme, :textTheme) = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Search Field
        if (showSearch) Flexible(child: _buildSearchField(context)),
        IconButton(
          onPressed: () {
            if (!showSearch) {
              return FocusScope.of(context).requestFocus(
                searchFieldFocus,
              );
            }
          },
          icon: const Icon(IconlyLight.search),
          iconSize: 16,
        ),

        VerticalDivider(
          indent: 8,
          endIndent: 8,
          color: colorScheme.outline,
          thickness: 1.25,
        ),

        // Filter Dropdown
        ..._buildDropdownFilters(context),
      ],
    );
  }

  List<Widget> _buildDropdownFilters(BuildContext context) {
    final lang = l.S.of(context);
    final ThemeData(:colorScheme, :textTheme) = Theme.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);
    return [
      Flexible(
        child: DropdownButton2<int>(
          iconStyleData: _dropdownStyle.iconStyle.copyWith(
            iconSize: 16,
          ),
          dropdownStyleData: _dropdownStyle.dropdownStyle.copyWith(
            useRootNavigator: true,
          ),
          menuItemStyleData: _dropdownStyle.menuItemStyle,
          underline: const SizedBox.shrink(),
          selectedItemBuilder: (ctx) => [
            ...filterList.map(
                  (filter) => Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  filter,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
          isExpanded: true,
          value: widget.filterId,
          items: filterList
              .asMap()
              .entries
              .map(
                (f) => DropdownMenuItem<int>(
              value: f.key + 1,
              child: Text(f.value),
            ),
          )
              .toList(),
          onChanged: widget.onFilterChange,
        ),
      ),

      const SizedBox(width: 8),
      VerticalDivider(
        indent: 8,
        endIndent: 8,
        color: colorScheme.outline,
        thickness: 1.25,
      ),

      // Per-page Dropdown
      Flexible(
        child: DropdownButton2(
          iconStyleData: _dropdownStyle.iconStyle.copyWith(
            iconSize: 16,
          ),
          dropdownStyleData: _dropdownStyle.dropdownStyle.copyWith(
            useRootNavigator: true,
          ),
          menuItemStyleData: _dropdownStyle.menuItemStyle,
          underline: const SizedBox.shrink(),
          value: widget.perPage,
          items: List<DropdownMenuItem<int>>.generate(
            10,
                (index) {
              final _item = (index + 1) * 10;
              return DropdownMenuItem<int>(
                value: _item,
                child: Text('${lang.show} $_item'),
              );
            },
          ),
          onChanged: widget.onPerpageChange,
        ),
      ),
    ];
  }

  Widget _buildMobileFilter(BuildContext context) {
    final _theme = Theme.of(context);

    return Material(
      color: _theme.colorScheme.primaryContainer,
      clipBehavior: Clip.antiAlias,
      borderRadius: const BorderRadiusDirectional.vertical(
        bottom: Radius.circular(4),
      ),
      child: Container(
        padding: const EdgeInsetsDirectional.all(10),
        decoration: BoxDecoration(
          color: _theme.colorScheme.primaryContainer,
        ),
        child: Column(
          children: [
            // Search Field
            _buildSearchField(context),

            // Dropdown Filters
            SizedBox(
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _buildDropdownFilters(context),
              ),
            ),

            // Layouts
            _buildLayoutSelector(context)
          ],
        ),
      ),
    );
  }
}

enum ProductLayoutType {
  tile(icon: Icons.menu, label: 'Tile'),
  grid(icon: IconlyLight.category, label: 'Grid'),
  border(icon: Icons.window_outlined, label: 'Border');

  final IconData icon;
  final String? label;
  const ProductLayoutType({required this.icon, this.label});
}
