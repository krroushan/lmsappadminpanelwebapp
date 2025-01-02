// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../core/helpers/helpers.dart';
import '../../../../widgets/widgets.dart';

import '../../../../../generated/l10n.dart' as l;

class FilterSidebar extends StatefulWidget {
  const FilterSidebar({super.key});

  @override
  State<FilterSidebar> createState() => _FilterSidebarState();
}

class _FilterSidebarState extends State<FilterSidebar> {
  int? selectedCategory;
  List<CategoryModel> get categories =>  [
    CategoryModel(
      id: 1,
      imagePath:
      "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/category_icons/all_category.svg",
      // name: "All Category",
      name: l.S.current.allCategory,
    ),
    CategoryModel(
      id: 2,
      imagePath:
      "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/category_icons/woman_dress.svg",
      //name: "Woman Dress",
      name: l.S.current.womanDress,
    ),
    CategoryModel(
      id: 3,
      imagePath:
      "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/category_icons/t_shirts.svg",
      //name: "T-Shirts",
      name: l.S.current.tShirts,
    ),
    CategoryModel(
      id: 4,
      imagePath:
      "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/category_icons/shoes.svg",
      //name: "Shoes",
      name: l.S.current.shoes,
    ),
    CategoryModel(
      id: 5,
      imagePath:
      "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/category_icons/sunglass.svg",
      //name: "Sun glass",
      name: l.S.current.sunGlass,
    ),
    CategoryModel(
      id: 6,
      imagePath:
      "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/category_icons/woman_bag.svg",
      //name: "Woman Bag",
      name: l.S.current.womanBag,
    ),
    CategoryModel(
      id: 7,
      imagePath:
      "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/category_icons/fresh_food.svg",
      //name: "Fresh Food",
      name:l.S.current.freshFood,
    ),
    CategoryModel(
      id: 8,
      imagePath:
      "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/category_icons/smart_phone.svg",
      //name: "Smart Phone",
      name: l.S.current.smartPhone,
    ),
    CategoryModel(
      id: 9,
      imagePath:
      "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/category_icons/computer.svg",
      //name: "Computer",
      name: l.S.current.computer,
    ),
  ];

  final List<String> statusFilter = [];
  int selectedRating = 5;

  @override
  void initState() {
    super.initState();
    selectedCategory = categories.firstOrNull?.id;
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);

    return Material(
      color: _theme.colorScheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Categories
          _buildSection(
            context,
            //sectionName: 'Categories',
            sectionName: lang.categories,
            child: Column(
              children: List.generate(
                categories.length,
                    (index) {
                  final _category = categories[index];
                  return CategoryTile(
                    category: _category,
                    isSelected: selectedCategory == _category.id,
                    onTap: (id) => setState(() => selectedCategory = id),
                  );
                },
              ),
            ),
          ),

          // Price Range Filter
          _buildSection(
            context,
            //sectionName: 'Price Range',
            sectionName: lang.priceRange,
            child: const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                16,
                12,
                16,
                20,
              ),
              child: CustomRangeSlider(
                barWidth: 2,
              ),
            ),
          ),

          // Product Status
          _buildSection(
            context,
            //sectionName: 'Product Status',
            sectionName: lang.productStatus,
            child: Column(
              children: {
                // "in_stock": "In Stock",
                // "on_sale": "On Sale",
                "in_stock": lang.inStock,
                "on_sale": lang.onSale,
              }.entries.map(
                    (item) {
                  final _value = statusFilter.contains(item.key);
                  return CheckboxListTile(
                    value: _value,
                    onChanged: (v) {
                      if (statusFilter.contains(item.key)) {
                        statusFilter.remove(item.key);
                      } else {
                        statusFilter.add(item.key);
                      }
                      setState(() {});
                    },
                    title: Text(
                      item.value,
                      style: _theme.textTheme.bodyLarge?.copyWith(
                        color: _theme.colorScheme.onTertiaryContainer,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 8,
                    ),
                  );
                },
              ).toList(),
            ),
          ),

          // Star Rating
          _buildSection(
            context,
            //sectionName: 'Star Rating',
            sectionName: lang.starRating,
            child: Container(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(
                  5,
                      (index) {
                    return _buildStar(
                      context,
                      label: (index + 1).toString(),
                      isSelected: index + 1 == selectedRating,
                      onSelect: () {
                        setState(() => selectedRating = index + 1);
                      },
                    );
                  },
                ),
              ),
            ),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required String sectionName,
        required Widget child,
        bool showDivider = true,
      }) {
    final _theme = Theme.of(context);

    return SizedBox(
      width: double.maxFinite,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: !showDivider
              ? null
              : BorderDirectional(
            bottom: BorderSide(
              color: _theme.colorScheme.outline,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Text(
                sectionName,
                style: _theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            child,
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildStar(
      BuildContext context, {
        required String label,
        bool isSelected = false,
        void Function()? onSelect,
      }) {
    final _theme = Theme.of(context);
    final _forgroundColor =
    isSelected ? Colors.white : _theme.colorScheme.onTertiaryContainer;

    return Material(
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: onSelect,
        child: Container(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 10,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: isSelected ? _theme.colorScheme.primary : null,
            border: isSelected
                ? null
                : Border.all(
              color: _theme.colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.star,
                    size: 16,
                    color: _forgroundColor,
                  ),
                ),
                TextSpan(text: " $label"),
              ],
            ),
            style: _theme.textTheme.bodyLarge?.copyWith(
              color: _forgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryModel {
  final int id;
  final String imagePath;
  final String name;
  const CategoryModel({
    required this.id,
    required this.imagePath,
    required this.name,
  });
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  final CategoryModel category;
  final bool isSelected;
  final void Function(int id)? onTap;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _highlightColor = isSelected
        ? _theme.colorScheme.primary
        : _theme.colorScheme.onTertiaryContainer;

    return ListTile(
      visualDensity: const VisualDensity(
        horizontal: -2.75,
        vertical: -4,
      ),
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      onTap: () => onTap?.call(category.id),
      tileColor:
      isSelected ? _theme.colorScheme.primary.withOpacity(0.18) : null,
      leading: AnimageWidget(
        imagePath: category.imagePath,
      ),
      minLeadingWidth: 20,
      title: Text(
        category.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      titleTextStyle: _theme.textTheme.bodyLarge?.copyWith(
        color: _highlightColor,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: _highlightColor,
      ),
    );
  }
}
