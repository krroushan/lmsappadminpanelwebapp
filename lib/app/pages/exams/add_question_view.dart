// Add Question View

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../core/api_service/board_service.dart';
import '../../core/api_service/class_service.dart';
import '../../core/api_service/question_service.dart';
import '../../core/api_service/subject_service.dart';
import '../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../models/board/board.dart';
import '../../models/classes/class_info.dart';
import '../../models/exam/option.dart';
import '../../models/exam/question.dart';
import '../../models/subject/subject.dart';
import '../../providers/_auth_provider.dart';
import '../../widgets/shadow_container/_shadow_container.dart';
import '../../widgets/textfield_wrapper/_textfield_wrapper.dart';

class AddQuestionView extends StatefulWidget {
  const AddQuestionView({super.key});

  @override
  State<AddQuestionView> createState() => _AddQuestionViewState();
}


class _AddQuestionViewState extends State<AddQuestionView> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String token = '';

  // Controllers
  final TextEditingController questionTextController = TextEditingController();
  final TextEditingController correctOpenEndedAnswerController = TextEditingController();
  
  // Selected values
  String _questionType = 'multiple-choice';
  String _classId = "";
  String _subjectId = "";
  String _boardId = "";
  
  // Options list
  List<Map<String, dynamic>> options = [
    {'optionText': '', 'isCorrect': false}
  ];

  // Services and data lists (similar to AddExamView)
  final _classService = ClassService();
  final _subjectService = SubjectService();
  final _boardService = BoardService();
  List<ClassInfo> _classList = [];
  List<Subject> _subjectList = [];
  List<Board> _boardList = [];

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchData();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // create question
  Future<void> _createQuestion() async {
    if (_questionType == 'multiple-choice') {
      if (options.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one option')),
        );
        return;
      }
      
      if (!options.any((option) => option['isCorrect'] == true)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one correct answer')),
        );
        return;
      }
    }

    setState(() => _isLoading = true);
    try {
      final questionService = QuestionService();
      final question = Question(
        questionText: questionTextController.text,
        questionType: _questionType,
        options: _questionType == 'multiple-choice' 
            ? options.map((option) => Option(
                optionText: option['optionText'],
                isCorrect: option['isCorrect']
              )).toList()
            : [],
        classId: _classId,
        subjectId: _subjectId,
        boardId: _boardId,
        correctOpenEndedAnswer: _questionType == 'open-ended' 
            ? correctOpenEndedAnswerController.text 
            : null,
      );

      await questionService.createQuestion(question, token);
      
      // Clear form fields but maintain class, subject, and board selections
      _resetForm();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Question created successfully. You can add another question.')),
      );
    } catch (e) {
      print('Error creating question: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating question: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _resetForm() {
    questionTextController.clear();
    correctOpenEndedAnswerController.clear();
    setState(() {
      _questionType = 'multiple-choice';
      options = [{'optionText': '', 'isCorrect': false}];
      // Note: Not clearing _classId, _subjectId, _boardId to maintain selection
    });
  }

  @override
  Widget build(BuildContext context) {
    const _lg = 4;
    const _md = 6;
    final _dropdownStyle = AcnooDropdownStyle(context);

    return Scaffold(
      body: _isLoading && _classList.isEmpty 
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Form(
                  key: formKey,
                  child: ShadowContainer(
                    headerText: 'Add Question',
                    child: ResponsiveGridRow(
                      children: [
                        // Class Dropdown
                        ResponsiveGridCol(
                          lg: _lg,
                          md: _md,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: TextFieldLabelWrapper(
                              labelText: 'Class',
                              inputField: DropdownButtonFormField2(
                                menuItemStyleData: _dropdownStyle.menuItemStyle,
                                buttonStyleData: _dropdownStyle.buttonStyle,
                                iconStyleData: _dropdownStyle.iconStyle,
                                dropdownStyleData: _dropdownStyle.dropdownStyle,
                                value: _classId.isEmpty ? null : _classId,
                                hint: const Text('Select Class'),
                                items: _classList.map((ClassInfo classInfo) {
                                  return DropdownMenuItem(
                                    value: classInfo.id,
                                    child: Text(classInfo.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() => _classId = value.toString());
                                },
                                validator: (value) => value == null ? 'Please select a class' : null,
                              ),
                            ),
                          ),
                        ),

                        // Subject Dropdown
                        ResponsiveGridCol(
                          lg: _lg,
                          md: _md,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: TextFieldLabelWrapper(
                              labelText: 'Subject',
                              inputField: DropdownButtonFormField2(
                                menuItemStyleData: _dropdownStyle.menuItemStyle,
                                buttonStyleData: _dropdownStyle.buttonStyle,
                                iconStyleData: _dropdownStyle.iconStyle,
                                dropdownStyleData: _dropdownStyle.dropdownStyle,
                                value: _subjectId.isEmpty ? null : _subjectId,
                                hint: const Text('Select Subject'),
                                items: _subjectList.map((Subject subject) {
                                  return DropdownMenuItem(
                                    value: subject.id,
                                    child: Text(subject.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() => _subjectId = value.toString());
                                },
                                validator: (value) => value == null ? 'Please select a subject' : null,
                              ),
                            ),
                          ),
                        ),

                        // Board Dropdown
                        ResponsiveGridCol(
                          lg: _lg,
                          md: _md,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: TextFieldLabelWrapper(
                              labelText: 'Board',
                              inputField: DropdownButtonFormField2(
                                menuItemStyleData: _dropdownStyle.menuItemStyle,
                                buttonStyleData: _dropdownStyle.buttonStyle,
                                iconStyleData: _dropdownStyle.iconStyle,
                                dropdownStyleData: _dropdownStyle.dropdownStyle,
                                value: _boardId.isEmpty ? null : _boardId,
                                hint: const Text('Select Board'),
                                items: _boardList.map((Board board) {
                                  return DropdownMenuItem(
                                    value: board.id,
                                    child: Text(board.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() => _boardId = value.toString());
                                },
                                validator: (value) => value == null ? 'Please select a board' : null,
                              ),
                            ),
                          ),
                        ),

                        // Question Text
                        ResponsiveGridCol(
                          lg: 12,
                          md: 12,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: TextFieldLabelWrapper(
                              labelText: 'Question Text',
                              inputField: TextFormField(
                                controller: questionTextController,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  hintText: 'Enter question text',
                                ),
                                validator: (value) => value?.isEmpty ?? true 
                                    ? 'Please enter question text' 
                                    : null,
                              ),
                            ),
                          ),
                        ),

                        // Question Type
                        ResponsiveGridCol(
                          lg: _lg,
                          md: _md,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: TextFieldLabelWrapper(
                              labelText: 'Question Type',
                              inputField: DropdownButtonFormField2(
                                menuItemStyleData: _dropdownStyle.menuItemStyle,
                                buttonStyleData: _dropdownStyle.buttonStyle,
                                iconStyleData: _dropdownStyle.iconStyle,
                                dropdownStyleData: _dropdownStyle.dropdownStyle,
                                value: _questionType,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'multiple-choice',
                                    child: Text('Multiple Choice'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'open-ended',
                                    child: Text('Open Ended'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() => _questionType = value.toString());
                                },
                              ),
                            ),
                          ),
                        ),

                        // Dynamic Options or Open Ended Answer based on question type
                        if (_questionType == 'multiple-choice') ...[
                          ResponsiveGridCol(
                            lg: 12,
                            md: 12,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Options', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  ...List.generate(
                                    options.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: 'Option ${index + 1}',
                                              ),
                                              onChanged: (value) {
                                                options[index]['optionText'] = value;
                                              },
                                              validator: (value) => value?.isEmpty ?? true 
                                                  ? 'Please enter option text' 
                                                  : null,
                                            ),
                                          ),
                                          Checkbox(
                                            value: options[index]['isCorrect'],
                                            onChanged: (value) {
                                              setState(() {
                                                options[index]['isCorrect'] = value;
                                              });
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.remove_circle),
                                            onPressed: () {
                                              if (options.length > 1) {
                                                setState(() {
                                                  options.removeAt(index);
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        options.add({'optionText': '', 'isCorrect': false});
                                      });
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add Option'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ] else ...[
                          ResponsiveGridCol(
                            lg: 12,
                            md: 12,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: TextFieldLabelWrapper(
                                labelText: 'Correct Answer',
                                inputField: TextFormField(
                                  controller: correctOpenEndedAnswerController,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter correct answer',
                                  ),
                                  validator: (value) => value?.isEmpty ?? true 
                                      ? 'Please enter correct answer' 
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ],

                        // Submit Button
                        ResponsiveGridCol(
                          lg: 12,
                          md: 12,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : () {
                                if (formKey.currentState!.validate()) {
                                  _createQuestion();
                                }
                              },
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text('Create Question'),
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
    questionTextController.dispose();
    correctOpenEndedAnswerController.dispose();
    super.dispose();
  }
}