// assignment list view

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:go_router/go_router.dart';
import '../../core/theme/_app_colors.dart';
import '../../widgets/widgets.dart';

class AssignmentListView extends StatefulWidget {
  const AssignmentListView({super.key});

  @override
  State<AssignmentListView> createState() => _AssignmentListViewState();
}

class _AssignmentListViewState extends State<AssignmentListView> {
  bool _isLoading = true;
  String _searchQuery = '';
  List<Map<String, dynamic>> _assignments = [];

  @override
  void initState() {
    super.initState();
    _fetchAssignments();
  }

  Future<void> _fetchAssignments() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _assignments = [
        {
          'id': '1',
          'title': 'Mathematics Assignment 1',
          'description': 'Complete exercises from Chapter 3: Algebra',
          'dueDate': '2024-04-15',
          'points': 100,
          'subject': 'Mathematics',
          'class': 'Class X',
        },
        {
          'id': '2',
          'title': 'Science Project',
          'description': 'Research and present on renewable energy sources',
          'dueDate': '2024-04-20',
          'points': 150,
          'subject': 'Science',
          'class': 'Class XI',
        },
        // Add more dummy assignments...
      ];
      _isLoading = false;
    });
  }

  void _setSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<Map<String, dynamic>> get _filteredAssignments {
    if (_searchQuery.isEmpty) return _assignments;
    
    final query = _searchQuery.toLowerCase();
    return _assignments.where((assignment) {
      return assignment['title'].toString().toLowerCase().contains(query) ||
          assignment['description'].toString().toLowerCase().contains(query) ||
          assignment['subject'].toString().toLowerCase().contains(query) ||
          assignment['class'].toString().toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Padding(
        padding: _sizeInfo.padding,
        child: ShadowContainer(
          showHeader: false,
          contentPadding: EdgeInsets.zero,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 481;
                final isTablet = constraints.maxWidth < 992 && constraints.maxWidth >= 481;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isMobile
                        ? Padding(
                            padding: _sizeInfo.padding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Spacer(),
                                    _addAssignmentButton(textTheme),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                _searchFormField(textTheme: textTheme),
                              ],
                            ),
                          )
                        : Padding(
                            padding: _sizeInfo.padding,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: _searchFormField(textTheme: textTheme),
                                ),
                                Spacer(flex: isTablet || isMobile ? 1 : 2),
                                _addAssignmentButton(textTheme),
                              ],
                            ),
                          ),
                    Padding(
                      padding: _sizeInfo.padding,
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _filteredAssignments.isEmpty
                              ? Center(
                                  child: Text(
                                    'No assignments found',
                                    style: textTheme.titleMedium?.copyWith(
                                      color: AcnooAppColors.kDark3,
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isMobile ? 1 : isTablet ? 2 : 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 3,
                                  ),
                                  itemCount: _filteredAssignments.length,
                                  itemBuilder: (context, index) {
                                    final assignment = _filteredAssignments[index];
                                    return AssignmentCard(
                                      assignment: assignment,
                                      onEdit: () => context.go('/dashboard/assignments/edit-assignment/${assignment['id']}'),
                                      onDelete: () {/* Implement delete functionality */},
                                    );
                                  },
                                ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _addAssignmentButton(TextTheme textTheme) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () => context.go('/dashboard/assignments/add-assignment'),
      label: Text(
        'Add Assignment',
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
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Search assignments...',
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

class AssignmentCard extends StatelessWidget {
  final Map<String, dynamic> assignment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AcnooAppColors.kWhiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: AcnooAppColors.kPrimary100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.assignment, size: 30, color: AcnooAppColors.kPrimary700),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assignment['title'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Due: ${assignment['dueDate']} - ${assignment['points']} points',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AcnooAppColors.kPrimary700,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${assignment['subject']} | ${assignment['class']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AcnooAppColors.kDark3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: AcnooAppColors.kInfo),
                  onPressed: onEdit,
                  tooltip: 'Edit Assignment',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AcnooAppColors.kError),
                  onPressed: onDelete,
                  tooltip: 'Delete Assignment',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




