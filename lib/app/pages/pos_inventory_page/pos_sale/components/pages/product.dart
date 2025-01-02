import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class ProductGridView extends StatefulWidget {
  const ProductGridView({super.key});

  @override
  State<ProductGridView> createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisExtent: 240,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final _product = products[index];
        return ProductCard(product: _product);
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _theme.colorScheme.outline,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Product Image
          SizedBox.fromSize(
            size: const Size.fromHeight(150),
            child: Image(
              image: AssetImage(product.image),
              fit: BoxFit.cover,
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Product Name
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // Category Name
                Text(
                  product.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),

                // Price
                Text(
                  intl.NumberFormat.simpleCurrency().format(product.price),
                  style: _theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProductModel {
  final String image;
  final String name;
  final String category;
  final double price;

  ProductModel(this.image, this.name, this.category, this.price);
}

List<ProductModel> products = [
  ProductModel(
    'assets/images/static_images/product_images/product_image_27.png',
    'Wheat Thins Original',
    'Food',
    20.00,
  ),
  ProductModel(
    'assets/images/static_images/product_images/product_image_28.png',
    'Caramel Hard Candies',
    'Food',
    20.00,
  ),
  ProductModel(
    'assets/images/static_images/product_images/product_image_26.png',
    'Corn Tortilla Chips',
    'Food',
    20.00,
  ),
  ProductModel(
    'assets/images/static_images/product_images/product_image_29.png',
    'Pastel Almond Blend',
    'Food',
    20.00,
  ),
  ProductModel(
    'assets/images/static_images/product_images/product_image_30.png',
    'Fresh Brown Coconut',
    'Fruits',
    20.00,
  ),
  ProductModel(
    'assets/images/static_images/product_images/product_image_23.jpeg',
    'Cavendish Bananas',
    'Fruits',
    20.00,
  ),
  ProductModel(
    'assets/images/static_images/product_images/product_image_19.png',
    'Organic Strawberry',
    'Fruits',
    20.00,
  ),
  ProductModel(
    'assets/images/static_images/product_images/product_image_31.png',
    'Green Grapes',
    'Fruits',
    20.00,
  ),
  ProductModel(
    'assets/images/static_images/product_images/product_image_32.png',
    'Cup Print T-Shirt',
    'Fashion ',
    20.00,
  ),
  ProductModel(
    'assets/images/static_images/product_images/product_image_34.png',
    'Quilted Bomber Jacket ',
    'Fashion ',
    20.00,
  ),
  ProductModel(
    'assets/images/static_images/product_images/product_image_35.png',
    'Hot Stuff Hoodie',
    'Fashion ',
    20.00,
  ),
  ProductModel(
    'assets/images/static_images/product_images/product_image_33.png',
    'Shoulder Bag',
    'Fashion ',
    20.00,
  ),
];
