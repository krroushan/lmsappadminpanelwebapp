import 'package:acnoo_flutter_admin_panel/app/core/theme/theme.dart';
import 'package:flutter/material.dart';

class DiscountTextField extends StatefulWidget {
  const DiscountTextField({super.key});

  @override
  State<DiscountTextField> createState() => _DiscountTextFieldState();
}

class _DiscountTextFieldState extends State<DiscountTextField> {
  int counter = 0;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: counter.toString());
  }

  void incrementCounter() {
    setState(() {
      counter++;
      _controller.text = counter.toString();
    });
  }

  void decrementCounter() {
    if (counter > 0) {
      setState(() {
        counter--;
        _controller.text = counter.toString();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      width: 95,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: AcnooAppColors.kNeutral200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: _controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 9.5),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          suffixIcon: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: incrementCounter,
                child: const Icon(
                  Icons.arrow_drop_up,
                  size: 18,
                ),
              ),
              InkWell(
                onTap: decrementCounter,
                child: const Icon(Icons.arrow_drop_down, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
