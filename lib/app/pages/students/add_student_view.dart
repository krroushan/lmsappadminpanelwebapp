// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../core/helpers/field_styles/field_styles.dart';
import '../../core/static/static.dart';
import '../../widgets/widgets.dart';
import '../../core/api_service/student_service.dart';
import '../../core/api_service/class_service.dart';
import '../../models/classes/class_info.dart';
import '../../models/student/student_create.dart';
import 'package:go_router/go_router.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import '../../core/api_service/board_service.dart';
import '../../models/board/board.dart';

class AddStudentView extends StatefulWidget {
  const AddStudentView({super.key});

  @override
  State<AddStudentView> createState() => _AddStudentViewState();
}

class _AddStudentViewState extends State<AddStudentView> {
  final _sizeInfo = const _SizeInfo();

  final browserDefaultFormKey = GlobalKey<FormState>();
  // Field State Props
  bool _obscureText = true;
  late final _dobController = TextEditingController();
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _rollNoController = TextEditingController();
  final _adhaarNoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _schoolIdRollNumberController = TextEditingController();
  final _schoolInstitutionNameController = TextEditingController();
  String _fatherOccupation = "";
  String _gender = "";
  String _category = "";
  String _disabilityStatus = "";
  String _typeOfInstitution = "";
  String _classId = "";
  String _boardId = "";

  final _studentService = StudentService();
  final _classService = ClassService();
  final _boardService = BoardService();
  String token = '';

  @override
  void dispose() {
    _dobController.dispose();
    _nameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _rollNoController.dispose();
    _adhaarNoController.dispose();
    _passwordController.dispose();
    _schoolIdRollNumberController.dispose();
    _schoolInstitutionNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchClassList();
    _fetchBoardList();
  }

  // class list
  List<ClassInfo> _classList = [];

  // fetch class list
  Future<void> _fetchClassList() async {
    final classList = await _classService.fetchAllClasses(token);
    setState(() {
      _classList = classList;
    });
  }

  // board list
  List<Board> _boardList = [];

  // fetch board list
  Future<void> _fetchBoardList() async {
    final boardList = await _boardService.fetchAllBoards(token);
    setState(() {
      _boardList = boardList;
    });
  }

