// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  final _alternatePhoneController = TextEditingController();
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

  // Add these new properties
  Uint8List? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Add this property
  bool _isLoading = false;

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
    _alternatePhoneController.dispose();
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

  // Update the _createStudent method
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
        setState(() => _isLoading = true);
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
      
      // After success
      if (mounted) {
        context.go('/dashboard/students/all-students');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student created successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error creating student: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create student: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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

  // Helper method to create form text fields with number validation
  ResponsiveGridCol _buildPhoneFormField({
    required int lg,
    required int md,
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isPhone = true, // true for phone, false for adhaar
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
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: isPhone ? 10 : 12,
            decoration: InputDecoration(
              hintText: hint,
              counterText: '', // Hides the built-in counter
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              if (isPhone && value.length != 10) {
                return 'Phone number must be exactly 10 digits';
              }
              if (!isPhone && value.length != 12) {
                return 'Adhaar number must be exactly 12 digits';
              }
              return null;
            },
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
    String? value,
  }) {
    return ResponsiveGridCol(
      lg: lg,
      md: md,
      child: Padding(
        padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
        child: TextFieldLabelWrapper(
          labelText: label,
          inputField: DropdownButtonFormField2(
            value: value,
            menuItemStyleData: dropdownStyle.menuItemStyle,
            buttonStyleData: dropdownStyle.buttonStyle,
            iconStyleData: dropdownStyle.iconStyle,
            dropdownStyleData: dropdownStyle.dropdownStyle,
            hint: Text(hint),
            items: items,
            onChanged: onChanged,
            validator: (value) => value == null ? 'Please select $label' : null,
          ),
        ),
      ),
    );
  }

  // Add this method to handle image selection
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
      );
      
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImage = bytes;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
            // Photo and Basic Information in one row
            ShadowContainer(
              headerText: 'Student Information',
              child: ResponsiveGridRow(
                children: [
                  // Photo Upload Column
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Student Photo', style: _theme.textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (_selectedImage != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      _selectedImage!,
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                else
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo_outlined, 
                                        size: 48, 
                                        color: Colors.grey[600]
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Upload Passport Size Photo',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Max size: 1MB',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                Positioned.fill(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: _pickImage,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Basic Information Fields
                  ResponsiveGridCol(
                    lg: 8,
                    md: 6,
                    child: ResponsiveGridRow(
                      children: [
                        _buildTextFormField(
                          lg: 6,
                          md: 12,
                          label: 'Name',
                          controller: _nameController,
                          hint: 'Enter Student Name',
                          validationMessage: 'Please enter name'
                        ),
                        _buildDropdownField(
                          lg: 6,
                          md: 12,
                          label: 'Gender',
                          hint: 'Select Gender',
                          value: _gender.isEmpty ? null : _gender,
                          items: const [
                            DropdownMenuItem(value: 'Male', child: Text('Male')),
                            DropdownMenuItem(value: 'Female', child: Text('Female')),
                          ],
                          onChanged: (value) => setState(() => _gender = value as String),
                          dropdownStyle: _dropdownStyle
                        ),
                        // Date of Birth field with adjusted size
                        ResponsiveGridCol(
                          lg: 6,
                          md: 12,
                          child: Padding(
                            padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                            child: TextFieldLabelWrapper(
                              labelText: 'Date of Birth',
                              inputField: TextFormField(
                                controller: _dobController,
                                keyboardType: TextInputType.visiblePassword,
                                readOnly: true,
                                selectionControls: EmptyTextSelectionControls(),
                                decoration: InputDecoration(
                                  hintText: 'mm/dd/yyyy',
                                  suffixIcon: const Icon(IconlyLight.calendar, size: 20),
                                  suffixIconConstraints: _inputFieldStyle.iconConstraints,
                                ),
                                validator: (value) => value?.isEmpty ?? true ? 'Please select date of birth' : null,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Family Information
            ShadowContainer(
              headerText: 'Family Information',
              child: ResponsiveGridRow(
                children: [
                  // Father's details
                  _buildTextFormField(
                    lg: _lg,
                    md: _md,
                    label: 'Father Name',
                    controller: _fatherNameController,
                    hint: 'Enter Father Name',
                    validationMessage: 'Please enter father name'
                  ),
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
                    onChanged: (value) => setState(() => _fatherOccupation = value as String),
                    dropdownStyle: _dropdownStyle
                  ),
                  _buildTextFormField(
                    lg: _lg,
                    md: _md,
                    label: 'Mother Name',
                    controller: _motherNameController,
                    hint: 'Enter Mother Name',
                    validationMessage: 'Please enter mother name'
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Contact Information
            ShadowContainer(
              headerText: 'Contact Information',
              child: ResponsiveGridRow(
                children: [
                  _buildTextFormField(
                    lg: _lg,
                    md: _md,
                    label: 'Email',
                    controller: _emailController,
                    hint: 'Enter Student Email',
                    validationMessage: 'Please enter email'
                  ),
                  _buildPhoneFormField(
                    lg: _lg,
                    md: _md,
                    label: 'Phone',
                    controller: _phoneController,
                    hint: 'Enter 10-digit Phone Number',
                  ),
                  _buildPhoneFormField(
                    lg: _lg,
                    md: _md,
                    label: 'Alternate Phone',
                    controller: _alternatePhoneController,
                    hint: 'Enter 10-digit Alternate Phone Number',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Academic Information
            ShadowContainer(
              headerText: 'Academic Information',
              child: ResponsiveGridRow(
                children: [
                  _buildDropdownField(
                    lg: _lg,
                    md: _md,
                    label: 'Class',
                    hint: 'Select Class',
                    items: _classList.map((classInfo) => 
                      DropdownMenuItem(value: classInfo.id, child: Text(classInfo.name))
                    ).toList(),
                    onChanged: (value) => setState(() => _classId = value as String),
                    dropdownStyle: _dropdownStyle
                  ),
                  _buildDropdownField(
                    lg: _lg,
                    md: _md,
                    label: 'Board',
                    hint: 'Select Board',
                    items: _boardList.map((board) =>
                      DropdownMenuItem(value: board.id, child: Text(board.name))
                    ).toList(),
                    onChanged: (value) => setState(() => _boardId = value as String),
                    dropdownStyle: _dropdownStyle
                  ),
                  _buildTextFormField(
                    lg: _lg,
                    md: _md,
                    label: 'Roll Number',
                    controller: _rollNoController,
                    hint: 'Enter Student Roll Number',
                    validationMessage: 'Please enter roll number'
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // School Information
            ShadowContainer(
              headerText: 'School Information',
              child: ResponsiveGridRow(
                children: [
                  _buildTextFormField(
                    lg: _lg,
                    md: _md,
                    label: 'School/Institution Name',
                    controller: _schoolInstitutionNameController,
                    hint: 'Enter Student School/Institution Name',
                    validationMessage: 'Please enter school/institution name'
                  ),
                  _buildTextFormField(
                    lg: _lg,
                    md: _md,
                    label: 'School ID/Roll Number',
                    controller: _schoolIdRollNumberController,
                    hint: 'Enter School ID/Roll Number',
                    validationMessage: 'Please enter school ID/roll number'
                  ),
                  _buildDropdownField(
                    lg: _lg,
                    md: _md,
                    label: 'Type of Institution',
                    hint: 'Select Type of Institution',
                    value: _typeOfInstitution.isEmpty ? null : _typeOfInstitution,
                    items: const [
                      DropdownMenuItem(value: 'Government', child: Text('Government')),
                      DropdownMenuItem(value: 'Private', child: Text('Private')),
                      DropdownMenuItem(value: 'Semi-Government', child: Text('Semi-Government')),
                    ],
                    onChanged: (value) => setState(() => _typeOfInstitution = value as String),
                    dropdownStyle: _dropdownStyle
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Additional Details
            ShadowContainer(
              headerText: 'Additional Details',
              child: ResponsiveGridRow(
                children: [
                  _buildDropdownField(
                    lg: _lg,
                    md: _md,
                    label: 'Category',
                    hint: 'Select Category',
                    value: _category.isEmpty ? null : _category,
                    items: const [
                      DropdownMenuItem(value: 'General', child: Text('General')),
                      DropdownMenuItem(value: 'OBC', child: Text('OBC')),
                      DropdownMenuItem(value: 'SC', child: Text('SC')),
                      DropdownMenuItem(value: 'ST', child: Text('ST')),
                    ],
                    onChanged: (value) => setState(() => _category = value as String),
                    dropdownStyle: _dropdownStyle
                  ),
                  _buildDropdownField(
                    lg: _lg,
                    md: _md,
                    label: 'Disability Status',
                    hint: 'Select Disability Status',
                    value: _disabilityStatus.isEmpty ? null : _disabilityStatus,
                    items: const [
                      DropdownMenuItem(value: 'Orthopedically', child: Text('Orthopedically')),
                      DropdownMenuItem(value: 'Visually Impaired', child: Text('Visually Impaired')),
                      DropdownMenuItem(value: 'Hearing', child: Text('Hearing')),
                      DropdownMenuItem(value: 'None', child: Text('None')),
                    ],
                    onChanged: (value) => setState(() => _disabilityStatus = value as String),
                    dropdownStyle: _dropdownStyle
                  ),
                  _buildPhoneFormField(
                    lg: _lg,
                    md: _md,
                    label: 'Adhaar Number',
                    controller: _adhaarNoController,
                    hint: 'Enter 12-digit Adhaar Number',
                    isPhone: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Security Information
            ShadowContainer(
              headerText: 'Security Information',
              child: ResponsiveGridRow(
                children: [
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
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
                                    _obscureText ? FeatherIcons.eye : FeatherIcons.eyeOff,
                                    size: 20,
                                  ),
                                ),
                                suffixIconConstraints: _inputFieldStyle.iconConstraints,
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
                ],
              ),
            ),
            const SizedBox(height: 24),

            Padding(
              padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
              child: ElevatedButton(
                onPressed: _isLoading 
                  ? null 
                  : () {
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
                        final alternatePhoneNumber = _alternatePhoneController.text; // Get the alternate phone number
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
                child: _isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text('Creating Student...'),
                      ],
                    )
                  : const Text('Add Student'),
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
