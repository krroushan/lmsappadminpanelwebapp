// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class OrderTrackerTile extends StatelessWidget {
  const OrderTrackerTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Text('#OID3548712'),
          ],
        ),
        Container(),
      ],
    );
  }
}
