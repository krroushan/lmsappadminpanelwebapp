// 🐦 Flutter imports:
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // Import this for kIsWeb

import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_service/subject_service.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import '../../core/api_service/class_service.dart';
import '../../models/classes/class_info.dart';
import '../../core/helpers/field_styles/field_styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:logger/logger.dart';
import '../../core/api_service/board_service.dart';
import '../../core/api_service/exam_service.dart';
import '../../models/subject/subject.dart';
import '../../models/board/board.dart';
import '../../models/exam/exam.dart';


class EditExamView extends StatefulWidget {
  final String? examId;
  const EditExamView({super.key, this.examId});

  @override
  State<EditExamView> createState() => _EditExamViewState();
}

class _EditExamViewState extends State<EditExamView> {
  var logger = Logger();

  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String token = '';

  // Controllers
  final TextEditingController examTitleController = TextEditingController();
  final TextEditingController examDescriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController numberOfQuestionsController = TextEditingController();
  final TextEditingController totalMarksController = TextEditingController();

  // Selected IDs
  String _classId = "";
  String _classInfoId = "";
  String _subjectId = "";
  String _subjectInfoId = "";
  String _boardId = "";
  String _boardInfoId = "";

  String _createdById = "";
  String _createdByModel = "";

  // Services
  final _classService = ClassService();
  final _subjectService = SubjectService();
  final _boardService = BoardService();
  final _examService = ExamService();
  // Data lists
  List<ClassInfo> _classList = [];
  List<Subject> _subjectList = [];
  List<Board> _boardList = [];

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _createdById = authProvider.getUserId;
    _createdByModel = authProvider.getRole;
    _fetchData();
    if (widget.examId != null) {
      _fetchExamDetails();
    }
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final classList = await _classService.fetchAllClasses(token);
      final subjectList = await _subjectService.fetchAllSubjects(token);
      final boardList = await _boardService.fetchAllBoards(token);

