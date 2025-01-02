// 🎯 Dart imports:
import 'dart:ui';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/theme/_app_colors.dart';
import '../../../widgets/dialog_header/_dialog_header.dart';

class AddProjectDialog extends StatefulWidget {
  const AddProjectDialog({super.key});

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  List<String> get _employees => [
        //'Alice',
        l.S.current.alice,
        //'Bob',
        l.S.current.bob,
      ];
  final List<String> _selectedEmployees = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      // Listen to controller changes and update the selected list if needed
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // ignore: unused_field
  DateTime? _startDate;
  // ignore: unused_field
  DateTime? _endDate;

  Future<void> _selectDate(
      BuildContext context,
      TextEditingController controller,
      ValueChanged<DateTime?> onDateSelected) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null && selectedDate != DateTime.now()) {
      onDateSelected(selectedDate);
      controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;
    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5,
        sigmaY: 5,
      ),
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///---------------- header section
              //const DialogHeader(headerTitle: 'Add New Project'),
              DialogHeader(headerTitle: lang.addNewProject),

              ///---------------- body section
              Padding(
                padding: EdgeInsets.all(_sizeInfo.innerSpacing),
                child: Container(
                  constraints: const BoxConstraints(minWidth: 610),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('Project Name', style: textTheme.bodyMedium),
                      Text(lang.projectName, style: textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      TextFormField(
                        //decoration: InputDecoration(hintText: 'Enter Project Name', hintStyle: textTheme.bodySmall),
                        decoration: InputDecoration(
                            hintText: lang.enterProjectName,
                            hintStyle: textTheme.bodySmall),
                        // validator: (value) => value?.isEmpty ?? true ? 'Please enter project name' : null,
                        validator: (value) => value?.isEmpty ?? true
                            ? lang.pleaseEnterProjectName
                            : null,
                      ),
                      const SizedBox(height: 20),
                      //Text('Title', style: textTheme.bodyMedium),
                      Text(lang.title, style: textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      TextFormField(
                        // decoration: InputDecoration(hintText: 'Enter Project Title', hintStyle: textTheme.bodySmall),
                        decoration: InputDecoration(
                            hintText: lang.enterProjectTitle,
                            hintStyle: textTheme.bodySmall),
                        // validator: (value) => value?.isEmpty ?? true ? 'Please enter title' : null,
                        validator: (value) => value?.isEmpty ?? true
                            ? lang.pleaseEnterTitle
                            : null,
                      ),
                      const SizedBox(height: 20),
                      //Text('Assigner To', style: textTheme.bodyMedium),
                      Text(lang.assignerTo, style: textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      TextFormField(
                        readOnly: true,
                        controller: _controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children: _selectedEmployees.map((employee) {
                                  return Chip(
                                    avatar: CircleAvatar(
                                      radius: 15,
                                      backgroundImage: const NetworkImage(
                                          'assets/images/static_images/avatars/placeholder_avatar/placeholder_avatar_01.png'),
                                      child: Text(employee[0]),
                                    ),
                                    label: Text(employee),
                                    onDeleted: () {
                                      setState(() {
                                        _selectedEmployees.remove(employee);
                                        // _controller.text = _selectedEmployees.join(', ');
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    side: BorderSide.none,
                                    backgroundColor:
                                        theme.colorScheme.tertiaryContainer,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          suffixIcon: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: theme.colorScheme.primaryContainer,
                              hint: Text(
                                lang.selectEmployee,
                                //'Select Employee',
                                style: textTheme.bodySmall,
                              ),
                              items: _employees.map((employee) {
                                return DropdownMenuItem<String>(
                                  value: employee,
                                  child: Text(employee),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                if (newValue != null &&
                                    !_selectedEmployees.contains(newValue)) {
                                  setState(() {
                                    _selectedEmployees.add(newValue);
                                    // _controller.text = _selectedEmployees.join(', ');
                                  });
                                }
                              },
                              isExpanded: false,
                              value: null,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Text('Start Date', style: textTheme.bodyMedium),
                                Text(lang.startDate,
                                    style: textTheme.bodyMedium),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _startDateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    //hintText: 'Start Date',
                                    hintText: lang.startDate,
                                    hintStyle: textTheme.bodySmall,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.calendar_month_outlined,
                                        color: theme.colorScheme.onTertiary,
                                      ),
                                      onPressed: () => _selectDate(
                                        context,
                                        _startDateController,
                                        (date) =>
                                            setState(() => _startDate = date),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: const _SizeInfo().innerSpacing),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Text('End Date', style: textTheme.bodyMedium),
                                Text(lang.endDate, style: textTheme.bodyMedium),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _endDateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    //hintText: 'End Date',
                                    hintText: lang.endDate,
                                    hintStyle: textTheme.bodySmall,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.calendar_month_outlined,
                                        color: theme.colorScheme.onTertiary,
                                      ),
                                      onPressed: () => _selectDate(
                                        context,
                                        _endDateController,
                                        (date) =>
                                            setState(() => _endDate = date),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const CheckboxGroup(),
                      const SizedBox(height: 20),
                      //Text('Description', style: textTheme.bodySmall),
                      Text(lang.description, style: textTheme.bodySmall),
                      const SizedBox(height: 8),
                      TextFormField(
                        //decoration: InputDecoration(hintText: 'Write Something', hintStyle: textTheme.bodySmall),
                        decoration: InputDecoration(
                            hintText: lang.writeSomething,
                            hintStyle: textTheme.bodySmall),
                        maxLines: 3,
                      ),

                      ///---------------- Submit Button section
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: _sizeInfo.innerSpacing),
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                textStyle: textTheme.bodySmall
                                    ?.copyWith(color: AcnooAppColors.kError),
                                side: const BorderSide(
                                    color: AcnooAppColors.kError)),
                            onPressed: () => Navigator.pop(context),
                            label: Text(
                              lang.cancel,
                              //'Cancel',
                              style: textTheme.bodySmall
                                  ?.copyWith(color: AcnooAppColors.kError),
                            ),
                          ),
                          SizedBox(width: _sizeInfo.innerSpacing),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: _sizeInfo.innerSpacing),
                            ),
                            onPressed: () => Navigator.pop(context),
                            //label: const Text('Save'),
                            label: Text(lang.save),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}

class CheckboxGroup extends StatefulWidget {
  const CheckboxGroup({super.key});

  @override
  _CheckboxGroupState createState() => _CheckboxGroupState();
}

class _CheckboxGroupState extends State<CheckboxGroup> {
  String _selectedValue = 'low'; // Default selected value

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildCheckbox('High', 'high'),
          const SizedBox(width: 10),
          _buildCheckbox('Medium', 'medium'),
          const SizedBox(width: 10),
          _buildCheckbox('Low', 'low'),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: _selectedValue == value,
          onChanged: (bool? newValue) {
            if (newValue == true) {
              setState(() {
                _selectedValue = value;
              });
            } else if (_selectedValue == value) {
              setState(() {
                _selectedValue =
                    ''; // Deselect if it's the current selected one
              });
            }
          },
        ),
        const SizedBox(width: 4.0),
        Text(label),
      ],
    );
  }
}
