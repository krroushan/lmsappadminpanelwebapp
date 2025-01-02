// import 'package:flutter/material.dart';

// class CalendarTextField extends StatefulWidget {
//   const CalendarTextField({super.key});

//   @override
//   State<CalendarTextField> createState() => _CalendarTextFieldState();
// }

// class _CalendarTextFieldState extends State<CalendarTextField> {
//   final TextEditingController _dateController = TextEditingController();

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     if (pickedDate != null) {
//       setState(() {
//         _dateController.text =
//             "${pickedDate.toLocal()}".split(' ')[0]; // Format date
//       });
//     }
//   }s

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final textTheme = theme.textTheme;
//     return TextField(
//       controller: _dateController,
//       readOnly: true, // Prevent manual editing
//       decoration: InputDecoration(
//         labelText: 'Date',
//         labelStyle: textTheme.bodySmall?.copyWith(
//           fontSize: 14,
//           fontWeight: FontWeight.w400,
//         ),
//         suffixIcon: IconButton(
//           icon: const Icon(Icons.calendar_month),
//           onPressed: () => _selectDate(context),
//         ),
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }
// }
