// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/helpers/field_styles/field_styles.dart';
import '../../core/static/static.dart';
import '../../widgets/widgets.dart';

class EditStudentView extends StatefulWidget {
  const EditStudentView({super.key});

  @override
    State<EditStudentView> createState() => _EditStudentViewState();
}

class _EditStudentViewState extends State<EditStudentView> {
  // Field State Props
  bool _obscureText = true;
  late final _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);
    final _inputFieldStyle = AcnooInputFieldStyles(context);
    const _lg = 4;
    const _md = 6;

    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 992,
          value: _SizeInfo(
            fonstSize: 12,
            padding: EdgeInsetsDirectional.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    return Scaffold(
      body: ListView(
        padding: _sizeInfo.padding,
        children: [
          // Input Example
          ShadowContainer(
            headerText: 'Edit Student',
            child: ResponsiveGridRow(
              children: [
                // Name
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(
                        _sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: 'Name',
                      inputField: TextFormField(
                        decoration: const InputDecoration(hintText: 'Name'),
                      ),
                    ),
                  ),
                ),

                // Email
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(
                        _sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: 'Email',
                      inputField: TextFormField(
                        decoration: const InputDecoration(hintText: 'Email'),
                      ),
                    ),
                  ),
                ),

                // Phone
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(
                        _sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: 'Phone',
                      inputField: TextFormField(
                        decoration: const InputDecoration(hintText: 'Phone'),
                      ),
                    ),
                  ),
                ),

                // Roll Number
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(
                        _sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: 'Roll Number',
                      inputField: TextFormField(
                        decoration: const InputDecoration(hintText: 'Roll Number'),
                      ),
                    ),
                  ),
                ),

                // Gender
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: 'Gender',
                      inputField: DropdownButtonFormField2(
                        menuItemStyleData: _dropdownStyle.menuItemStyle,
                        buttonStyleData: _dropdownStyle.buttonStyle,
                        iconStyleData: _dropdownStyle.iconStyle,
                        dropdownStyleData: _dropdownStyle.dropdownStyle,
                        // hint: const Text('Select'),
                        hint: Text(lang.select),
                        items: List.generate(
                          5,
                          (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text('${lang.dropdown} ${index + 1}'),
                          ),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ),

                //  Date of Birth
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: 'Date of Birth',
                      inputField: TextFormField(
                        controller: _dateController,
                        keyboardType: TextInputType.visiblePassword,
                        readOnly: true,
                        selectionControls: EmptyTextSelectionControls(),
                        decoration: InputDecoration(
                          hintText: 'mm/dd/yyyy',
                          suffixIcon:
                              const Icon(IconlyLight.calendar, size: 20),
                          suffixIconConstraints:
                              _inputFieldStyle.iconConstraints,
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
                            _dateController.text = DateFormat(
                                    AppDateConfig.appNumberOnlyDateFormat)
                                .format(_result);
                          }
                        },
                      ),
                    ),
                  ),
                ),

                // Address
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                      labelText: 'Address',
                      inputField: TextFormField(
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: 'Address',
                        ),
                      ),
                    ),
                  ),
                ),
              
                       //  Password Field
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return TextFieldLabelWrapper(
                          labelText: 'Password',
                          inputField: TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscureText,
                            obscuringCharacter: '*',
                            decoration: InputDecoration(
                              // hintText: 'Input Password',
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                  () => _obscureText = !_obscureText,
                                ),
                                padding: EdgeInsetsDirectional.zero,
                                visualDensity: const VisualDensity(
                                  horizontal: -4,
                                  vertical: -4,
                                ),
                                icon: Icon(
                                  _obscureText
                                      ? FeatherIcons.eye
                                      : FeatherIcons.eyeOff,
                                  size: 20,
                                ),
                              ),
                              suffixIconConstraints:
                                  _inputFieldStyle.iconConstraints,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Upload Photo
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                        padding: EdgeInsetsDirectional.all(
                          _sizeInfo.innerSpacing / 2,
                        ),
                        child: TextFieldLabelWrapper(
                          labelText: 'Upload Photo',
                          inputField: AcnooFileInputField(
                            onTap: () {},
                            decoration: const InputDecoration(
                              hintText: 'Upload Photo',
                              contentPadding: EdgeInsetsDirectional.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

              ],
            ),

          ),
Padding(
            padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
            child: ElevatedButton(
              onPressed: () {
                // Add your update logic here
              },
              child: Text('Update Student'),
            ),
          ),
      ],
      ),
    );
  }
}

class _SizeInfo {
  final double? fonstSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.fonstSize,
    this.padding = const EdgeInsetsDirectional.all(24),
    this.innerSpacing = 24,
  });
}
