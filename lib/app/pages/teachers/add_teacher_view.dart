// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../core/helpers/field_styles/field_styles.dart';
import '../../core/static/static.dart';
import '../../widgets/widgets.dart';
import '../../core/api_service/teacher_service.dart';
import '../../models/teacher/teacher_create.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';

class AddTeacherView extends StatefulWidget {
  const AddTeacherView({super.key});

  @override
    State<AddTeacherView> createState() => _AddTeacherViewState();
}

class _AddTeacherViewState extends State<AddTeacherView> {
  final _browserDefaultFormKey = GlobalKey<FormState>();
  // Field State Props
  bool _obscureText = true;
  //late final _dateController = TextEditingController();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  //final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  //final _addressController = TextEditingController();

  final _teacherService = TeacherService();

  String token = '';

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
  }

     // new method to create a teacher and send to API
  Future<void> _createTeacher(String username, String fullName, String email, String password) async {
    // Generate a fake teacher with valid data
    final teacherData = TeacherCreate.fromJson({
      "fullName": fullName, 
      "email": email, 
      "username": username, 
      "password": password, 
    });

    print("Teacher Data: ${teacherData.toJson()}");

    try {
      // Send the fake teacher to the API
        await _teacherService.createTeacher(teacherData, token);
      //after success
      context.go('/dashboard/teachers/all-teachers');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Teacher created successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error creating teacher: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create teacher: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    //_dateController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    //_phoneController.dispose();
    _passwordController.dispose();
    //_addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Form(
        key: _browserDefaultFormKey,
        child: ListView(
        padding: _sizeInfo.padding,
        children: [
          // Input Example
          ShadowContainer(
            headerText: 'Add Teacher',
            child: ResponsiveGridRow(
              children: [
                // Username
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(
                        _sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: 'Username',
                      inputField: TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(hintText: 'Username'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),

                // Full Name
                ResponsiveGridCol(
                  lg: _lg,
                  md: _md,
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(
                        _sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      labelText: 'Full Name',
                      inputField: TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(hintText: 'Full Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Full Name is required';
                          }
                          return null;
                        },
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
                        controller: _emailController,
                        decoration: const InputDecoration(hintText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),

                // Phone
                // ResponsiveGridCol(
                //   lg: _lg,
                //   md: _md,
                //   child: Padding(
                //     padding: EdgeInsetsDirectional.all(
                //         _sizeInfo.innerSpacing / 2),
                //     child: TextFieldLabelWrapper(
                //       labelText: 'Phone',
                //       inputField: TextFormField(
                //         controller: _phoneController,
                //         decoration: const InputDecoration(hintText: 'Phone'),
                //         validator: (value) {
                //           if (value == null || value.isEmpty) {
                //             return 'Phone is required';
                //           }
                //           return null;
                //         },
                //       ),
                //     ),
                //   ),
                // ),

                // Gender
                // ResponsiveGridCol(
                //   lg: _lg,
                //   md: _md,
                //   child: Padding(
                //     padding:
                //         EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                //     child: TextFieldLabelWrapper(
                //       labelText: 'Gender',
                //       inputField: DropdownButtonFormField2(
                //         menuItemStyleData: _dropdownStyle.menuItemStyle,
                //         buttonStyleData: _dropdownStyle.buttonStyle,
                //         iconStyleData: _dropdownStyle.iconStyle,
                //         dropdownStyleData: _dropdownStyle.dropdownStyle,
                //         hint: const Text('Gender'),
                //         items: const [
                //           DropdownMenuItem(
                //             value: 1,
                //             child: Text('Male'),
                //           ),
                //           DropdownMenuItem(
                //             value: 2,
                //             child: Text('Female'),
                //           ),
                //         ],
                //         onChanged: (value) {},
                //       ),
                //     ),
                //   ),
                // ),

                //  Date of Birth
                // ResponsiveGridCol(
                //   lg: _lg,
                //   md: _md,
                //   child: Padding(
                //     padding:
                //         EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                //     child: TextFieldLabelWrapper(
                //       labelText: 'Date of Birth',
                //       inputField: TextFormField(
                //         controller: _dateController,
                //         keyboardType: TextInputType.visiblePassword,
                //         readOnly: true,
                //         selectionControls: EmptyTextSelectionControls(),
                //         decoration: InputDecoration(
                //           hintText: 'mm/dd/yyyy',
                //           suffixIcon:
                //               const Icon(IconlyLight.calendar, size: 20),
                //           suffixIconConstraints:
                //               _inputFieldStyle.iconConstraints,
                //         ),
                //         onTap: () async {
                //           final _result = await showDatePicker(
                //             context: context,
                //             firstDate: AppDateConfig.appFirstDate,
                //             lastDate: AppDateConfig.appLastDate,
                //             initialDate: DateTime.now(),
                //             builder: (context, child) => Theme(
                //               data: _theme.copyWith(
                //                 datePickerTheme: DatePickerThemeData(
                //                   shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(4),
                //                   ),
                //                 ),
                //               ),
                //               child: child!,
                //             ),
                //           );

                //           if (_result != null) {
                //             // setState(() => )
                //             _dateController.text = DateFormat(
                //                     AppDateConfig.appNumberOnlyDateFormat)
                //                 .format(_result);
                //           }
                //         },
                //       ),
                //     ),
                //   ),
                // ),

                // Address
                // ResponsiveGridCol(
                //   lg: _lg,
                //   md: _md,
                //   child: Padding(
                //     padding:
                //         EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                //       child: TextFieldLabelWrapper(
                //       labelText: 'Address',
                //       inputField: TextFormField(
                //         controller: _addressController,
                //         maxLines: 2,
                //         decoration: const InputDecoration(
                //           hintText: 'Address',
                //         ),
                //         // validator: (value) {
                //         //   if (value == null || value.isEmpty) {
                //         //     return 'Address is required';
                //         //   }
                //         //   return null;
                //         // },
                //       ),
                //     ),
                //   ),
                // ),
              
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
                            controller: _passwordController,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Upload Photo
                // ResponsiveGridCol(
                //   lg: _lg,
                //   md: _md,
                //   child: Padding(
                //         padding: EdgeInsetsDirectional.all(
                //           _sizeInfo.innerSpacing / 2,
                //         ),
                //         child: TextFieldLabelWrapper(
                //           labelText: 'Upload Photo',
                //           inputField: AcnooFileInputField(
                //             onTap: () {},
                //             decoration: const InputDecoration(
                //               hintText: 'Upload Photo',
                //               contentPadding: EdgeInsetsDirectional.symmetric(
                //                 horizontal: 16,
                //                 vertical: 12,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),

              ],
            ),

          ),
Padding(
            padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
            child: ElevatedButton(
              onPressed: () {
                // Add your update logic here
                if (_browserDefaultFormKey.currentState!.validate()) {
                  _createTeacher(_usernameController.text, _fullNameController.text, _emailController.text, _passwordController.text);
                }
              },
              child: const Text('Create Teacher'),
            ),
          ),
      ],
      ),
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
