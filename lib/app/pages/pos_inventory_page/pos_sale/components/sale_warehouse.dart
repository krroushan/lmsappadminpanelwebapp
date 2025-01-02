import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/helpers/helpers.dart';

class SaleWarehouse extends StatefulWidget {
  const SaleWarehouse({super.key});

  @override
  State<SaleWarehouse> createState() => _SaleWarehouseState();
}

class _SaleWarehouseState extends State<SaleWarehouse> {
  String? selectWarehouse;
   List<String> get warehouse => [
    '${l.S.current.warehouse} 1',
    '${l.S.current.warehouse} 2',
    '${l.S.current.warehouse} 3',
    '${l.S.current.warehouse} 4',
    '${l.S.current.warehouse} 5',
    '${l.S.current.warehouse} 6',
  ];
  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    final _dropdownStyle = AcnooDropdownStyle(context);
    return DropdownButtonFormField2<String>(
      style: _dropdownStyle.textStyle,
      hint: Text(
        lang.selectAWarehouse,
        //'Select a warehouse',
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
      value: selectWarehouse,
      items: warehouse.map((warehouse) {
        return DropdownMenuItem(
          value: warehouse,
          child: Text(warehouse),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectWarehouse = value;
        });
      },
    );
  }
}
