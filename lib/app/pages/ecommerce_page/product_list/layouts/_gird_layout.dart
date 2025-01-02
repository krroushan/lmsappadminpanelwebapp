import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../providers/_ecommerce_product_list_provider.dart';
import '../../components/components.dart';

class ProductsGridLayout extends StatelessWidget {
  const ProductsGridLayout({
    super.key,
    this.showBorder = false,
    this.padding,
  });
  final bool showBorder;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    final _mqSize = MediaQuery.sizeOf(context);
    final _theme = Theme.of(context);

    return Consumer<ECommerceMockProductsNotifier>(
      builder: (context, prov, child) {
        return GridView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: prov.fakeApiProducts.length,
          padding: padding,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent:
                _mqSize.width < 480 ? 500 : (showBorder ? 310 : 340),
            mainAxisExtent: 505,
            childAspectRatio: 0.6,
            mainAxisSpacing: showBorder ? 0 : 16,
            crossAxisSpacing: showBorder ? 0 : 16,
          ),
          itemBuilder: (context, index) {
            final _product = prov.fakeApiProducts[index];
            return Container(
              decoration: BoxDecoration(
                border: !showBorder
                    ? null
                    : Border.all(
                        color: _theme.colorScheme.outline,
                        width: 1.5,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
              ),
              child: GridProductCard(
                product: _product,
                showHoverEffect: !showBorder,
                isFavorite: prov.favoriteProducts.contains(_product.id),
                onFavoriteTap: () => prov.addToFav(_product.id),
                onAddCartTap: () {},
                onTap: () => context.go(
                  '/ecommerce/product-details',
                  extra: _product,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
