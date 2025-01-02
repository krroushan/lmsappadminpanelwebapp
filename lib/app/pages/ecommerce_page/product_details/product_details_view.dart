// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../../generated/l10n.dart' as l;

// 🌎 Project imports:
import '../../../core/theme/theme.dart';
import '../../../models/models.dart' show eCommerceMockproducts;
import '../../../widgets/widgets.dart';
import '../components/components.dart' as g_comp;
import 'components/components.dart' as l_comp;

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView>
    with SingleTickerProviderStateMixin {
  bool isFavorite = false;

  // Tab Properties
  late final tabController = TabController(length: 2, vsync: this);

  late final relatedProductScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        tabController.animation?.addListener(() => setState(() {}));
      },
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    relatedProductScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _padding = responsiveValue<double>(context, xs: 6.4, lg: 9.6);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShadowContainer(
              margin: EdgeInsets.all(_padding),
              contentPadding: EdgeInsets.zero,
              showHeader: false,
              child: ResponsiveGridRow(
                children: [
                  // Product Images
                  ResponsiveGridCol(
                    md: 4,
                    child: Padding(
                      padding: EdgeInsets.all(_padding * 2.5),
                      child: const l_comp.ProductImageViewer(),
                    ),
                  ),

                  // Product Info
                  ResponsiveGridCol(
                    md: 8,
                    child: Padding(
                      padding: responsiveValue<EdgeInsetsGeometry>(
                        context,
                        xs: EdgeInsets.symmetric(horizontal: _padding * 2.5),
                        md: EdgeInsetsDirectional.only(
                          start: 24,
                          top: _padding * 2.5,
                          end: _padding * 2.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name
                          Text(
                            'Natures Deli Chicken & Rice Meatballs 100g | Just for Pets',
                            style: _theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),

                          // Category Name
                          Text(
                            'Food',
                            style: _theme.textTheme.bodyLarge?.copyWith(),
                          ),
                          const SizedBox(height: 2),

                          // Rating & Review
                          const g_comp.RatingNReviews(
                            rating: 5,
                            reviews: 200,
                          ),
                          const SizedBox(height: 10),

                          // Stock Indicator
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AcnooAppColors.kSuccess20Op,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              lang.inStock,
                              //'In Stock',
                              style: _theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AcnooAppColors.kSuccess,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Discount & Price
                          ConstrainedBox(
                            constraints: BoxConstraints.loose(
                              const Size.fromWidth(225),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                g_comp.PriceDiscountBuilder(
                                  price: 7.90,
                                  discountPrice: 5.90,
                                  fontSize: 24,
                                ),
                                g_comp.DiscountChip(discountAmount: 20),
                              ],
                            ),
                          ),
                          const SizedBox(height: 36),

                          // Action Buttons
                          Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: [
                              // Quantity Counter
                              const SizedBox(
                                height: 44,
                                width: 145,
                                child: CounterField(),
                              ),

                              // Add To Cart
                              SizedBox(
                                height: 44,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  // label: const Text('Add to Cart'),
                                  label: Text(lang.addToCart),
                                  icon: const Icon(
                                    Icons.shopping_cart_outlined,
                                  ),
                                  iconAlignment: IconAlignment.end,
                                ),
                              ),

                              // Add To Favorite
                              SizedBox(
                                height: 44,
                                child: IconButton.outlined(
                                  onPressed: () => setState(
                                    () => isFavorite = !isFavorite,
                                  ),
                                  icon: Icon(
                                    isFavorite
                                        ? IconsaxPlusBold.heart
                                        : IconsaxPlusLinear.heart,
                                    color: isFavorite
                                        ? _theme.colorScheme.primary
                                        : null,
                                  ),
                                  style: IconButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: isFavorite
                                        ? BorderSide(
                                            color: _theme.colorScheme.primary,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Description
                          ...{
                            "SKU": "1D0MX8SJ",
                            "LIFE": "6 Months",
                            "Type": "Original",
                            "Tags": "Beverages, Dairy & Bakery",
                          }.entries.map(
                                (e) => _buildDescription(
                                  context,
                                  e,
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),

                  // Reviews & Description
                  ResponsiveGridCol(
                    child: Padding(
                      padding: responsiveValue<EdgeInsetsGeometry>(
                        context,
                        xs: const EdgeInsets.only(top: 24),
                        md: EdgeInsets.symmetric(horizontal: _padding * 2.5),
                      ),
                      child: Column(
                        children: [
                          TabBar(
                            controller: tabController,
                            tabAlignment: responsiveValue<TabAlignment>(
                              context,
                              xs: TabAlignment.fill,
                              md: TabAlignment.start,
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: _theme.colorScheme.outline,
                            indicator: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: _theme.colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                stops: const [0.30, 0.75],
                                colors: [
                                  _theme.colorScheme.primary.withOpacity(0.16),
                                  _theme.colorScheme.primary.withOpacity(0.05),
                                ],
                              ),
                            ),
                            isScrollable: responsiveValue<bool>(
                              context,
                              xs: false,
                              md: true,
                            ),
                            tabs: [
                              // Tab(text: 'Description'),
                              // Tab(text: 'Reviews (25)'),
                              Tab(
                                text: lang.description,
                              ),
                              Tab(text: '${lang.reviews} (25)')
                            ],
                            labelColor: _theme.colorScheme.primary,
                            unselectedLabelColor:
                                _theme.colorScheme.onTertiaryContainer,
                            labelStyle: _theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: _padding * 2.5,
                            ),
                            child: [
                              // Description
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: _padding,
                                ),
                                child: Text(
                                  '''Quisque varius diam vel metus mattis, id aliquam diam rhoncus. Proin vitae magna in dui finibus malesuada et at nulla. Morbi elit ex, viverra vitae ante vel, blandit feugiat ligula. Fusce fermentum iaculis nibh, at sodales leo maximus a. Nullam ultricies sodales nunc, in pellentesque lorem mattis quis. Cras imperdiet est in nunc tristique lacinia. Nullam aliquam mauris eu accumsan tincidunt. Suspendisse velit ex, aliquet vel ornare vel, dignissim a tortor.\n\nMorbi ut sapien vitae odio accumsan gravida. Morbi vitae erat auctor, eleifend nunc a, lobortis neque. Praesent aliquam dignissim viverra. Maecenas lacus odio, feugiat eu nunc sit amet, maximus sagittis dolor. Vivamus nisi sapien, elementum sit amet eros sit amet, ultricies cursus ipsum. Sed consequat luctus ligula. Curabitur laoreet rhoncus blandit. Aenean vel diam ut arcu pharetra dignissim ut sed leo. Vivamus faucibus, ipsum in vestibulum vulputate, lorem orci convallis quam, sit amet consequat nulla felis pharetra lacus. Duis semper erat mauris, sed egestas purus commodo vel.''',
                                  style: _theme.textTheme.bodyLarge?.copyWith(
                                    color:
                                        _theme.colorScheme.onTertiaryContainer,
                                  ),
                                ),
                              ),

                              // Reviews
                              const ReviewList(),
                            ][tabController.index],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Related Products
            Padding(
              padding: EdgeInsets.all(_padding),
              child: Text(
                lang.relatedProducts,
                //'Related products',
                style: _theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 520,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: eCommerceMockproducts.length,
                itemBuilder: (context, index) {
                  final _product = eCommerceMockproducts[index];
                  return AspectRatio(
                    aspectRatio: 250 / 445,
                    child: g_comp.GridProductCard(
                      product: _product,
                      onTap: () {},
                      onAddCartTap: () {},
                      onFavoriteTap: () {},
                    ),
                  );
                },
                separatorBuilder: (c, i) => const SizedBox(width: 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext ctx, MapEntry<String, String?> data) {
    final ThemeData(:textTheme, :colorScheme) = Theme.of(context);
    return Text.rich(
      TextSpan(
        text: "${data.key} :  ",
        children: [TextSpan(text: data.value)],
      ),
      style: textTheme.bodyLarge?.copyWith(
        fontSize: 16.5,
        color: colorScheme.onTertiaryContainer,
      ),
    );
  }
}

class ReviewList extends StatelessWidget {
  const ReviewList({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _padding = responsiveValue<double>(context, xs: 6.4, lg: 9.6);

    return ListView.separated(
      padding: EdgeInsets.all(_padding),
      shrinkWrap: true,
      primary: false,
      itemCount: 30,
      itemBuilder: (context, index) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                SizedBox.square(
                  dimension: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Image.asset(
                      'assets/images/static_images/avatars/placeholder_avatar/placeholder_avatar_02.jpeg',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _theme.colorScheme.outline,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                lang.savannahNguyen,
                                //'Savannah Nguyen',
                                style: _theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '1 May 2024',
                              style: _theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),

                        // Rating
                        const g_comp.RatingNReviews(rating: 5),
                        const SizedBox(height: 8),

                        // Review
                        Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                          style: _theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
      separatorBuilder: (c, i) => const SizedBox(height: 24),
    );
  }
}
