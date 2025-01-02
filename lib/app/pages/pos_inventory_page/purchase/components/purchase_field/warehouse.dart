// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';

// import '../../../../../core/helpers/helpers.dart';

// class Warehouse extends StatefulWidget {
//   const Warehouse({super.key});

//   @override
//   State<Warehouse> createState() => _WarehouseState();
// }

// class _WarehouseState extends State<Warehouse> {
//   String? selectwarehouse;
//   final List<String> warehouse = [
//     'Warehouse 1',
//     'Warehouse 2',
//     'Warehouse 3',
//     'Warehouse 4',
//     'Warehouse 5',
//     'Warehouse 6',
//     'Warehouse 7'
//   ];
//   @override
//   Widget build(BuildContext context) {
//     TextTheme textTheme = Theme.of(context).textTheme;
//     final _dropdownStyle = AcnooDropdownStyle(context);
//     return DropdownButtonFormField2<String>(
//       style: _dropdownStyle.textStyle,
//       hint: Text(
//         'Select a warehouse',
//         style: textTheme.bodyMedium?.copyWith(
//           fontSize: 16,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//       iconStyleData: _dropdownStyle.iconStyle,
//       buttonStyleData: _dropdownStyle.buttonStyle,
//       dropdownStyleData: _dropdownStyle.dropdownStyle,
//       menuItemStyleData: _dropdownStyle.menuItemStyle,
//       isExpanded: true,
//       value: selectwarehouse,
//       items: warehouse.map((warehouse) {
//         return DropdownMenuItem(
//           value: warehouse,
//           child: Text(warehouse),
//         );
//       }).toList(),
//       onChanged: (value) {
//         setState(() {
//           selectwarehouse = value;
//         });
//       },
//     );
//   }
// }
