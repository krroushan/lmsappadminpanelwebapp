import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../components/product_cards/product_cards.dart' as g_comp;
import '../../../../providers/_ecommerce_product_list_provider.dart';

class ProductsListLayout extends StatelessWidget {
  const ProductsListLayout({
    super.key,
    this.padding,
  });
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Consumer<ECommerceMockProductsNotifier>(
      builder: (context, prov, child) {
        return ListView.separated(
          padding: padding,
          shrinkWrap: true,
          primary: false,
          itemCount: prov.fakeApiProducts.length,
          itemBuilder: (context, index) {
            final _product = prov.fakeApiProducts[index];

            return g_comp.LisTileProductCard(
              product: _product,
              isFavorite: prov.favoriteProducts.contains(_product.id),
              onFavoriteTap: () => prov.addToFav(_product.id),
              onAddCartTap: () {},
              onTap: () => context.go(
                '/ecommerce/product-details',
                extra: _product,
              ),
            );
          },
          separatorBuilder: (c, i) => const SizedBox(height: 20),
        );
      },
    );
  }
}
