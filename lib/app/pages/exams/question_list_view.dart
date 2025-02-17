// question list view

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart' as l;
import '../../core/theme/_app_colors.dart';
import '../../models/exam/question.dart';
import '../../models/exam/get_question.dart';
import '../../core/api_service/question_service.dart';
import '../../providers/_auth_provider.dart';

class QuestionListView extends StatefulWidget {
  const QuestionListView({super.key});

  @override
  State<QuestionListView> createState() => _QuestionListViewState();
}

class _QuestionListViewState extends State<QuestionListView> {
  List<GetQuestion> _questions = [];
  bool _isLoading = true;
  final QuestionService _questionService = QuestionService();
  String _searchQuery = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<GetQuestion> response = await _questionService.getAllQuestions(token);
      setState(() {
        _questions = response;
        _isLoading = false;
      });
      print('Questions: ${_questions}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Questions loaded successfully')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load questions: $e')),
      );
    }
  }

  void _setSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetchQuestions,
        child: ListView(
          shrinkWrap: true,
          padding: _sizeInfo.padding / 2.5,
          children: [
            // Header with Title and Add Button
            Padding(
              padding: EdgeInsets.fromLTRB(
                (_sizeInfo.padding.horizontal / 2) / 2.5,
                16,
                (_sizeInfo.padding.horizontal / 2) / 2.5,
                16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Questions',
                    style: _theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _theme.primaryColor,
                    ),
                  ),
                  _addQuestionButton(_theme.textTheme),
                ],
              ),
            ),

            // Search Field
            Padding(
              padding: _sizeInfo.padding / 2.5,
              child: _searchFormField(textTheme: _theme.textTheme),
            ),

            // Question Cards
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_questions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(Icons.question_mark, size: 48, color: _theme.primaryColor),
                      const SizedBox(height: 16),
                      Text(
                        'No questions found',
                        style: _theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              )
            else
              ..._filteredQuestions.map((question) => _buildQuestionCard(
                    question,
                    _theme,
                    _sizeInfo,
                  )),
          ],
        ),
      ),
    );
  }

  List<GetQuestion> get _filteredQuestions {
    if (_searchQuery.isEmpty) return _questions;
    return _questions.where((question) {
      return question.questionText.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          question.board.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          question.subject.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          question.classInfo.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Widget _buildQuestionCard(GetQuestion question, ThemeData theme, _SizeInfo sizeInfo) {
    return Card(
      elevation: 2,
      margin: sizeInfo.padding / 2.5,
      color: AcnooAppColors.kWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showQuestionDetails(question);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.questionText,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildInfoChip(
                          label: question.questionType,
                          color: Colors.deepOrange,
                        ),
                        _buildInfoChip(
                          label: question.board.name,
                          color: theme.primaryColor,
                        ),
                        _buildInfoChip(
                          label: question.subject.name,
                          color: Colors.teal,
                        ),
                        _buildInfoChip(
                          label: question.classInfo.name,
                          color: Colors.indigo,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.visibility, color: theme.primaryColor, size: 20),
                      onPressed: () => _showQuestionDetails(question),
                      tooltip: 'View',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.green, size: 20),
                      onPressed: () {
                        // Handle edit
                      },
                      tooltip: 'Edit',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () {
                        // Handle delete
                      },
                      tooltip: 'Delete',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuestionDetails(GetQuestion question) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _detailRow('Question Text:', question.questionText),
              _detailRow('Question Type:', question.questionType),
              _detailRow('Board:', question.board.name),
              _detailRow('Subject:', question.subject.name),
              _detailRow('Class:', question.classInfo.name),
              // _detailRow('Marks:', question..toString()),
              // _detailRow('Difficulty Level:', question.difficultyLevel),
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

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required String label, required Color color}) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  ElevatedButton _addQuestionButton(TextTheme textTheme) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        context.go('/dashboard/questions/add-question');
      },
      label: Text(
        'Add New Question',
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      icon: const Icon(
        Icons.add_circle_outline_outlined,
        color: AcnooAppColors.kWhiteColor,
        size: 20.0,
      ),
    );
  }

  TextFormField _searchFormField({required TextTheme textTheme}) {
    final lang = l.S.of(context);
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        hintText: '${lang.search}...',
        hintStyle: textTheme.bodySmall,
        suffixIcon: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: AcnooAppColors.kPrimary700,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: const Icon(IconlyLight.search, color: AcnooAppColors.kWhiteColor),
        ),
      ),
      onChanged: _setSearchQuery,
    );
  }
}

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}