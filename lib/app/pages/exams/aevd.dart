// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'dart:convert';

// 📦 Package imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:logger/logger.dart';

// 🌎 Project imports:
import '../../core/helpers/field_styles/field_styles.dart';
import '../../core/static/static.dart';
import '../../widgets/widgets.dart';
import '../../models/classes/class_info.dart';
import '../../models/student/student_create.dart';
import 'package:go_router/go_router.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import '../../core/api_service/exam_service.dart';
import '../../core/api_service/class_service.dart';
import '../../core/api_service/subject_service.dart';
import '../../models/subject/subject.dart';
import '../../models/exam/exam.dart';
import '../../models/exam/question.dart';
import '../../models/exam/option.dart';
import '../../core/theme/_app_colors.dart';

class AddExamViewDemo extends StatefulWidget {
  const AddExamViewDemo({super.key});

  @override
  State<AddExamViewDemo> createState() => _AddExamViewDemoState();
}

class _AddExamViewDemoState extends State<AddExamViewDemo> {
  final browserDefaultFormKey = GlobalKey<FormState>();
  // Field State Props
  bool _obscureText = true;
  late final _dateController = TextEditingController();
  final _examTitleController = TextEditingController();
  final _examDescriptionController = TextEditingController();
  final _subjectIdController = TextEditingController();
  final _classIdController = TextEditingController();
  List<TextEditingController> questionControllers = [];
  List<TextEditingController> optionControllers = [];
  final _durationController = TextEditingController();
  final _numberOfQuestionsController = TextEditingController();
  final logger = Logger();
  final _examService = ExamService();
  final _classService = ClassService();
  final _subjectService = SubjectService();
  String token = '';
  String _classId = '';
  String _subjectId = '';
  bool _isLoading = false;
  int _duration = 60;
  int _numberOfQuestions = 0;

  @override
  void dispose() {
    _dateController.dispose();
    _examTitleController.dispose();
    _examDescriptionController.dispose();
    _subjectIdController.dispose();
    _classIdController.dispose();
    for (var controller in questionControllers) {
      controller.dispose();
    }
    for (var controller in optionControllers) {
      controller.dispose();
    }
    _durationController.dispose();
    _numberOfQuestionsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchClassList();
    _fetchSubjectList();
  }

  // class list
  List<ClassInfo> _classList = [];
  List<Subject> _subjectList = [];
  List<Question> questions = [];
  List<Option> options = [];

  // fetch class list
  Future<void> _fetchClassList() async {
    final classList = await _classService.fetchAllClasses(token);
    setState(() {
      _classList = classList;
      logger.d("Class List: ${_classList.map((classInfo) => classInfo.id)}");
    });
  }

  // fetch subject list
  Future<void> _fetchSubjectList() async {
    final subjectList = await _subjectService.fetchAllSubjects(token);
    setState(() {
      _subjectList = subjectList;
      logger.d("Subject List: ${_subjectList.map((subject) => subject.id)}");
    });
  }

  // new method to create a fake exam and send to API
  Future<void> _createExam(String examTitle, String examDescription) async {
    // Save the last question's text before submission
    if (questionControllers.isNotEmpty) {
      int lastIndex = questionControllers.length - 1;
      questions[lastIndex].questionText = questionControllers[lastIndex].text;
    }

    // Validate questions
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].questionText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Question ${i + 1} cannot be empty'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
    // Generate a fake exam with valid data
    final examDataMap = {
      "title": examTitle,
      "description": examDescription,
      "subject": _subjectId,
      "class": _classId,
      "questions": questions.map((question) => question.toJson()).toList(),
      "duration": _duration,
      "numberOfQuestions": questions.length,
      "isActive": true,
    };

    logger.d("Exam Data: $examDataMap");

