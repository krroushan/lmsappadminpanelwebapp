import 'package:flutter/material.dart';

import '../../../../../core/theme/theme.dart';
import '../../../demo_data/demo_purchase.dart';

class QuantityButton extends StatefulWidget {
  final Purchase product;

  const QuantityButton({
    super.key,
    required this.product,
  });

  @override
  State<QuantityButton> createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<QuantityButton> {
  int _quantity = 0;

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);
    final _theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: _theme.colorScheme.primaryContainer,
            border: Border.all(color: AcnooAppColors.kNeutral300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.remove, size: 18),
              //color: AcnooAppColors.kBlackColor,
              onPressed: _decreaseQuantity,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            _quantity.toString(),
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
          ),
        ),
        Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: _theme.colorScheme.primaryContainer,
            border: Border.all(color: AcnooAppColors.kNeutral300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: IconButton(
              icon: const Icon(
                Icons.add,
                size: 18,
              ),
              onPressed: _increaseQuantity,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
