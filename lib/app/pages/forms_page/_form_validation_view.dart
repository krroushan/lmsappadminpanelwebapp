// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/helpers/field_styles/field_styles.dart';
import '../../widgets/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import '../../core/api_config/api_config.dart';
import '../../core/api_service/class_service.dart';
import '../../models/classes/class_info.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';

class FormValidationView extends StatefulWidget {
  const FormValidationView({super.key});

  @override
  State<FormValidationView> createState() => _FormValidationViewState();
}

class _FormValidationViewState extends State<FormValidationView> {
  final browserDefaultFormKey = GlobalKey<FormState>();
  bool isBrowserDefaultChecked = false;

  final customFormKey = GlobalKey<FormState>();
  bool isCustomFormChecked = false;

  final _classService = ClassService();
  List<ClassInfo> _classes = [];

  // Declare TextEditingControllers
  final TextEditingController rollNoController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController classIdController = TextEditingController();
  final TextEditingController subjectIdController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  String? selectedClass;
  String token = '';

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    try {
      List<ClassInfo> response = await _classService.fetchAllClasses(token); // Fetch the response
      setState(() {
          _classes = response;
      });
      
        print("aclass: ${_classes.length}");
    } catch (e) {
      print(e);
      throw Exception('Failed to load classes');
    }
  }

  // New method to create a student
