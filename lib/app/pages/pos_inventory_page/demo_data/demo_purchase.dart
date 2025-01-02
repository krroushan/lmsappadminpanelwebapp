class Purchase {
  final String image;
  final String items;
  final String code;
  final String unit;
  final String salePrice;
  final String subTotal;

  Purchase({
    required this.image,
    required this.items,
    required this.code,
    required this.unit,
    required this.salePrice,
    required this.subTotal,
  });

  @override
  String toString() =>
      'DataModel(image: $image, items: $items, code: $code, unit: $unit, salePrice: $salePrice, subTotal: $subTotal,)';
}

class AllSale {
  static List<Purchase> allSale = [
    Purchase(
      image: 'assets/images/static_images/product_images/product_image_02.png',
      items: 'Wheat Thins Original ',
      code: '58641',
      unit: 'Pcs',
      salePrice: '\$500',
      subTotal: '\$500',
      //G:\acnoo_flutter_admin_panel\assets\images\static_images\product_images\product_image_09.png
    ),
    Purchase(
      image: 'assets/images/static_images/product_images/product_image_25.png',
      items: 'Bananas ',
      code: '58641',
      unit: 'Pcs',
      salePrice: '\$500',
      subTotal: '\$500',
      //G:\acnoo_flutter_admin_panel\assets\images\static_images\product_images\product_image_25.png
    )
  ];
}
