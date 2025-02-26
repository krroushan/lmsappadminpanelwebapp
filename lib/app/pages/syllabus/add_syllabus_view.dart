// 🐦 Flutter imports:
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // Import this for kIsWeb

import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import '../../core/api_service/class_service.dart';
import '../../models/classes/class_info.dart';
import '../../core/helpers/field_styles/field_styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:logger/logger.dart';
import '../../models/subject/subject.dart';
import '../../models/teacher/teacher.dart';
import '../../models/board/board.dart';
import '../../core/api_service/subject_service.dart';
import '../../core/api_service/teacher_service.dart';
import '../../core/api_service/syllabus_service.dart';
import '../../core/api_service/board_service.dart';

class AddSyllabusView extends StatefulWidget {
  const AddSyllabusView({super.key});

  @override
  State<AddSyllabusView> createState() => _AddSyllabusViewState();
}

class _AddSyllabusViewState extends State<AddSyllabusView> {
  var logger = Logger();

  final browserDefaultFormKey = GlobalKey<FormState>();
  bool isBrowserDefaultChecked = false;

  bool _isLoading = false;

  PlatformFile? selectedFile;
  String? selectedFilePath;
  Uint8List? selectedFileBytes;
  String? mimeType;
  int? fileSize;

  final customFormKey = GlobalKey<FormState>();
  bool isCustomFormChecked = false;
  String token = '';

  String _classId = "";
  String _subjectId = "";
  String _teacherId = "";
  String _boardId = "";

   // Declare TextEditingControllers
  final TextEditingController titleController = TextEditingController();