Future<void> _createStudent(String rollNo, String fullName, String email, String password, String classId) async {
  final response = await http.post(
    Uri.parse('http://localhost:8000/api/student/create'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'rollNo': rollNo,
      'fullName': fullName,
      'email': email,
      'password': password,
      'class': classId,
    }),
  );

  if (response.statusCode == 201) {
    final responseData = json.decode(response.body);
    // Optionally, you can add the new student to the local list
    print(responseData);
    setState(() {
      //_students.add(StudentDataModel.fromJson(responseData['newStudent']));
      context.go('/dashboard/students/all-students');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(responseData['message'])),
    );

    } else {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create student: ${json.decode(response.body)['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);
    // final _inputFieldStyle = AcnooInputFieldStyles(context);
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
            padding: EdgeInsets.all(16),
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
          // Browser Default Form
          Form(
            key: browserDefaultFormKey,
            child: ShadowContainer(
              headerText: 'Add Student',
              child: ResponsiveGridRow(
                children: [
                  // Full Name
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Full Name',
                        inputField: TextFormField(
                          controller: fullNameController,
                          decoration:  const InputDecoration(
                            hintText: 'Enter full name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter full name';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                  // Roll Number
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Roll Number',
                        inputField: TextFormField(
                          controller: rollNoController,
                          decoration:  const InputDecoration(
                            hintText: 'Enter your roll number',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your roll number';
                              //return lang.pleaseEnterYourLastName;
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                   // Email
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Email',
                        inputField: TextFormField(
                          controller: emailController,
                          decoration:  const InputDecoration(
                            hintText: 'Enter your email',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                  // Class Dropdown
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Class',
                        //labelText: lang.country,
                        inputField: DropdownButtonFormField2(
                          menuItemStyleData: _dropdownStyle.menuItemStyle,
                          buttonStyleData: _dropdownStyle.buttonStyle,
                          iconStyleData: _dropdownStyle.iconStyle,
                          dropdownStyleData: _dropdownStyle.dropdownStyle,
                          //hint: const Text('Select Country'),
                          hint: Text('Select Class'),
                          items: _classes
                              .map(
                                (classResponse) => DropdownMenuItem(
                                  value: classResponse.id,
                                  child: Text(classResponse.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            selectedClass = value;
                          },
                          validator: (value) {
                            selectedClass = value;
                            if (value == null || value.isEmpty) {
                              return 'Please select your class';
                            }

                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                  // Subject Dropdown
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Subject',
                        inputField: DropdownButtonFormField2(
                          menuItemStyleData: _dropdownStyle.menuItemStyle,
                          buttonStyleData: _dropdownStyle.buttonStyle,
                          iconStyleData: _dropdownStyle.iconStyle,
                          dropdownStyleData: _dropdownStyle.dropdownStyle,
                          hint:  Text('Select Subject'),
                          items: [
                            "Maths",
                            "Science",
                            "English",
                            "Hindi",
                            "Sanskrit",
                            "Computer Science",
                            "Physical Education",
                            "Mexico City",
                          ]
                              .map(
                                (country) => DropdownMenuItem(
                                  value: country,
                                  child: Text(country),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your subject';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Gender',
                        inputField: DropdownButtonFormField2(
                          menuItemStyleData: _dropdownStyle.menuItemStyle,
                          buttonStyleData: _dropdownStyle.buttonStyle,
                          iconStyleData: _dropdownStyle.iconStyle,
                          dropdownStyleData: _dropdownStyle.dropdownStyle,
                          hint:  Text('Select Gender'),
                          items: [
                            "Male",
                            "Female",
                            "Other",
                          ]
                              .map(
                                (country) => DropdownMenuItem(
                                  value: country,
                                  child: Text(country),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your gender';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                  // Check Box
                  // ResponsiveGridCol(
                  //   lg: 12,
                  //   md: 12,
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: AcnooCheckBoxFormField(
                  //      // title: const Text('Agree to terms and conditions'),
                  //       title:  Text(lang.agreeToTermsAndConditions),
                  //       validator: (value) {
                  //         if (value == null || !value) {
                  //           //return 'Please check this box to continue';
                  //           return lang.pleaseCheckThisBoxToContinue;
                  //         }
                  //         return null;
                  //       },
                  //       autovalidateMode: AutovalidateMode.onUserInteraction,
                  //     ),
                  //   ),
                  // ),
                // password
                ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Password',
                        inputField: TextFormField(
                          controller: passwordController,
                          decoration:  const InputDecoration(
                            hintText: 'Enter your password',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                // Save Form Button
                ResponsiveGridCol(
                    lg: 2,
                    md: 3,
                    xl: 2,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: ElevatedButton(
                        onPressed: () {
                          if (browserDefaultFormKey.currentState?.validate() ==
                              true) {
                            //browserDefaultFormKey.currentState?.save();
                            final rollNo = rollNoController.text; // Get the roll number
                            final fullName = fullNameController.text; // Get the full name
                            final email = emailController.text; // Get the email
                            final password = passwordController.text; // Get the password
                            final classId = selectedClass; // Get the selected class

                            // Call the method to create a student
                            _createStudent(rollNo, fullName, email, password, classId!);
                          }
                        },
                        child:  Text('Save Student'),
                        //child:  Text(lang.saveFrom),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: _sizeInfo.innerSpacing),

          // Custom Form
          // Form(
          //   key: customFormKey,
          //   child: ShadowContainer(
          //    // headerText: 'Custom Styles',
          //     headerText: lang.customStyles,
          //     child: ResponsiveGridRow(
          //       children: [
          //         // First Name
          //         ResponsiveGridCol(
          //           lg: _lg + 2,
          //           md: _md,
          //           child: Padding(
          //             padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
          //             child: TextFieldLabelWrapper(
          //               //labelText: 'First Name',
          //               labelText: lang.firstName,
          //               inputField: TextFormField(
          //                 decoration:  InputDecoration(
          //                   //hintText: 'Enter your first name',
          //                   hintText: lang.enterYourFirstName,
          //                 ),
          //                 validator: (value) {
          //                   if (value == null || value.isEmpty) {
          //                    // return 'Please enter your first name';
          //                     return lang.pleaseEnterYourFirstName;
          //                   }
          //                   return null;
          //                 },
          //                 autovalidateMode: AutovalidateMode.onUserInteraction,
          //               ),
          //             ),
          //           ),
          //         ),

          //         // Last Name
          //         ResponsiveGridCol(
          //           lg: _lg + 2,
          //           md: _md,
          //           child: Padding(
          //             padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
          //             child: TextFieldLabelWrapper(
          //               //labelText: 'Last Name',
          //               labelText: lang.lastName,
          //               inputField: TextFormField(
          //                 decoration:  InputDecoration(
          //                   //hintText: 'Enter your last name',
          //                   hintText: lang.enterYourLastName,
          //                 ),
          //                 validator: (value) {
          //                   if (value == null || value.isEmpty) {
          //                    // return 'Please enter your last name';
          //                     return lang.pleaseEnterYourLastName;
          //                   }
          //                   return null;
          //                 },
          //                 autovalidateMode: AutovalidateMode.onUserInteraction,
          //               ),
          //             ),
          //           ),
          //         ),

          //         // Country Dropdown
          //         ResponsiveGridCol(
          //           lg: _lg,
          //           md: _md,
          //           child: Padding(
          //             padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
          //             child: TextFieldLabelWrapper(
          //              // labelText: 'Country',
          //               labelText: lang.country,
          //               inputField: DropdownButtonFormField2(
          //                 menuItemStyleData: _dropdownStyle.menuItemStyle,
          //                 buttonStyleData: _dropdownStyle.buttonStyle,
          //                 iconStyleData: _dropdownStyle.iconStyle,
          //                 dropdownStyleData: _dropdownStyle.dropdownStyle,
          //                // hint: const Text('Select Country'),
          //                 hint:  Text(lang.selectCountry),
          //                 items: [
          //                   "Canada",
          //                   "Brazil",
          //                   "Germany",
          //                   "Australia",
          //                   "Japan",
          //                   "India",
          //                   "South Africa",
          //                   "Mexico",
          //                   "France",
          //                   "South Korea"
          //                 ]
          //                     .map(
          //                       (country) => DropdownMenuItem(
          //                         value: country,
          //                         child: Text(country),
          //                       ),
          //                     )
          //                     .toList(),
          //                 onChanged: (value) {},
          //                 validator: (value) {
          //                   if (value == null || value.isEmpty) {
          //                    // return 'Please select your country';
          //                     return lang.pleaseSelectYourCountry;
          //                   }
          //                   return null;
          //                 },
          //                 autovalidateMode: AutovalidateMode.onUserInteraction,
          //               ),
          //             ),
          //           ),
          //         ),

          //         // City Dropdown
          //         ResponsiveGridCol(
          //           lg: _lg,
          //           md: _md,
          //           child: Padding(
          //             padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
          //             child: TextFieldLabelWrapper(
          //              // labelText: 'City',
          //               labelText: lang.city,
          //               inputField: DropdownButtonFormField2(
          //                 menuItemStyleData: _dropdownStyle.menuItemStyle,
          //                 buttonStyleData: _dropdownStyle.buttonStyle,
          //                 iconStyleData: _dropdownStyle.iconStyle,
          //                 dropdownStyleData: _dropdownStyle.dropdownStyle,
          //                 //hint: const Text('Select City'),
          //                 hint:  Text(lang.selectCity),
          //                 items: [
          //                   "Toronto",
          //                   "São Paulo",
          //                   "Berlin",
          //                   "Sydney",
          //                   "Tokyo",
          //                   "Mumbai",
          //                   "Cape Town",
          //                   "Mexico City",
          //                   "Paris",
          //                   "Seoul"
          //                 ]
          //                     .map(
          //                       (country) => DropdownMenuItem(
          //                         value: country,
          //                         child: Text(country),
          //                       ),
          //                     )
          //                     .toList(),
          //                 onChanged: (value) {},
          //                 validator: (value) {
          //                   if (value == null || value.isEmpty) {
          //                     //return 'Please select your city';
          //                     return lang.pleaseSelectYourCity;
          //                   }
          //                   return null;
          //                 },
          //                 autovalidateMode: AutovalidateMode.onUserInteraction,
          //               ),
          //             ),
          //           ),
          //         ),

          //         // State Dropdown
          //         ResponsiveGridCol(
          //           lg: _lg,
          //           md: _md,
          //           child: Padding(
          //             padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
          //             child: TextFieldLabelWrapper(
          //              // labelText: 'State',
          //               labelText: lang.state,
          //               inputField: DropdownButtonFormField2(
          //                 menuItemStyleData: _dropdownStyle.menuItemStyle,
          //                 buttonStyleData: _dropdownStyle.buttonStyle,
          //                 iconStyleData: _dropdownStyle.iconStyle,
          //                 dropdownStyleData: _dropdownStyle.dropdownStyle,
          //                // hint: const Text('Select State'),
          //                 hint:  Text(lang.selectState),
          //                 items: [
          //                   "Ontario",
          //                   "São Paulo",
          //                   "Berlin",
          //                   "New South Wales",
          //                   "Tokyo Metropolis",
          //                   "Maharashtra",
          //                   "Western Cape",
          //                   "Mexico City",
          //                   "Île-de-France",
          //                   "Seoul Capital Area"
          //                 ]
          //                     .map(
          //                       (country) => DropdownMenuItem(
          //                         value: country,
          //                         child: Text(country),
          //                       ),
          //                     )
          //                     .toList(),
          //                 onChanged: (value) {},
          //                 validator: (value) {
          //                   if (value == null || value.isEmpty) {
          //                    // return 'Please select your state';
          //                     return lang.pleaseSelectYourState;
          //                   }
          //                   return null;
          //                 },
          //                 autovalidateMode: AutovalidateMode.onUserInteraction,
          //               ),
          //             ),
          //           ),
          //         ),

          //         // Check Box
          //         ResponsiveGridCol(
          //           lg: 12,
          //           md: 12,
          //           child: Align(
          //             alignment: Alignment.centerLeft,
          //             child: AcnooCheckBoxFormField(
          //              // title: const Text('Agree to terms and conditions'),
          //               title:  Text(lang.agreeToTermsAndConditions),
          //               validator: (value) {
          //                 if (value == null || !value) {
          //                  // return 'Please check this box to continue';
          //                   return lang.pleaseCheckThisBoxToContinue;
          //                 }
          //                 return null;
          //               },
          //               autovalidateMode: AutovalidateMode.onUserInteraction,
          //             ),
          //           ),
          //         ),

          //         // Save Form Button
          //         ResponsiveGridCol(
          //           lg: 2,
          //           md: 3,
          //           xl: 2,
          //           child: Padding(
          //             padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
          //             child: ElevatedButton(
          //               onPressed: () {
          //                 if (customFormKey.currentState?.validate() == true) {
          //                   customFormKey.currentState?.save();
          //                 }
          //               },
          //               //child: const Text('Save From'),
          //               child:  Text(lang.saveFrom),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

   @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    rollNoController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class _SizeInfo {
  final double? fonstSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.fonstSize,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}
