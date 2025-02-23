// Add Question to Exam View

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api_service/exam_service.dart';
import '../../providers/_auth_provider.dart';
import '../../widgets/widgets.dart';
import '../../models/exam/get_question.dart';
import 'package:logger/logger.dart';
import '../../core/api_service/question_service.dart';

class AddQuestionToExamView extends StatefulWidget {
  final String examId;

  const AddQuestionToExamView({
    super.key,
    required this.examId,
  });

  @override
  State<AddQuestionToExamView> createState() => _AddQuestionToExamViewState();
}

class _AddQuestionToExamViewState extends State<AddQuestionToExamView> {
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  Set<String> _selectedQuestions = {};

  var log = Logger();
  String token = '';
  String examTitle = '';
  String examSubject = '';
  String examClass = '';
  String examBoard = '';
  String examDuration = '';
  String examTotalMarks = '';
  String classId = '';
  String subjectId = '';
  String boardId = '';

  // Add QuestionService instance
  final QuestionService _questionService = QuestionService();
  List<GetQuestion> _questions = [];

  // Add ExamService instance
  final ExamService _examService = ExamService();

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    log.d('Exam ID: ${widget.examId}');
    _getExamDetails().then((_) => _fetchQuestions());
  }

  // Get exam details
  Future<void> _getExamDetails() async {
    setState(() => _isLoading = true);
    try {
      final exam = await ExamService.getExamById(widget.examId, token);
      log.d('Exam: $exam');
      
      examTitle = exam.title;
      examSubject = exam.subject.name;
      examClass = exam.classInfo.name;
      examBoard = exam.board.name;
      classId = exam.classInfo.id;
      subjectId = exam.subject.id;
      boardId = exam.board.id;

      // Pre-select questions if exam has existing questions
      if (exam.questions != null && exam.questions.isNotEmpty) {
        _selectedQuestions = exam.questions.map((q) => q.id).toSet();
      }
      
    } catch (e) {
      log.e('Error fetching exam details: $e');
      // Handle error (show snackbar, etc.)
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Update _paginatedQuestions getter
  List<GetQuestion> get _paginatedQuestions {
    // First, filter questions based on search query
    final searchTerm = _searchController.text.toLowerCase().trim();
    final filteredQuestions = searchTerm.isEmpty 
        ? _questions 
        : _questions.where((question) {
            return question.questionText.toLowerCase().contains(searchTerm) ||
                   question.subject.name.toLowerCase().contains(searchTerm) ||
                   question.classInfo.name.toLowerCase().contains(searchTerm) ||
                   question.board.name.toLowerCase().contains(searchTerm) ||
                   question.questionType.toLowerCase().contains(searchTerm);
          }).toList();

    // Then apply pagination
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    
    if (filteredQuestions.isEmpty) return [];
    
    return filteredQuestions.sublist(
      startIndex,
      endIndex > filteredQuestions.length ? filteredQuestions.length : endIndex,
    );
  }

  // Add method to fetch questions
  Future<void> _fetchQuestions() async {
    setState(() => _isLoading = true);
    try {
      final questions = await _questionService.getQuestionsByFilter(
        classId,
        subjectId,
        boardId,
        token
      );
      setState(() {
        _questions = questions;
      });
    } catch (e) {
      log.e('Error fetching questions: $e');
      // Handle error (show snackbar, etc.)
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Update pagination variables to match StudentListView style
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;  // Changed from 1 to 0 to match StudentListView
  int _rowsPerPage = 10;
  int _totalPages = 0;
  String _searchQuery = '';

  // Add navigation methods
  void _goToNextPage() {
    if (_currentPage < (_questions.length / _rowsPerPage).ceil() - 1) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  // Replace the existing pagination widget with this new one
  Widget paginatedSection(ThemeData theme, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Showing ${_currentPage * _rowsPerPage + 1} to ${_currentPage * _rowsPerPage + _paginatedQuestions.length} of ${_questions.length} entries',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTablePaginator(
          currentPage: _currentPage + 1,
          totalPages: (_questions.length / _rowsPerPage).ceil(),
          onPreviousTap: _goToPreviousPage,
          onNextTap: _goToNextPage,
        )
      ],
    );
  }

  // Add method to handle adding questions
  Future<void> _handleAddQuestions() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    try {
      await _examService.updateExamQuestions(
        widget.examId,
        _selectedQuestions.toList(),
        token,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Questions added successfully')),
        );
        // Check if we can pop before attempting to do so
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true); // Return true to indicate success
        }
      }
    } catch (e) {
      log.e('Error adding questions: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add questions: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ShadowContainer(
          headerText: 'Add Questions to $examTitle',
          contentPadding: EdgeInsets.zero,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Chip(
                            label: Text(
                              examClass,
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: Colors.orange.withOpacity(0.1),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            visualDensity: VisualDensity.compact,
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(
                              examSubject,
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: Colors.green.withOpacity(0.1),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            visualDensity: VisualDensity.compact,
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(
                              examBoard,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: _selectedQuestions.isEmpty ? null : _handleAddQuestions,
                        icon: _isLoading 
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.add),
                        label: Text(_isLoading 
                          ? 'Adding...' 
                          : 'Add ${_selectedQuestions.length} Questions'),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search questions...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 16),
                      PopupMenuButton<String>(
                        child: Chip(
                          label: const Text('Filters'),
                          deleteIcon: const Icon(Icons.arrow_drop_down),
                          onDeleted: () {},
                        ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'multiple-choice',
                            child: Text('Multiple Choice'),
                          ),
                          const PopupMenuItem(
                            value: 'open-ended',
                            child: Text('Open Ended'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Questions List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: _paginatedQuestions.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final question = _paginatedQuestions[index];
                        final isSelected = _selectedQuestions.contains(question.id);

                        return Card(
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected 
                                  ? theme.primaryColor 
                                  : Colors.grey.shade200,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: isSelected,
                                      onChanged: (value) {
                                        setState(() {
                                          if (value ?? false) {
                                            _selectedQuestions.add(question.id);
                                          } else {
                                            _selectedQuestions.remove(question.id);
                                          }
                                        });
                                      },
                                    ),
                                    Expanded(
                                      child: Text(
                                        question.questionText,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.visibility_outlined),
                                      onPressed: () => _showQuestionDetails(context, question),
                                      tooltip: 'View Details',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    Chip(
                                      label: Text(
                                        question.questionType,
                                        style: TextStyle(
                                          color: theme.primaryColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                      backgroundColor: theme.primaryColor.withOpacity(0.1),
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                   
                                    
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Pagination
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: paginatedSection(theme, theme.textTheme),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showQuestionDetails(BuildContext context, GetQuestion question) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question Details',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text('Question: ${question.questionText}'),
              const SizedBox(height: 8),
              Text('Type: ${question.questionType}'),
              const SizedBox(height: 8),
              Text('Subject: ${question.subject.name}'),
              const SizedBox(height: 8),
              Text('Class: ${question.classInfo.name}'),
              const SizedBox(height: 8),
              Text('Board: ${question.board.name}'),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();  // Add scrollController disposal
    _searchController.dispose();
    super.dispose();
  }
}


