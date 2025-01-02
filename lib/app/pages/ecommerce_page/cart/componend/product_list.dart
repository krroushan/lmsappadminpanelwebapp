// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:feather_icons/feather_icons.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../../../generated/l10n.dart' as l;
// 🌎 Project imports:
import '../../../../core/theme/_app_colors.dart';
import '../../../../widgets/widgets.dart';

class ProductList extends StatelessWidget {
  ProductList({super.key});

  final List<Product> _product = [
    Product(
      id: 1,
      image: 'assets/images/static_images/product_images/product_image_24.png',
      name: 'Natures Deli Chicken & Rice \nMeatballs 100g | Just for Pets',
      price: 5.50,
      quantity: 2,
      subtotal: 11.00,
    ),
    Product(
      id: 2,
      image: 'assets/images/static_images/product_images/product_image_08.png',
      name: 'Premium Cavendish Banana',
      price: 20.00,
      quantity: 1,
      subtotal: 20.00,
    ),
    Product(
      id: 3,
      image: 'assets/images/static_images/product_images/product_image_21.png',
      name: 'High-End Headphones',
      price: 49.50,
      quantity: 2,
      subtotal: 100.00,
    ),
    Product(
      id: 4,
      image: 'assets/images/static_images/product_images/product_image_16.png',
      name: 'Smartphone',
      price: 5.50,
      quantity: 2,
      subtotal: 11.00,
    ),
    Product(
      id: 5,
      image: 'assets/images/static_images/product_images/product_image_17.png',
      name: 'Limes',
      price: 5.50,
      quantity: 2,
      subtotal: 11.00,
    ),
  ];

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final lang = l.S.of(context);
    return ResponsiveGridRow(
      children: [
        ResponsiveGridCol(
            child: ShadowContainer(
          clipBehavior: Clip.none,
          contentPadding: EdgeInsets.zero,
          showHeader: false,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                  ),
                  child: Theme(
                    data: theme.copyWith(
                        dividerColor: theme.colorScheme.outline,
                        checkboxTheme: const CheckboxThemeData(
                          side: BorderSide(
                            color: AcnooAppColors.kNeutral500,
                            width: 1.0,
                          ),
                        ),
                        dividerTheme: DividerThemeData(
                          color: theme.colorScheme.outline,
                        )),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadiusDirectional.circular(8.0),
                        border: Border.all(
                          color: theme.colorScheme.outline,
                          width: 1.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadiusDirectional.circular(8.0),
                        child: DataTable(
                          dataRowMaxHeight: 90,
                          border: TableBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            horizontalInside: BorderSide(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          dividerThickness: 1.0,
                          horizontalMargin: 30.0,
                          headingRowColor: WidgetStateProperty.all(
                              theme.colorScheme.surface),
                          columns: [
                            DataColumn(
                                label: Text(
                              '${lang.SL}.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )),
                            DataColumn(
                                label: Text(
                              textAlign: TextAlign.center,
                              lang.name,
                              //'Name',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )),
                            DataColumn(
                                label: Text(
                              lang.price,
                              // 'Price',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )),
                            DataColumn(
                                label: Text(
                              lang.quantity,
                              //'Quantity',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )),
                            DataColumn(
                                label: Text(
                              lang.subtotal,
                              //'Subtotal',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )),
                            DataColumn(
                                label: Text(
                              lang.action,
                              //'Action',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )),
                          ],
                          rows: _product.map(
                            (user) {
                              return DataRow(
                                cells: [
                                  DataCell(Row(
                                    children: [
                                      Text(
                                        user.id.toString(),
                                        style: textTheme.titleSmall?.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Image.asset(user.image,
                                          width: 70, height: 70),
                                    ],
                                  )),
                                  DataCell(Text(
                                    user.name,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  )),
                                  DataCell(Text(
                                    '\$${user.price.toStringAsFixed(2)}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  )),
                                  const DataCell(SizedBox(
                                      width: 140, child: CounterField())),
                                  DataCell(Text(
                                    '\$${user.subtotal.toStringAsFixed(2)}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  )),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            FeatherIcons.edit3,
                                            color: AcnooAppColors.kSuccess,
                                          )),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            FeatherIcons.trash2,
                                            color: AcnooAppColors.kError,
                                          ))
                                    ],
                                  )),
                                ],
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ))
      ],
    );
  }
}

class Product {
  final int id;
  final String image;
  final String name;
  final double price;
  final int quantity;
  final double subtotal;

  Product({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });
}
