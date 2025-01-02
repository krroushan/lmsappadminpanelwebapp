import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Your Orders',
              style: _theme.textTheme.bodyMedium!
                  .copyWith(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 28,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Product',
                  style: _theme.textTheme.bodyMedium!
                      .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Subtotal',
                  style: _theme.textTheme.bodyMedium!
                      .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xffD4D4D4),
            ),
            const SizedBox(
              height: 16,
            ),
            // Order List
            Expanded(
              child: ListView(
                children: [
                  buildOrderItem("Natures Deli Chicken & \nRice Meatballs 100g",
                      2, 11.00, context),
                  buildOrderItem("Natures Deli Chicken & \nRice Meatballs 100g",
                      1, 11.00, context),
                  buildOrderItem("Natures Deli Chicken & \nRice Meatballs 100g",
                      2, 11.00, context),
                  buildOrderItem("Natures Deli Chicken & \nRice Meatballs 100g",
                      1, 11.00, context),
                  buildOrderItem("Natures Deli Chicken & \nRice Meatballs 100g",
                      1, 11.00, context),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xffD4D4D4),
            ),
            // Subtotal and Total
            buildSummaryFooter(143.00, context),
            const SizedBox(height: 20),
            // Place Order Button
            InkWell(
              onTap: () {},
              child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color(0xff7500FD),
                      borderRadius: BorderRadius.circular(4)),
                  child: const Text('Place Order',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white))),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build order items
  Widget buildOrderItem(
      String product, int quantity, double price, BuildContext context) {
    final _theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            product,
            style: _theme.textTheme.bodyMedium!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xff404040)),
          ),
          const SizedBox(
            width: 7,
          ),
          Text(
            'x$quantity',
            style: _theme.textTheme.bodyMedium!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: const Color(0xff404040)),
          ),
          Text(
            "\$${(price * quantity).toStringAsFixed(2)}",
            style: _theme.textTheme.bodyMedium!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xff171717)),
          ),
        ],
      ),
    );
  }

  // Helper function to build the summary footer
  Widget buildSummaryFooter(double subtotal, BuildContext context) {
    final _theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Subtotal',
              style: _theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff404040)),
            ),
            Text(
              '\$${subtotal.toStringAsFixed(2)}',
              style: _theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff404040)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: _theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff404040)),
            ),
            Text(
              '\$${subtotal.toStringAsFixed(2)}',
              style: _theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff404040)),
            ),
          ],
        ),
      ],
    );
  }
}
