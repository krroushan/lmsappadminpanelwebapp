// 🎯 Dart imports:

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:go_router/go_router.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../core/theme/_app_colors.dart';
import '../../models/exam/get_exam.dart';
import '../../widgets/card_widgets/_exam_card.dart';
import '../../widgets/widgets.dart';
import '../../core/api_service/exam_service.dart';
import '../../models/exam/exam.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';

class ExamListView extends StatefulWidget {
  const ExamListView({super.key});

  @override
  State<ExamListView> createState() => _ExamListViewState();
}

class _ExamListViewState extends State<ExamListView> {
  List<GetExam> _exams = [];
  int _totalExams = 0;

  bool _isLoading = true;
  final ExamService _examService = ExamService();

  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchExams();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool?> _showDeleteConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Exam'),
          content: const Text('Do you want to delete this exam?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteExam(String examId) async {
    // Show confirmation dialog before deleting
    bool? confirmDelete = await _showDeleteConfirmationDialog();
    if (confirmDelete == true) {
      try {
        await _examService.deleteExam(examId, token);
        // Optionally, refresh the class list after deletion
        await _fetchExams();
      } catch (e) {
        // Handle error appropriately
        print('Error deleting exam: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete exam: $e')),
        );
      }
    }
  }

  // Updated fetch method to use getAllExams
  Future<void> _fetchExams() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<GetExam> response = await _examService.getAllExams(token);
      setState(() {
        _exams = response;
        _totalExams = response.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load exams: $e')),
      );
    }
  }

  // Search Query
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
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
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
      body: ListView(
        shrinkWrap: true,
        addAutomaticKeepAlives: false,
        padding: _sizeInfo.padding / 2.5,
        children: [
          // Header with Title and Add Button
          Padding(
            padding: EdgeInsets.fromLTRB(
              (_sizeInfo.padding.horizontal / 2) / 2.5,
              16,
              (_sizeInfo.padding.horizontal / 2) / 2.5,
              0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Exams',
                  style: _theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                addUserButton(_theme.textTheme),
              ],
            ),
          ),

          // Search Field
          Padding(
            padding: _sizeInfo.padding / 2.5,
            child: searchFormField(textTheme: _theme.textTheme),
          ),

          // Exam Cards Grid
          ResponsiveGridRow(
            children: _isLoading 
              ? <ResponsiveGridCol>[
                  ResponsiveGridCol(
                    lg: 12,
                    md: 12,
                    sm: 12,
                    xs: 12,
                    child: Container(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: _theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ]
              : _exams.isEmpty
                  ? <ResponsiveGridCol>[
                      ResponsiveGridCol(
                        lg: 12,
                        md: 12,
                        sm: 12,
                        xs: 12,
                        child: Container(
                          height: 200,
                          child: Center(
                            child: Text(
                              'No exams found',
                              style: _theme.textTheme.titleMedium?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  : _exams.asMap().entries.map(
                      (entry) => ResponsiveGridCol(
                        lg: 3,
                        md: 4,
                        sm: 12,
                        xs: 12,
                        child: Padding(
                          padding: _sizeInfo.padding / 2.5,
                          child: ExamCard(
                            exam: entry.value,
                            onDelete: _deleteExam,
                            onEdit: (exam) {
                              context.go('/dashboard/exams/edit/${exam.id}');
                            },
                            onView: (examId) {
                              context.go('/dashboard/exams/exam-profile', extra: examId);
                            },
                            onAddQuestion: (examId) {
                                context.go('/dashboard/exams/add-question/$examId');
                            },
                          ),
                        ),
                      ),
                    ).toList(),
          ),
        ],
      ),
    );
  }

  ElevatedButton addUserButton(TextTheme textTheme) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        context.go('/dashboard/exams/add-exam');
      },
      label: Text(
        'Add New Exam',
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconAlignment: IconAlignment.start,
      icon: const Icon(
        Icons.add_circle_outline_outlined,
        color: AcnooAppColors.kWhiteColor,
        size: 20.0,
      ),
    );
  }

  // Search Field
  TextFormField searchFormField({required TextTheme textTheme}) {
    final lang = l.S.of(context);
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        // hintText: 'Search...',
        hintText: '${lang.search}...',
        hintStyle: textTheme.bodySmall,
        suffixIcon: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: AcnooAppColors.kPrimary700,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child:
              const Icon(IconlyLight.search, color: AcnooAppColors.kWhiteColor),
        ),
      ),
      onChanged: (value) {
        _setSearchQuery(value);
      },
    );
  }
}

// Size Info
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
