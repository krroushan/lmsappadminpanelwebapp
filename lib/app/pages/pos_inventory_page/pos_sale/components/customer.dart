import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/helpers/helpers.dart';
import '../../../../core/theme/theme.dart';

class Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  String? selectedSupplier;
   List<String> get customer => [
    '${l.S.current.customer} 1',
    '${l.S.current.customer} 2',
    '${l.S.current.customer} 3',
    '${l.S.current.customer} 4',
    '${l.S.current.customer} 5'
  ];

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    //final //theme = Theme.of(context);
    final lang = l.S.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField2<String>(
            style: _dropdownStyle.textStyle,
            hint: Text(
              lang.selectCustomer,
              //'Select Customer',
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            decoration: InputDecoration(
                suffixIconConstraints: const BoxConstraints.tightFor(width: 48),
                suffixIcon: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AcnooAppColors.kPrimary700,
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
            items: customer.map((supplier) {
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
          ),
        ),
      ],
    );
  }
}