  final _syllabusService = SyllabusService();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) {
      return;
    }

    setState(() {
      selectedFile = result.files.first;
      mimeType = selectedFile!.extension != null
          ? 'pdf/${selectedFile!.extension}'
          : 'unknown';
      fileSize = selectedFile!.size;
    });
    print("selectedFile: ${selectedFile!.bytes}");
  }

  // Create Study Material method
  Future<void> _createSyllabus(String title) async {
    print("title: $title");
    // Validate all required fields before proceeding
    if (title.isEmpty || 
        _classId.isEmpty ||
        _subjectId.isEmpty ||
        _boardId.isEmpty ||
        _teacherId.isEmpty ||
        selectedFile == null) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields and select a file'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _syllabusService.createSyllabus2(
        title, 
        selectedFile!.bytes!, 
        selectedFile!.name, 
        _classId, 
        _subjectId, 
        _teacherId,
        _boardId, 
        token);
        context.go('/dashboard/syllabus/all-syllabus');
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Syllabus created successfully',
              style: TextStyle(color: Colors.green)),
        ),
      );
    } catch (e) {
      logger.e('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    // Set teacher ID if user is a teacher
    if (authProvider.getRole == 'teacher') {
      _teacherId = authProvider.getUserId;
    }
    _fetchClassList();
    _fetchSubjectList();
    _fetchBoardList();
    // Only fetch teacher list if user is not a teacher
    if (authProvider.getRole != 'teacher') {
      _fetchTeacherList();
    }
  }

// class service
  final _classService = ClassService();
  final _subjectService = SubjectService();
  final _teacherService = TeacherService();
  final _boardService = BoardService();

// class list
  List<ClassInfo> _classList = [];
  List<Subject> _subjectList = [];
  List<Teacher> _teacherList = [];
  List<Board> _boardList = [];

  // fetch class list
  Future<void> _fetchClassList() async {
    final classList = await _classService.fetchAllClasses(token);
    setState(() {
      _classList = classList;
    });
  }

  // fetch subject list
  Future<void> _fetchSubjectList() async {
    final subjectList = await _subjectService.fetchAllSubjects(token);
    setState(() {
      _subjectList = subjectList;
    });
  }

  // fetch teacher list
  Future<void> _fetchTeacherList() async {
    final teacherList = await _teacherService.fetchAllTeachers(token);
    setState(() {
      _teacherList = teacherList;
    });
  }

  // fetch board list
  Future<void> _fetchBoardList() async {
    final boardList = await _boardService.fetchAllBoards(token);
    setState(() {
      _boardList = boardList;
    });
  }

  @override
  Widget build(BuildContext context) {
    const _lg = 12;
    const _md = 12;
    final _dropdownStyle = AcnooDropdownStyle(context);

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

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isTeacher = authProvider.getRole == 'teacher';

    return Scaffold(
      body: ListView(
        padding: _sizeInfo.padding,
        children: [
          Form(
            key: browserDefaultFormKey,
            child: ShadowContainer(
              headerText: 'Add Syllabus',
              child: ResponsiveGridRow(
                children: [
                  // Lecture Title
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Syllabus Title',
                        inputField: TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            hintText: 'Enter syllabus title',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter syllabus title';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                  // Board
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Board',
                        inputField: DropdownButtonFormField2(
                          menuItemStyleData: _dropdownStyle.menuItemStyle,
                          buttonStyleData: _dropdownStyle.buttonStyle,
                          iconStyleData: _dropdownStyle.iconStyle,
                          dropdownStyleData: _dropdownStyle.dropdownStyle,
                          hint: const Text('Select Board'),
                          items: _boardList
                              .map((board) => DropdownMenuItem(
                                    value: board.id,
                                    child: Text(board.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _boardId = value as String;
                              logger.d('board: $_boardId');
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // Classes
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Class',
                        inputField: DropdownButtonFormField2(
                          menuItemStyleData: _dropdownStyle.menuItemStyle,
                          buttonStyleData: _dropdownStyle.buttonStyle,
                          iconStyleData: _dropdownStyle.iconStyle,
                          dropdownStyleData: _dropdownStyle.dropdownStyle,
                          hint: const Text('Select Class'),
                          items: _classList
                              .map((classInfo) => DropdownMenuItem(
                                    value: classInfo.id,
                                    child: Text(classInfo.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _classId = value as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                   // Subjects
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Subject',
                        inputField: DropdownButtonFormField2(
                          menuItemStyleData: _dropdownStyle.menuItemStyle,
                          buttonStyleData: _dropdownStyle.buttonStyle,
                          iconStyleData: _dropdownStyle.iconStyle,
                          dropdownStyleData: _dropdownStyle.dropdownStyle,
                          hint: const Text('Select Subject'),
                          items: _subjectList
                              .map((subject) => DropdownMenuItem(
                                    value: subject.id,
                                    child: Text(subject.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _subjectId = value as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                   // Teachers
                  if (!isTeacher) ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Teacher',
                        inputField: DropdownButtonFormField2(
                          menuItemStyleData: _dropdownStyle.menuItemStyle,
                          buttonStyleData: _dropdownStyle.buttonStyle,
                          iconStyleData: _dropdownStyle.iconStyle,
                          dropdownStyleData: _dropdownStyle.dropdownStyle,
                          hint: const Text('Select Teacher'),
                          items: _teacherList
                              .map((teacher) => DropdownMenuItem(
                                    value: teacher.id,
                                    child: Text(teacher.fullName),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _teacherId = value as String;
                              logger.d('teacher: $_teacherId');
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // Syllabus File
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Syllabus File',
                        inputField: Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                await _pickFile();
                              },
                              icon:
                                  const Icon(Icons.upload_file), // Upload icon
                              label: const Text('Upload Syllabus File'),
                            ),
                            // Display the selected image here
                            if (selectedFile !=
                                null) // Check if an image is selected
                              Column(
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    'Selected File: ${selectedFile!.name}', // Display the name of the selected image
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.blue), // Set the desired text style
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Save Form Button
                  ResponsiveGridCol(
                    lg: 12,
                    md: 3,
                    xl: 2,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          if (browserDefaultFormKey.currentState?.validate() ==
                              true) {
                            browserDefaultFormKey.currentState?.save();
                            final title = titleController.text; // Get the class name
                            // Debugging: Log the values
  

// if (title.isNotEmpty && description.isNotEmpty && 
//              studyMaterialType.isNotEmpty && _subjectId.isNotEmpty && 
//              _classId.isNotEmpty && _createdBy.isNotEmpty) {
           // Call the method to create a study material
          //  _createStudyMaterial(
          //    title, 
          //    description, 
          //    "https://www.google.com", 
          //    studyMaterialType,
          //    _subjectId, 
          //    _classId, 
          //    _createdBy, 
          //  );

          _createSyllabus(title);
        //  } else {
        //    // Handle the case where one or more fields are empty
        //    ScaffoldMessenger.of(context).showSnackBar(
        //      const SnackBar(content: Text('Please fill in all fields')),
        //    );
        //  }
                            
                          }
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Create Lecture'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: _sizeInfo.innerSpacing),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    titleController.dispose();
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
