import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../../../../../generated/l10n.dart' as l;
import '../../../../../core/helpers/field_styles/field_styles.dart';

class SupplierDropdown extends StatefulWidget {
  const SupplierDropdown({super.key});

  @override
  State<SupplierDropdown> createState() => _SupplierDropdownState();
}

class _SupplierDropdownState extends State<SupplierDropdown> {
  String? selectedSupplier;
  final List<String> suppliers = [
    '${l.S.current.supplier} 1',
    '${l.S.current.supplier} 2',
    '${l.S.current.supplier} 3'
  ];

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    //final //theme = Theme.of(context);
    final lang = l.S.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);
    return DropdownButtonFormField2<String>(
      style: _dropdownStyle.textStyle,
      hint: Text(
        lang.selectASupplier,
        //'Select a supplier',
        style: textTheme.bodyMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      decoration: InputDecoration(
          suffixIconConstraints: const BoxConstraints.tightFor(width: 48),
          suffixIcon: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.horizontal(
                          end: Radius.circular(6)))),
              onPressed: () {},
              child: const Center(
                  child: Icon(
                Icons.add,
                size: 24,
              )))),
      iconStyleData: _dropdownStyle.iconStyle,
      buttonStyleData: _dropdownStyle.buttonStyle,
      dropdownStyleData: _dropdownStyle.dropdownStyle,
      menuItemStyleData: _dropdownStyle.menuItemStyle,
      isExpanded: true,
      value: selectedSupplier,
      items: suppliers.map((supplier) {
        return DropdownMenuItem(
          value: supplier,
          child: Text(supplier),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedSupplier = value;
        });
      },
    );
  }
}