  // new method to create a fake student and send to API
  Future<void> _createStudent(
    String rollNo, 
    String fullName, 
    String email,
      String password, 
      String classId, 
      String boardId,
      String schoolIdRollNumber, 
      String schoolInstitutionName,
      String fatherName,
      String motherName,
      String phoneNumber,
      String alternatePhoneNumber,
      String adharNumber,
      String dateOfBirth,
      String gender,
      String category,
      String disability,
      String typeOfInstitution,
      String fatherOccupation,
      ) async {
        print("Gender: $gender");
        print("Category: $category");
        print("Disability: $disability");
        print("Type of Institution: $typeOfInstitution");
        print("fatherName: $fatherName");
        print("motherName: $motherName");
        print("phoneNumber: $phoneNumber");
        print("alternatePhoneNumber: $alternatePhoneNumber");
        print("adharNumber: $adharNumber");
        print("dateOfBirth: $dateOfBirth");
        print("schoolIdRollNumber: $schoolIdRollNumber");
        print("schoolInstitutionName: $schoolInstitutionName");
        print("rollNo: $rollNo");
        print("fullName: $fullName");
        print("email: $email");
        print("password: $password");
        print("classId: $classId");
        print("boardId: $boardId");
    // Generate a fake student with valid data
    final studentData = StudentCreate.fromJson({
      "fullName": fullName,
      "email": email,
      "rollNo": rollNo,
      "password": password,
      "class": classId,
      "board": boardId,
      "schoolIdRollNumber": schoolIdRollNumber,
      "schoolInstitutionName": schoolInstitutionName,
      "fatherName": fatherName,
      "motherName": motherName,
      "phoneNumber": phoneNumber,
      "alternatePhoneNumber": alternatePhoneNumber,
      "adharNumber": adharNumber,
      "dateOfBirth": dateOfBirth,
      "gender": gender,
      "category": category,
      "disability": disability,
      "typeOfInstitution": typeOfInstitution,
      "fatherOccupation": fatherOccupation,
    });

    print("Student Data: ${studentData.toJson()}");

    try {
      // Send the fake student to the API
      await _studentService.createStudent(studentData, token);
      //after success
      context.go('/dashboard/students/all-students');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student created successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error creating student: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create student: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Helper method to create form text fields
  ResponsiveGridCol _buildTextFormField({
    required int lg,
    required int md,
    required String label,
    required TextEditingController controller,
    required String hint,
    String? validationMessage,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return ResponsiveGridCol(
      lg: lg,
      md: md,
      child: Padding(
        padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
        child: TextFieldLabelWrapper(
          labelText: label,
          inputField: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(hintText: hint),
            validator: validationMessage != null
                ? (value) => value?.isEmpty ?? true ? validationMessage : null
                : null,
          ),
        ),
      ),
    );
  }

// Helper method to create form number fields
  ResponsiveGridCol _buildNumberFormField({
    required int lg,
    required int md,
    required String label,
    required TextEditingController controller,
    required String hint,
    String? validationMessage,
    TextInputType keyboardType = TextInputType.number,
  }) {
    return ResponsiveGridCol(
      lg: lg,
      md: md,
      child: Padding(
        padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
        child: TextFieldLabelWrapper(
          labelText: label,
          inputField: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(hintText: hint),
            validator: validationMessage != null
                ? (value) => value?.isEmpty ?? true ? validationMessage : null
                : null,
          ),
        ),
      ),
    );
  }


  // Helper method to create dropdown fields
  ResponsiveGridCol _buildDropdownField({
    required int lg,
    required int md,
    required String label,
    required String hint,
    required List<DropdownMenuItem> items,
    required Function(dynamic) onChanged,
    required AcnooDropdownStyle dropdownStyle,
  }) {
    return ResponsiveGridCol(
      lg: lg,
      md: md,
      child: Padding(
        padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
        child: TextFieldLabelWrapper(
          labelText: label,
          inputField: DropdownButtonFormField2(
            menuItemStyleData: dropdownStyle.menuItemStyle,
            buttonStyleData: dropdownStyle.buttonStyle,
            iconStyleData: dropdownStyle.iconStyle,
            dropdownStyleData: dropdownStyle.dropdownStyle,
            hint: Text(hint),
            items: items,
            onChanged: onChanged,
          ),
        ),
      ),
    );
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
        key: browserDefaultFormKey,
        child: ListView(
          padding: _sizeInfo.padding,
          children: [
            // Input Example
            ShadowContainer(
              headerText: 'Add Student',
              child: ResponsiveGridRow(
                children: [
                  // Name
                  _buildTextFormField(
                      lg: _lg,
                      md: _md,
                      label: 'Name',
                      controller: _nameController,
                      hint: 'Enter Student Name',
                      validationMessage: 'Please enter name'),

                  // Father Name
                  _buildTextFormField(
                      lg: _lg,
                      md: _md,
                      label: 'Father Name',
                      controller: _fatherNameController,
                      hint: 'Enter Father Name',
                      validationMessage: 'Please enter father name'),

                  // Father's Occupation
                  _buildDropdownField(
                      lg: _lg,
                      md: _md,
                      label: 'Father\'s Occupation',
                      hint: 'Select Father\'s Occupation',
                      items: const [
                        DropdownMenuItem(value: 'Self Employed', child: Text('Self Employed')),
                        DropdownMenuItem(value: 'Government', child: Text('Government')),
                        DropdownMenuItem(value: 'Private', child: Text('Private')),
                        DropdownMenuItem(value: 'Farmer', child: Text('Farmer')),
                        DropdownMenuItem(value: 'Others', child: Text('Others')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _fatherOccupation = value as String;
                        });
                      },
                      dropdownStyle: _dropdownStyle),

                  // Mother Name
                  _buildTextFormField(
                      lg: _lg,
                      md: _md,
                      label: 'Mother Name',
                      controller: _motherNameController,
                      hint: 'Enter Mother Name',
                      validationMessage: 'Please enter mother name'),

                  // Email
                  _buildTextFormField(
                      lg: _lg,
                      md: _md,
                      label: 'Email',
                      controller: _emailController,
                      hint: 'Enter Student Email',
                      validationMessage: 'Please enter email'),

                  // Phone
                  _buildTextFormField(
                      lg: _lg,
                      md: _md,
                      label: 'Phone',
                      controller: _phoneController,
                      hint: 'Enter Student Phone Number',
                      validationMessage: 'Please enter phone number'),

                  // Alternate Phone
                  _buildTextFormField(
                      lg: _lg,
                      md: _md,
                      label: 'Alternate Phone',
                      controller: _rollNoController,
                      hint: 'Enter Student Alternate Phone Number',
                      validationMessage: 'Please enter alternate phone number'),

                  //Ramaanya Roll Number
                  _buildTextFormField(
                      lg: _lg,
                      md: _md,
                      label: 'Roll Number',
                      controller: _rollNoController,
                      hint: 'Enter Student Roll Number',
                      validationMessage: 'Please enter roll number'),

                  //Adhaar Number
                  _buildTextFormField(
                      lg: _lg,
                      md: _md,
                      label: 'Adhaar Number',
                      controller: _adhaarNoController,
                      hint: 'Enter Student Adhaar Number',
                      validationMessage: 'Please enter adhaar number'),

                  //School ID/Roll Number
                  _buildTextFormField(
                      lg: _lg,
                      md: _md,
                      label: 'School ID/Roll Number',
                      controller: _schoolIdRollNumberController,
                      hint: 'Enter Student School ID/Roll Number',
                      validationMessage: 'Please enter school id/roll number'),

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
                          controller: _dobController,
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select date of birth';
                            }
                            return null;
                          },
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
                              _dobController.text = DateFormat(
                                      AppDateConfig.appNumberOnlyDateFormat)
                                  .format(_result);
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  // Gender
                  _buildDropdownField(
                      lg: _lg,
                      md: _md,
                      label: 'Gender',
                      hint: 'Select Gender',
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(value: 'Female', child: Text('Female')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _gender = value as String;
                        });
                      },
                      dropdownStyle: _dropdownStyle),

                  // Category
                  _buildDropdownField(
                      lg: _lg,
                      md: _md,
                      label: 'Category',
                      hint: 'Select Category',
                      items: const [
                        DropdownMenuItem(value: 'General', child: Text('General')),
                        DropdownMenuItem(value: 'OBC', child: Text('OBC')),
                        DropdownMenuItem(value: 'SC', child: Text('SC')),
                        DropdownMenuItem(value: 'ST', child: Text('ST')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _category = value as String;
                        });
                      },
                      dropdownStyle: _dropdownStyle),

                  // Disability Status
                  _buildDropdownField(
                      lg: _lg,
                      md: _md,
                      label: 'Disability Status',
                      hint: 'Select Disability Status',
                      items: const [
                        DropdownMenuItem(value: 'Orthopedically', child: Text('Orthopedically')),
                        DropdownMenuItem(value: 'Visually Impaired', child: Text('Visually Impaired')),
                        DropdownMenuItem(value: 'Hearing', child: Text('Hearing')),
                        DropdownMenuItem(value: 'None', child: Text('None')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _disabilityStatus = value as String;
                        });
                      },
                      dropdownStyle: _dropdownStyle),

