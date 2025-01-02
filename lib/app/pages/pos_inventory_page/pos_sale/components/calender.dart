import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/static/static.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  final TextEditingController _dateController = TextEditingController();

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );

  //   if (pickedDate != null) {
  //     setState(() {
  //       _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return TextFormField(
      controller: _dateController,
      keyboardType: TextInputType.visiblePassword,
      readOnly: true,
      selectionControls: EmptyTextSelectionControls(),
      decoration: InputDecoration(
        labelText: l.S.of(context).date,
        hintText: 'mm/dd/yyyy',
        suffixIcon: const Icon(IconlyLight.calendar, size: 20),
      ),
      onTap: () async {
        final _result = await showDatePicker(
          context: context,
          firstDate: AppDateConfig.appFirstDate,
          lastDate: AppDateConfig.appLastDate,
          initialDate: DateTime.now(),
          builder: (context, child) => Theme(
            data: _theme.copyWith(
              datePickerTheme: DatePickerThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            child: child!,
          ),
        );

        if (_result != null) {
          // setState(() => )
          _dateController.text =
              DateFormat(AppDateConfig.appNumberOnlyDateFormat).format(_result);
        }
      },
    );
  }
}
