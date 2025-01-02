import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../widgets/widgets.dart';
import 'componend/order.dart';
import 'componend/product_list.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery.sizeOf(context);

    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      lg: 24,
    );
    return Scaffold(
        body: SizedBox.fromSize(
      child: SingleChildScrollView(
        child: ShadowContainer(
          margin: EdgeInsetsDirectional.all(_padding),
          contentPadding: EdgeInsetsDirectional.all(_padding / 2.75),
          showHeader: false,
          child: ResponsiveGridRow(children: [
            ResponsiveGridCol(
              lg: 8,
              child: Padding(
                padding: EdgeInsetsDirectional.all(_padding / 2.25),
                child: ProductList(),
              ),
            ),
            ResponsiveGridCol(
              lg: 4,
              child: Padding(
                padding: EdgeInsetsDirectional.all(_padding / 2.25),
                child: const Order(),
              ),
            )
          ]),
        ),
      ),
    ));
  }
}