      setState(() {
        _classList = classList;
        _subjectList = subjectList;
        _boardList = boardList;
      });
    } catch (e) {
      logger.e('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchExamDetails() async {
    setState(() => _isLoading = true);
    try {
      final exam = await ExamService.getExamById(widget.examId!, token);
      
      setState(() {
        examTitleController.text = exam.title;
        examDescriptionController.text = exam.description ?? '';
        _subjectId = exam.subject.id;
        _subjectInfoId = exam.subject.id;
        _classId = exam.classInfo.id;
        _classInfoId = exam.classInfo.id;
        _boardId = exam.board.id;
        _boardInfoId = exam.board.id;
        durationController.text = exam.duration.toString();
        numberOfQuestionsController.text = exam.numberOfQuestions.toString();
        totalMarksController.text = exam.totalMarks.toString();
      });
    } catch (e) {
      logger.e('Error fetching exam details: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading exam details: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveExam() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      final examData = {
        'title': examTitleController.text.trim(),
        'description': examDescriptionController.text.trim(),
        'subject': _subjectInfoId,
        'classInfo': _classInfoId,
        'board': _boardInfoId,
        'duration': int.parse(durationController.text),
        'numberOfQuestions': int.parse(numberOfQuestionsController.text),
        'totalMarks': int.parse(totalMarksController.text),
      };

      if (widget.examId != null) {
        await _examService.updateExam(widget.examId!, examData, token);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Exam updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/dashboard/exams');
        }
      }
    } catch (e) {
      logger.e('Error saving exam: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving exam: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const _lg = 4;
    const _md = 6;
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

    // Update the header text and button text based on whether we're editing or creating
    final headerText = widget.examId != null ? 'Edit Exam' : 'Add Exam';
    final buttonText = widget.examId != null ? 'Update Exam' : 'Create Exam';

    return Scaffold(
      body: _isLoading && _classList.isEmpty 
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: _sizeInfo.padding,
              children: [
                Form(
                  key: formKey,
                  child: ShadowContainer(
                    headerText: headerText,
                    child: ResponsiveGridRow(
                      children: [
                        // Exam Title
                        ResponsiveGridCol(
                          lg: _lg,
                          md: _md,
                          child: Padding(
                            padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                            child: TextFieldLabelWrapper(
                              labelText: 'Exam Title',
                              inputField: TextFormField(
                                controller: examTitleController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter exam title',
                                ),
                                validator: (value) => value?.isEmpty ?? true 
                                    ? 'Please enter exam title' 
                                    : null,
                              ),
                            ),
                          ),
                        ),

                        // Description
                        ResponsiveGridCol(
                          lg: _lg,
                          md: _md,
                          child: Padding(
                            padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                            child: TextFieldLabelWrapper(
                              labelText: 'Description',
                              inputField: TextFormField(
                                controller: examDescriptionController,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  hintText: 'Enter exam description',
                                ),
                                validator: (value) => value?.isEmpty ?? true 
                                    ? 'Please enter exam description' 
                                    : null,
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
                              inputField: DropdownButtonFormField2(
                                menuItemStyleData: _dropdownStyle.menuItemStyle,
                                buttonStyleData: _dropdownStyle.buttonStyle,
                                iconStyleData: _dropdownStyle.iconStyle,
                                dropdownStyleData: _dropdownStyle.dropdownStyle,
                                value: _classId.isNotEmpty ? _classId : null,
                                hint: const Text('Select Class'),
                                items: _classList.map((classInfo) => 
                                  DropdownMenuItem(
                                    value: classInfo.id,
                                    child: Text(classInfo.name),
                                  )
                                ).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _classId = value as String;
                                    _classInfoId = value;
                                  });
                                },
                                validator: (value) => value == null 
                                    ? 'Please select a class' 
                                    : null,
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
                                hint: const Text('Select Subject'),
                                value: _subjectId.isNotEmpty ? _subjectId : null,
                                items: _subjectList.map((subject) => 
                                  DropdownMenuItem(
                                    value: subject.id,
                                    child: Text(subject.name),
                                  )
                                ).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _subjectId = value as String;
                                    _subjectInfoId = value;
                                  });
                                },
                                validator: (value) => value == null 
                                    ? 'Please select a subject' 
                                    : null,
                              ),
                            ),
                          ),
                        ),

                        // Board Dropdown
                        ResponsiveGridCol(
                          lg: _lg,
                          md: _md,
                          child: Padding(
                            padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                            child: TextFieldLabelWrapper(
                              labelText: 'Board',
                              inputField: DropdownButtonFormField2(
                                menuItemStyleData: _dropdownStyle.menuItemStyle,
                                buttonStyleData: _dropdownStyle.buttonStyle,
                                iconStyleData: _dropdownStyle.iconStyle,
                                dropdownStyleData: _dropdownStyle.dropdownStyle,
                                hint: const Text('Select Board'),
                                value: _boardId.isNotEmpty ? _boardId : null,
                                items: _boardList.map((board) => 
                                  DropdownMenuItem(
                                    value: board.id,
                                    child: Text(board.name),
                                  )
                                ).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _boardId = value as String;
                                    _boardInfoId = value;
                                  });
                                },
                                validator: (value) => value == null 
                                    ? 'Please select a board' 
                                    : null,
                              ),
                            ),
                          ),
                        ),

                        // Duration
                        ResponsiveGridCol(
                          lg: _lg,
                          md: _md,
                          child: Padding(
                            padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                            child: TextFieldLabelWrapper(
                              labelText: 'Duration (minutes)',
                              inputField: TextFormField(
                                controller: durationController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Enter exam duration',
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please enter duration';
                                  }
                                  if (int.tryParse(value!) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),

                        // Number of Questions
                        ResponsiveGridCol(
                          lg: _lg,
                          md: _md,
                          child: Padding(
                            padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                            child: TextFieldLabelWrapper(
                              labelText: 'Number of Questions',
                              inputField: TextFormField(
                                controller: numberOfQuestionsController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Enter number of questions',
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please enter number of questions';
                                  }
                                  if (int.tryParse(value!) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),

                        // Total Marks
                        ResponsiveGridCol(
                          lg: _lg,
                          md: _md,
                          child: Padding(
                            padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                            child: TextFieldLabelWrapper(
                              labelText: 'Total Marks',
                              inputField: TextFormField(
                                controller: totalMarksController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Enter total marks',
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please enter total marks';
                                  }
                                  if (int.tryParse(value!) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),

                        // Submit Button
                        ResponsiveGridCol(
                          lg: 12,
                          md: 3,
                          xl: 2,
                          child: Padding(
                            padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: _isLoading ? null : _saveExam,
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text(buttonText),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    examTitleController.dispose();
    examDescriptionController.dispose();
    durationController.dispose();
    numberOfQuestionsController.dispose();
    totalMarksController.dispose();
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
