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
import '../../core/api_service/subject_service.dart';
import '../../core/api_service/teacher_service.dart';
import '../../core/api_service/study_material_service.dart';
import '../../models/study-material/study_material_update.dart';

class UpdateStudyMaterialView extends StatefulWidget {
  final String studyMaterialId;
  const UpdateStudyMaterialView({super.key, required this.studyMaterialId});

  @override
  State<UpdateStudyMaterialView> createState() => _UpdateStudyMaterialViewState();
}

class _UpdateStudyMaterialViewState extends State<UpdateStudyMaterialView> {
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
  String studyMaterialType = "";

  String previousFileUrl = "";

   // Declare TextEditingControllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final _studyMaterialService = StudyMaterialService();

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

  Future<void> _fetchStudyMaterial() async {
    final studyMaterial = await _studyMaterialService.fetchStudyMaterialById(widget.studyMaterialId, token);
    setState(() {
      logger.d('studyMaterial: ${studyMaterial.toJson()}');
      titleController.text = studyMaterial.title ?? '';
      descriptionController.text = studyMaterial.description ?? '';
      studyMaterialType = studyMaterial.type ?? '';
      _classId = studyMaterial.classInfo?.id ?? '';
      logger.d('classId: $_classId');
      _subjectId = studyMaterial.subject?.id ?? '';
      logger.d('subjectId: $_subjectId');
      _teacherId = studyMaterial.teacher?.id ?? '';
      logger.d('teacherId: $_teacherId');
      previousFileUrl = studyMaterial.fileUrl ?? '';
    });
  }

  // Update Study Material method
  Future<void> _updateStudyMaterial(String title, String description) async {
    // Validate all required fields before proceeding
    if (title.isEmpty || 
        description.isEmpty || 
        studyMaterialType.isEmpty ||
        _classId.isEmpty ||
        _subjectId.isEmpty ||
        _teacherId.isEmpty) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      // If a new file is selected, upload it first
      String fileUrl = previousFileUrl; // Default to existing file URL
      if (selectedFile != null) {
        // Upload new file and get URL
      await _studyMaterialService.updateStudyMaterial2(
          widget.studyMaterialId,
          title,
          description,
          studyMaterialType,
          selectedFile!.bytes!,
          selectedFile!.name,
          _classId,
          _subjectId,
          _teacherId,
          token
        );
      } else {
        logger.e('No file selected');
        // Create updated study material object
      final updatedStudyMaterial = StudyMaterialUpdate(
        title: title,
        description: description,
        fileUrl: fileUrl,
        type: studyMaterialType,
        subjectId: _subjectId,
        classId: _classId,
        teacherId: _teacherId,
      );
      logger.d('updatedStudyMaterial: ${updatedStudyMaterial.toJson()}');

      // Call update API
      await _studyMaterialService.updateStudyMaterial(
        widget.studyMaterialId,
        updatedStudyMaterial,
        token
      );
      }

      

      context.go('/dashboard/study-materials/all-study-materials');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Study Material updated successfully',
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
    // Only fetch teacher list if user is not a teacher
    if (authProvider.getRole != 'teacher') {
      _fetchTeacherList();
    }
    _fetchStudyMaterial();
  }

// class service
  final _classService = ClassService();
  final _subjectService = SubjectService();
  final _teacherService = TeacherService();

// class list
  List<ClassInfo> _classList = [];
  List<Subject> _subjectList = [];
  List<Teacher> _teacherList = [];

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
              headerText: 'Add Study Material',
              child: ResponsiveGridRow(
                children: [
                  // Lecture Title
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Study Material Title',
                        inputField: TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            hintText: 'Enter study material title',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter study material title';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                  // Lecture Description
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Study Material Description',
                        inputField: TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Enter study material description',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter study material description';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                  // Study Material Type
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Study Material Type',
                        inputField: DropdownButtonFormField2(
                          menuItemStyleData: _dropdownStyle.menuItemStyle,
                          buttonStyleData: _dropdownStyle.buttonStyle,
                          iconStyleData: _dropdownStyle.iconStyle,
                          dropdownStyleData: _dropdownStyle.dropdownStyle,
                          hint: const Text('Select Study Material Type'),
                          value: studyMaterialType.isNotEmpty ? studyMaterialType : null,
                          items: [
                            {'key': 'Pdf', 'value': 'pdf'},
                          ].map((studyMaterialType) => DropdownMenuItem(
                            value: studyMaterialType['value'],
                            child: Text(studyMaterialType['key']!),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              studyMaterialType = value as String;
                              logger.d('studyMaterialType: $studyMaterialType');
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
                          items: _classList.map((classInfo) => DropdownMenuItem(
                            value: classInfo.id,
                            child: Text(classInfo.name),
                          )).toList(),
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
                          items: _subjectList.map((subject) => DropdownMenuItem(
                            value: subject.id,
                            child: Text(subject.name),
                          )).toList(),
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
                          items: _teacherList.map((teacher) => DropdownMenuItem(
                            value: teacher.id,
                            child: Text(teacher.fullName),
                          )).toList(),
                          onChanged: (value) {
                            setState(() {
                              _teacherId = value as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // Study Material File
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Study Material File',
                        inputField: Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                await _pickFile();
                              },
                              icon:
                                  const Icon(Icons.upload_file), // Upload icon
                              label: const Text('Upload Study Material File'),
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
                                  // Previous Uploaded file
                                  Text(
                                    'Previous Uploaded File: $previousFileUrl', // Display the name of the selected image
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
                          if (browserDefaultFormKey.currentState?.validate() == true) {
                            browserDefaultFormKey.currentState?.save();
                            final title = titleController.text;
                            final description = descriptionController.text;
                            _updateStudyMaterial(title, description);
                          }
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Update Study Material'),
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
    descriptionController.dispose();
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
