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
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import '../../core/api_service/board_service.dart';
import '../../models/board/board.dart';
import '../../models/student/student.dart';

class EditStudentView extends StatefulWidget {
  final String studentId;
    const EditStudentView({super.key, required this.studentId});

  @override
  State<EditStudentView> createState() => _EditStudentViewState();

}

class _EditStudentViewState extends State<EditStudentView> {
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

  // Add this field to store current student
  Student? _student;

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
    _fetchStudent(); // Add this line to fetch student details
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

  // Add this method to fetch student details
  Future<void> _fetchStudent() async {
    final student = await _studentService.getStudentById(widget.studentId, token);
    setState(() {
      _student = student;
      // Populate form fields with student data
      _nameController.text = student.fullName;
      _fatherNameController.text = student.fatherName;
      _motherNameController.text = student.motherName;

      _emailController.text = student.email;
      _phoneController.text = student.phoneNumber;
      _rollNoController.text = student.rollNo;
      _adhaarNoController.text = student.adharNumber;
      _schoolIdRollNumberController.text = student.schoolIdRollNumber;
      _schoolInstitutionNameController.text = student.schoolInstitutionName;
      _dobController.text = student.dateOfBirth;
      _fatherOccupation = student.fatherOccupation;

      _gender = student.gender;
      _category = student.category;
      _disabilityStatus = student.disability;
      _typeOfInstitution = student.typeOfInstitution;
      _classId = student.classInfo.id;
      _boardId = student.board.id;
    });
  }


  // Modify the update student method
  Future<void> _updateStudent() async {
    if (browserDefaultFormKey.currentState?.validate() == true) {
      final updatedStudent = Student(
        id: widget.studentId,
        rollNo: _rollNoController.text,
        fullName: _nameController.text,
        email: _emailController.text,
        classInfo: ClassInfo(id: _classId, name: _classId, description: _classId, classImage: _classId, createdAt: DateTime.now(), updatedAt: DateTime.now()),
        board: Board(id: _boardId, name: _boardId, description: _boardId, boardImage: _boardId, createdAt: DateTime.now(), updatedAt: DateTime.now()),
        schoolInstitutionName: _schoolInstitutionNameController.text,
        schoolIdRollNumber: _schoolIdRollNumberController.text,
        dateOfBirth: _dobController.text,
        gender: _gender,
        category: _category,
        disability: _disabilityStatus,
        typeOfInstitution: _typeOfInstitution,
        fatherName: _fatherNameController.text,
        motherName: _motherNameController.text,
        phoneNumber: _phoneController.text,
        alternatePhoneNumber: _rollNoController.text,
        adharNumber: _adhaarNoController.text,
        fatherOccupation: _fatherOccupation,
        password: _passwordController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );


      try {
        await _studentService.updateStudent(widget.studentId, updatedStudent.toJson(), token);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating student: ${e.toString()}')),
        );
      }
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
                onPressed: _updateStudent,
                child: const Text('Update Student'),
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