                  // Type of Institution
                  _buildDropdownField(
                      lg: _lg,
                      md: _md,
                      label: 'Type of Institution',
                      hint: 'Select Type of Institution',
                      items: const [
                        DropdownMenuItem(value: 'Government', child: Text('Government')),
                        DropdownMenuItem(value: 'Private', child: Text('Private')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _typeOfInstitution = value as String;
                        });
                      },
                      dropdownStyle: _dropdownStyle),


                  // School/Institution Name
                  _buildTextFormField(
                      lg: _lg,
                      md: _md,
                      label: 'School/Institution Name',
                      controller: _schoolInstitutionNameController,
                      hint: 'Enter Student School/Institution Name',
                      validationMessage: 'Please enter school/institution name'),

                  // Class
                  _buildDropdownField(
                      lg: _lg,
                      md: _md,
                      label: 'Class',
                      hint: 'Select Class',
                      items: _classList
                          .map((classInfo) => DropdownMenuItem(
                              value: classInfo.id, child: Text(classInfo.name)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _classId = value as String;
                        });
                      },
                      dropdownStyle: _dropdownStyle),

                  // Board
                  _buildDropdownField(
                      lg: _lg,
                      md: _md,
                      label: 'Board',
                      hint: 'Select Board',
                      items: _boardList
                          .map((board) => DropdownMenuItem(
                              value: board.id, child: Text(board.name)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _boardId = value as String;
                        });
                      },
                      dropdownStyle: _dropdownStyle),

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
                                hintText: 'Enter Student Password',
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
                                  return 'Please enter password';
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
                            hintText: 'Upload Student Photo',
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
                  if (browserDefaultFormKey.currentState?.validate() == true) {
                    //browserDefaultFormKey.currentState?.save();
                    final rollNo =
                        _rollNoController.text; // Get the roll number
                    final fullName = _nameController.text; // Get the full name
                    final email = _emailController.text; // Get the email
                    final password =
                        _passwordController.text; // Get the password
                    final classId = _classId; // Get the selected class
                    final boardId = _boardId; // Get the selected board
                    final schoolIdRollNumber = _schoolIdRollNumberController.text; // Get the school id/roll number
                    final schoolInstitutionName = _schoolInstitutionNameController.text; // Get the school/institution name
                    final fatherName = _fatherNameController.text; // Get the father name
                    final motherName = _motherNameController.text; // Get the mother name
                    final phoneNumber = _phoneController.text; // Get the phone number
                    final alternatePhoneNumber = _rollNoController.text; // Get the alternate phone number
                    final adharNumber = _adhaarNoController.text; // Get the adhar number
                    final dateOfBirth = _dobController.text; // Get the date of birth
                    final gender = _gender; // Get the gender
                    final category = _category; // Get the category
                    final disability = _disabilityStatus; // Get the disability status
                    final typeOfInstitution = _typeOfInstitution; // Get the type of institution
                    final fatherOccupation = _fatherOccupation; // Get the father occupation

                    _createStudent(
                      rollNo, 
                      fullName, 
                      email, 
                      password, 
                      classId, 
                      boardId, 
                      schoolIdRollNumber, 
                      schoolInstitutionName, 
                      fatherName, 
                      motherName, 
                      phoneNumber, 
                      alternatePhoneNumber, 
                      adharNumber, 
                      dateOfBirth, 
                      gender, 
                      category, 
                      disability, 
                      typeOfInstitution,
                      fatherOccupation
                      );
                  }
                },
                child: const Text('Add Student'),
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