    try {
      final examData = Exam.fromJson(examDataMap);

      logger.d("Exam Data: ${examData.toJson()}");
      // Send the fake student to the API
      await _examService.createExam(examData, token);
      //after success
      context.go('/dashboard/exams/all-exams');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exam created successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error creating exam: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create exam: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // add question
  // void _addQuestion() {
  //   setState(() {
  //     questions.add(Question(questionText: questionControllers.last.text, questionType: 'text', options: []));
  //     questionControllers.add(TextEditingController());
  //     print('Question added: ${questions.first.questionText}');
  //   });
  // }

  void _addQuestion() {
    setState(() {
      // Print the last question if it exists
      if (questionControllers.isNotEmpty) {
        int lastIndex = questionControllers.length - 1;
        //print('Question ${lastIndex + 1}: ${questionControllers[lastIndex].text}');
        questions[lastIndex].questionText = questionControllers[lastIndex].text;

        //print all questions
        //print('All questions: ${jsonEncode(questions)}');
        //questions[lastIndex].questionType = 'multiple-choice';
      }

      // Create a new controller first
      TextEditingController newQuestionController = TextEditingController();
      questionControllers.add(newQuestionController);
      //print('Question controller added: ${newQuestionController.text}');

      // Add new question with empty text (will be updated when user types)
      questions.add(Question(
          questionText: '', questionType: 'multiple-choice', options: []));
    });
  }

  // Add this method to handle question type changes
  void _onQuestionTypeChanged(String? newType, int questionIndex) {
    setState(() {
      questions[questionIndex].questionType = newType ?? 'multiple-choice';
      // Clear options if switching to open-ended
      if (newType == 'open-ended') {
        questions[questionIndex].options = [];
      }
    });
  }

  // remove question
  void _removeQuestion(int questionIndex) {
    setState(() {
      questions.removeAt(questionIndex);
      questionControllers.removeAt(questionIndex);
    });
  }

  // add option
  void _addOption(int questionIndex) {
    setState(() {
      if (questionIndex < questions.length) {
        questions[questionIndex]
            .options
            .add(Option(optionText: '', isCorrect: false));
      }
    });
  }

  void _removeOption(int questionIndex, int optionIndex) {
    setState(() {
      questions[questionIndex].options.removeAt(optionIndex);
    });
  }

  // void _onClassChanged(String? newClass) {
  //   setState(() {
  //     _classId = newClass as String;
  //     logger.d("Class ID: $_classId");
  //   });
  // }

  // void _onSubjectChanged(String? newSubject) {
  //   setState(() {
  //     _subjectId = newSubject as String;
  //     logger.d("Subject ID: $_subjectId");
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final _dropdownStyle = AcnooDropdownStyle(context);
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
              headerText: 'Add Exam',
              child: ResponsiveGridRow(
                children: [
                  // Title
                  ResponsiveGridCol(
                    lg: 6,
                    md: 6,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Title',
                        inputField: TextFormField(
                          controller: _examTitleController,
                          decoration: const InputDecoration(
                              hintText: 'Enter Exam Title'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter title';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  // Description
                  ResponsiveGridCol(
                    lg: 6,
                    md: 6,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Description',
                        inputField: TextFormField(
                          controller: _examDescriptionController,
                          decoration: const InputDecoration(
                              hintText: 'Enter Exam Description'),
                          //autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  // Duration
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Duration',
                        inputField: DropdownButtonFormField2(
                          menuItemStyleData: _dropdownStyle.menuItemStyle,
                          buttonStyleData: _dropdownStyle.buttonStyle,
                          iconStyleData: _dropdownStyle.iconStyle,
                          dropdownStyleData: _dropdownStyle.dropdownStyle,
                          hint: const Text('Select Duration'),
                          items: [
                            const DropdownMenuItem(
                              value: 60,
                              child: Text('1 hour'),
                            ),
                            const DropdownMenuItem(
                              value: 120,
                              child: Text('2 hours'),
                            ),
                          ].toList(),
                          onChanged: (value) {
                            setState(() {
                              _duration = value as int;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // Class
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
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
                          onChanged: (valueClass) {
                            setState(() {
                              _classId = valueClass as String;
                              logger.d("Class ID: $_classId");
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // Subject
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
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
                              logger.d("Subject ID: $_subjectId");
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // Questions
                  ResponsiveGridCol(
                    lg: 12,
                    md: 12,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Add this Row at the top of the Card
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text('Question ${index + 1}',
                                  //       style: Theme.of(context).textTheme.titleMedium
                                  //     ),
                                  //     IconButton(
                                  //       icon: const Icon(Icons.delete, color: Colors.red),
                                  //       onPressed: () => _removeQuestion(index),
                                  //     ),
                                  //   ],
                                  // ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.all(
                                        _sizeInfo.innerSpacing / 2),
                                    child: TextFieldLabelWrapper(
                                      labelText: 'Question ${index + 1}',
                                      inputField: Container(
                                        constraints: const BoxConstraints(
                                          minHeight: 50,
                                          maxHeight: 150,
                                        ),
                                        child: TextFormField(
                                          controller:
                                              questionControllers[index],
                                          maxLines: null,
                                          decoration: InputDecoration(
                                              hintText:
                                                  'Enter Question ${index + 1}'),
                                          //autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter question';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Question Type Selector dropdown
                                  // Padding(
                                  //   padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                                  //   child: DropdownButtonFormField2(
                                  //     menuItemStyleData: _dropdownStyle.menuItemStyle,
                                  //     buttonStyleData: _dropdownStyle.buttonStyle,
                                  //     iconStyleData: _dropdownStyle.iconStyle,
                                  //     dropdownStyleData: _dropdownStyle.dropdownStyle,
                                  //     value: questions[index].questionType,
                                  //     hint: const Text('Select Question Type'),
                                  //     items: const [
                                  //       DropdownMenuItem(
                                  //         value: 'multiple-choice',
                                  //         child: Text('Multiple Choice'),
                                  //       ),
                                  //       DropdownMenuItem(
                                  //         value: 'open-ended',
                                  //         child: Text('Open Ended'),
                                  //       ),
                                  //     ],
                                  //     onChanged: (value) => _onQuestionTypeChanged(value as String, index),
                                  //   ),
                                  // ),

                                  // Question Type Selector option
                                  Padding(
                                    padding: EdgeInsetsDirectional.all(
                                        _sizeInfo.innerSpacing / 2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Question Type',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IntrinsicWidth(
                                              child: RadioListTile<String>(
                                                title: const Text(
                                                    'Multiple Choice'),
                                                value: 'multiple-choice',
                                                groupValue: questions[index]
                                                    .questionType,
                                                onChanged: (value) =>
                                                    _onQuestionTypeChanged(
                                                        value, index),
                                                contentPadding: EdgeInsets.zero,
                                                dense: true,
                                              ),
                                            ),
                                            IntrinsicWidth(
                                              child: RadioListTile<String>(
                                                title: const Text('Open Ended'),
                                                value: 'open-ended',
                                                groupValue: questions[index]
                                                    .questionType,
                                                onChanged: (value) =>
                                                    _onQuestionTypeChanged(
                                                        value, index),
                                                contentPadding: EdgeInsets.zero,
                                                dense: true,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Options
                                  // Column(
                                  //   children:
                                  //       questions[index].options.map((option) {
                                  //     int optionIndex = questions[index]
                                  //         .options
                                  //         .indexOf(option);
                                  //     return Padding(
                                  //       padding: EdgeInsetsDirectional.all(
                                  //           _sizeInfo.innerSpacing / 2),
                                  //       child: TextFieldLabelWrapper(
                                  //         labelText:
                                  //             'Option ${optionIndex + 1}',
                                  //         inputField: TextFormField(
                                  //           decoration: InputDecoration(
                                  //               labelText:
                                  //                   'Enter Option ${optionIndex + 1}'),
                                  //           onChanged: (value) {
                                  //             questions[index]
                                  //                 .options[optionIndex]
                                  //                 .optionText = value;
                                  //           },
                                  //         ),
                                  //       ),
                                  //     );
                                  //   }).toList(),
                                  // ),

                                  // GridView.builder(
                                  //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  //     crossAxisCount: 2, // 2 options per row
                                  //     childAspectRatio: 6, // Adjust the aspect ratio as needed
                                  //   ),
                                  //   shrinkWrap: true,
                                  //   physics: const NeverScrollableScrollPhysics(),
                                  //   itemCount: questions[index].options.length,
                                  //   itemBuilder: (context, optionIndex) {
                                  //     return Padding(
                                  //       padding: EdgeInsetsDirectional.all(
                                  //           _sizeInfo.innerSpacing / 2),
                                  //       child: TextFieldLabelWrapper(
                                  //         labelText:
                                  //             'Option ${optionIndex + 1}',
                                  //         inputField: TextFormField(
                                  //           decoration: InputDecoration(
                                  //               labelText:
                                  //                   'Enter Option ${optionIndex + 1}'),
                                  //           onChanged: (value) {
                                  //             questions[index]
                                  //                 .options[optionIndex]
                                  //                 .optionText = value;
                                  //           },
                                  //         ),
                                  //       ),
                                  //     );
                                  //   },
                                  // ),

                                  // Conditional rendering based on question type
                                  if (questions[index].questionType ==
                                      'multiple-choice') ...[
                                    // Options Grid
                                    // GridView.builder(
                                    //   gridDelegate:
                                    //       const SliverGridDelegateWithFixedCrossAxisCount(
                                    //     crossAxisCount: 2,
                                    //     childAspectRatio: 6,
                                    //   ),
                                    //   shrinkWrap: true,
                                    //   physics:
                                    //       const NeverScrollableScrollPhysics(),
                                    //   itemCount:
                                    //       questions[index].options.length,
                                    //   itemBuilder: (context, optionIndex) {
                                    //     return Padding(
                                    //       padding: EdgeInsetsDirectional.all(
                                    //           _sizeInfo.innerSpacing / 2),
                                    //       child: TextFieldLabelWrapper(
                                    //         labelText:
                                    //             'Option ${optionIndex + 1}',
                                    //         inputField: TextFormField(
                                    //           decoration: InputDecoration(
                                    //               labelText:
                                    //                   'Enter Option ${optionIndex + 1}'),
                                    //           onChanged: (value) {
                                    //             questions[index]
                                    //                 .options[optionIndex]
                                    //                 .optionText = value;
                                    //           },
                                    //         ),
                                    //       ),
                                    //     );
                                    //   },
                                    // ),

// In the multiple-choice options section:
                                    GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 6,
                                      ),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          questions[index].options.length,
                                      itemBuilder: (context, optionIndex) {
                                        return Padding(
                                          padding: EdgeInsetsDirectional.all(
                                              _sizeInfo.innerSpacing / 2),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextFieldLabelWrapper(
                                                  labelText:
                                                      'Option ${optionIndex + 1}',
                                                  inputField: TextFormField(
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Enter Option ${optionIndex + 1}',
                                                      // suffixIcon: IconButton(
                                                      //   icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                                      //   onPressed: () => _removeOption(index, optionIndex),
                                                      // ),
                                                    ),
                                                    onChanged: (value) {
                                                      questions[index]
                                                          .options[optionIndex]
                                                          .optionText = value;
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Checkbox(
                                                    value: questions[index]
                                                        .options[optionIndex]
                                                        .isCorrect,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        questions[index]
                                                                .options[
                                                                    optionIndex]
                                                                .isCorrect =
                                                            value ?? false;
                                                        if (value == true) {
                                                          questions[index]
                                                                  .correctMultipleChoiceAnswer =
                                                              questions[index]
                                                                  .options[
                                                                      optionIndex]
                                                                  .optionText;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    'Correct',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),

                                    // Add Option Button
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () => _addOption(index),
                                          label: const Text('Add Option'),
                                          icon: const Icon(
                                            Icons.add_circle_outline_outlined,
                                            color: AcnooAppColors.kWhiteColor,
                                            size: 20.0,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.fromLTRB(
                                                14, 8, 14, 8),
                                            backgroundColor: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ] else if (questions[index].questionType ==
                                      'open-ended') ...[
                                    // Open Ended Answer Field
                                    Padding(
                                      padding: EdgeInsetsDirectional.all(
                                          _sizeInfo.innerSpacing / 2),
                                      child: TextFieldLabelWrapper(
                                        labelText: 'Correct Answer',
                                        inputField: TextFormField(
                                          decoration: const InputDecoration(
                                              hintText:
                                                  'Enter the correct answer'),
                                          onChanged: (value) {
                                            questions[index]
                                                .correctOpenEndedAnswer = value;
                                            questions[index].answer = value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],

                                  // Add Option Button
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.end,
                                  //   children: [
                                  //     ElevatedButton.icon(
                                  //       onPressed: () => _addOption(index),
                                  //       label: const Text('Add Option'),
                                  //       icon: const Icon(
                                  //         Icons.add_circle_outline_outlined,
                                  //         color: AcnooAppColors.kWhiteColor,
                                  //         size: 20.0,
                                  //       ),
                                  //       style: ElevatedButton.styleFrom(
                                  //         padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                                  //         backgroundColor: Colors.blue,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Add Question Button
                  ResponsiveGridCol(
                    lg: 12,
                    md: 12,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              _addQuestion();
                            },
                            label: const Text('Add Question'),
                            icon: const Icon(
                              Icons.add_circle_outline_outlined,
                              color: AcnooAppColors.kWhiteColor,
                              size: 20.0,
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                            ),
                          ),
                        ],
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
                    final examTitle =
                        _examTitleController.text; // Get the exam title
                    final examDescription = _examDescriptionController
                        .text; // Get the exam description
                    // final classId = _classId; // Get the selected class
                    // final subjectId = _subjectId; // Get the selected subject
                    //final duration = _durationController.text; // Get the selected duration
                    //final numberOfQuestions = _numberOfQuestionsController.text; // Get the selected number of questions
                    //final questions = this.questions; // Get the selected questions

                    _createExam(examTitle, examDescription);
                  }
                },
                child: const Text('Create Exam'),
              ),
            ),
          ],
        ),
      ),
    );
  }

// add question button
  // ElevatedButton addQuestionButton() {
  //   return ElevatedButton.icon(
  //     style: ElevatedButton.styleFrom(
  //       padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
  //     ),
  //     onPressed: () {
  //       setState(() {
  //         _addQuestion();
  //       });
  //     },
  //     label: Text(
  //       'Add Question',
  //       style: textTheme.bodySmall?.copyWith(
  //         color: AcnooAppColors.kWhiteColor,
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //     iconAlignment: IconAlignment.start,
  //     icon: const Icon(
  //       Icons.add_circle_outline_outlined,
  //       color: AcnooAppColors.kWhiteColor,
  //       size: 20.0,
  //     ),
  //   );
  // }
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
