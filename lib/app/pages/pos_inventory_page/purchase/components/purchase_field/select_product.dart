// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';

// import '../../../../../core/helpers/helpers.dart';

// class SelectProduct extends StatefulWidget {
//   const SelectProduct({super.key});

//   @override
//   State<SelectProduct> createState() => _SelectProductState();
// }

// class _SelectProductState extends State<SelectProduct> {
//   String? selectedProduct;
//   final List<String> product = ['Banana', 'Mango', 'Watch', 'Mobile', 'Bag'];
//   @override
//   Widget build(BuildContext context) {
//     TextTheme textTheme = Theme.of(context).textTheme;
//     final _dropdownStyle = AcnooDropdownStyle(context);
//     return DropdownButtonFormField2<String>(
//       style: _dropdownStyle.textStyle,
//       hint: Text(
//         'Search product by name',
//         style: textTheme.bodyMedium?.copyWith(
//           fontSize: 16,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//       decoration: InputDecoration(
//           suffixIconConstraints: const BoxConstraints.tightFor(width: 48),
//           suffixIcon: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.zero,
//                   shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadiusDirectional.horizontal(
//                           end: Radius.circular(6)))),
//               onPressed: () {},
//               child: const Center(
//                   child: Icon(
//                 Icons.add,
//                 size: 24,
//               )))),
//       iconStyleData: _dropdownStyle.iconStyle,
//       buttonStyleData: _dropdownStyle.buttonStyle,
//       dropdownStyleData: _dropdownStyle.dropdownStyle,
//       menuItemStyleData: _dropdownStyle.menuItemStyle,
//       isExpanded: true,
//       value: selectedProduct,
//       items: product.map((product) {
//         return DropdownMenuItem(
//           value: product,
//           child: Text(product),
//         );
//       }).toList(),
//       onChanged: (value) {
//         setState(() {
//           selectedProduct = value;
//         });
//       },
//     );
//   }
// }
