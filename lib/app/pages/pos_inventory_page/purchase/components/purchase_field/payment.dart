import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../../../../../generated/l10n.dart' as l;
import '../../../../../core/helpers/helpers.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}
class _PaymentState extends State<Payment> {
  String? paymenttype;
  final List<String> type = [
    'PayPal',
    'SmartBill',
    'CardLink',
    'WalletWave',
    'CryptoFlow',
    'EasyTransfer',
    'SafeSwipe'
  ];
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final _dropdownStyle = AcnooDropdownStyle(context);
    final lang = l.S.of(context);
    return DropdownButtonFormField2<String>(
      style: _dropdownStyle.textStyle,
      hint: Text(
        lang.searchProductByName,
       // 'Search product by name',
        style: textTheme.bodyMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      iconStyleData: _dropdownStyle.iconStyle,
      buttonStyleData: _dropdownStyle.buttonStyle,
      dropdownStyleData: _dropdownStyle.dropdownStyle,
      menuItemStyleData: _dropdownStyle.menuItemStyle,
      isExpanded: true,
      value: paymenttype,
      items: type.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          paymenttype = value;
        });
      },
    );
  }
}
