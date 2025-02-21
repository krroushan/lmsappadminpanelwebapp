// 🐦 Flutter imports:
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // Import this for kIsWeb

import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../models/syllabus/syllabus_update.dart';
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

class EditSyllabusView extends StatefulWidget {
  final String syllabusId;
  const EditSyllabusView({super.key, required this.syllabusId});


  @override
  State<EditSyllabusView> createState() => _EditSyllabusViewState();

}

class _EditSyllabusViewState extends State<EditSyllabusView> {
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


  String? prevPdfUrl = '';
  // Add new variable to store the uploaded file URL
  String? uploadedFileUrl;
  double _uploadProgress = 0.0;

  // Add new loading state for upload button
  bool _isUploadLoading = false;

  // Modify _pickFile to handle upload loading state
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result == null) return;

      setState(() {
        selectedFile = result.files.first;
        mimeType = 'application/pdf';
        fileSize = selectedFile!.size;
        _isUploadLoading = true;
        _uploadProgress = 0.0;
      });

      // Debug logs
      logger.d('File details:');
      logger.d('Name: ${selectedFile!.name}');
      logger.d('Size: ${selectedFile!.size} bytes');
      logger.d('Has data: ${selectedFile!.bytes != null}');
      
      if (selectedFile?.bytes == null || selectedFile!.bytes!.isEmpty) {
        throw Exception('File data is empty or null');
      }

      if (selectedFile!.size > 10 * 1024 * 1024) { // 10MB limit example
        throw Exception('File size exceeds limit');
      }

      final response = await _syllabusService.uploadSyllabusPdf(
        titleController.text.trim(),
        selectedFile!.bytes!,
        selectedFile!.name,
        prevPdfUrl ?? '',
        token,
      );

      logger.d('Upload response: $response');

      if (response == null || response.isEmpty) {
        throw Exception('Empty response from server');
      }

      setState(() {
        uploadedFileUrl = response;
        _isUploadLoading = false;
        _uploadProgress = 1.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File uploaded successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      logger.e('File upload error: $e');
      setState(() {
        _isUploadLoading = false;
        _uploadProgress = 0.0;
      });
      
      String errorMessage = 'Failed to upload file';
      if (e.toString().contains('size exceeds')) {
        errorMessage = 'File size is too large';
      } else if (e.toString().contains('data is empty')) {
        errorMessage = 'Invalid file data';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // fetch existing syllabus data
  Future<void> _fetchExistingSyllabus() async {
    final syllabus = await _syllabusService.fetchSyllabusById(widget.syllabusId, token);
    setState(() {
      titleController.text = syllabus.title;
      _classId = syllabus.classInfo?.id ?? '';
      _subjectId = syllabus.subject?.id ?? '';
      _teacherId = syllabus.teacher?.id ?? '';
      _boardId = syllabus.board?.id ?? '';
      prevPdfUrl = syllabus.fileUrl;
    });
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
    _fetchExistingSyllabus();
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

  // fetch teacher list if user is not a teacher
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

  // Add update syllabus method
  Future<void> _updateSyllabus() async {
    if (!browserDefaultFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _syllabusService.updateSyllabus(
        widget.syllabusId,
        SyllabusUpdate(
          title: titleController.text,
          classId: _classId,
          subjectId: _subjectId,
          teacherId: _teacherId,
          boardId: _boardId,
          fileUrl: uploadedFileUrl ?? '',
        ),
        token,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Syllabus updated successfully')),
      );
      context.go('/dashboard/syllabus/all-syllabus');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update syllabus: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                          value: _boardId.isNotEmpty ? _boardId : null,
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
                          value: _classId.isNotEmpty ? _classId : null,
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
                          value: _subjectId.isNotEmpty ? _subjectId : null,
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
                          value: _teacherId.isNotEmpty ? _teacherId : null,
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
                              onPressed: _isUploadLoading ? null : () async {
                                await _pickFile();
                              },
                              icon: _isUploadLoading 
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.upload_file),
                              label: Text(_isUploadLoading ? 'Uploading...' : 'Upload Syllabus File'),
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
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: _isLoading ? null : _updateSyllabus,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text('Update Syllabus'),
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
