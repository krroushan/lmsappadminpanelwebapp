// 🎯 Dart imports:

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../core/theme/_app_colors.dart';
import '../../widgets/widgets.dart';
import '../../core/api_service/subject_service.dart';
import '../../models/subject/subject.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import '../../core/api_config/api_config.dart';

class SubjectListView extends StatefulWidget {
  const SubjectListView({super.key});

  @override
  State<SubjectListView> createState() => _SubjectListViewState();
} 

class _SubjectListViewState extends State<SubjectListView> {
  List<Subject> _subjects = [];
  int _totalSubjects = 0;

  bool _isLoading = true;
  final SubjectService _subjectService = SubjectService();

  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';

  String token = '';

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchSubjects();
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
          title: const Text('Delete Subject'),
          content: const Text('Do you want to delete this subject?'),
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

  Future<void> _deleteSubject(String subjectId, String token) async {
    // Show confirmation dialog before deleting
    bool? confirmDelete = await _showDeleteConfirmationDialog();
    if (confirmDelete == true) {
      try {

        await _subjectService.deleteSubject(subjectId, token);
        // Optionally, refresh the class list after deletion
        await _fetchSubjects();
      } catch (e) {
        // Handle error appropriately
        print('Error deleting subject: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete class: $e')),
        );
      }
    }
  }

  // New method to fetch Class data from the API
  Future<void> _fetchSubjects() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Subject> response = await _subjectService.fetchAllSubjects(token); // Fetch the response
      logger.d('response: ${response}');
      setState(() {
        _subjects = response;
        _totalSubjects = response.length;
        _isLoading = false;
      });
      
      print("asubject: ${_subjects.length}");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
      throw Exception('Failed to load Subjects');
    }
  }

  ///_____________________________________________________________________Search_query_________________________
  void _setSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
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

    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: _sizeInfo.padding,
        child: ShadowContainer(
          showHeader: false,
          contentPadding: EdgeInsets.zero,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final isMobile = constraints.maxWidth < 481;
                final isTablet =
                    constraints.maxWidth < 992 && constraints.maxWidth >= 481;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //______________________________________________________________________Header__________________
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
                                    addUserButton(textTheme),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                searchFormField(textTheme: textTheme),
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
                                  child: searchFormField(textTheme: textTheme),
                                ),
                                Spacer(flex: isTablet || isMobile ? 1 : 2),
                                addUserButton(textTheme),
                              ],
                            ),
                          ),

                    //______________________________________________________________________Data_table__________________
                    Padding(
                      padding: _sizeInfo.padding,
                      child: _isLoading 
                        ? const Center(child: CircularProgressIndicator())
                        : _subjects.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.book_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No subjects found',
                                    style: textTheme.titleMedium?.copyWith(color: Colors.grey),
                                  ),
                                ],
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
                              itemCount: _subjects.length,
                              itemBuilder: (context, index) {
                                final subject = _subjects[index];
                                return SubjectCard(
                                  subject: subject,
                                  onEdit: () => context.go('/dashboard/subjects/edit-subject/${subject.id}'),
                                  onDelete: () => _deleteSubject(subject.id, token),
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

  ElevatedButton addUserButton(TextTheme textTheme) {
    final lang = l.S.of(context);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        setState(() {
          //_showFormDialog(context);
          context.go('/dashboard/subjects/add-subject');
        });
      },
      label: Text(
        'Add New Subject',
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


  ///_______________________________________________________________Search_Field___________________________________
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

  ///_______________________________________________________________User_List_Data_Table___________________________
  Widget userListDataTable(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    if (_subjects.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'No subjects found',
            style: textTheme.titleMedium,
          ),
        ),
      );
    }

    return Theme(
      data: ThemeData(
        dividerColor: theme.colorScheme.outline,
        dividerTheme: DividerThemeData(
          color: theme.colorScheme.outline,
        )
      ),
      child: DataTable(
        checkboxHorizontalMargin: 16,
        dataRowMaxHeight: 70,
        headingTextStyle: textTheme.titleMedium,
        dataTextStyle: textTheme.bodySmall,
        headingRowColor: WidgetStateProperty.all(theme.colorScheme.surface),
        showBottomBorder: true,
        columns: const [
          DataColumn(label: Text('SN.')),
          DataColumn(label: Text('Image')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Class')),
          // DataColumn(label: Text('Description')),
          DataColumn(label: Text('Action')),
        ],
        rows: _subjects.asMap().entries.map(
          (entry) {
            final index = entry.key + 1;
            final subject = entry.value;
            return DataRow(
              cells: [
                DataCell(Text(index.toString())),
                DataCell(
                  ClipOval(
                    child: Image.network(
                      '${ApiConfig.subjectImageUrl}${subject.subjectImage}', 
                      width: 50, 
                      height: 50, 
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                DataCell(Text(subject.name)),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: true
                          ? AcnooAppColors.kSuccess.withOpacity(0.2)
                          : AcnooAppColors.kError.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text(
                      subject.classInfo.name ?? 'No Class',
                      style: textTheme.bodySmall?.copyWith(
                          color: true
                              ? AcnooAppColors.kSuccess
                              : AcnooAppColors.kError),
                    ),
                  ),
                ),
                // DataCell(Text(subjectInfo.description)),
                DataCell(
                  Row(
                    children: [
                      // IconButton(onPressed: () {
                      //   context.go('/dashboard/subjects/view-subject/${subject.id}');
                      // }, icon: const Icon(Icons.visibility, color: AcnooAppColors.kDark3,)),
                      IconButton(onPressed: () {
                        context.go('/dashboard/subjects/edit-subject/${subject.id}');
                      }, icon: const Icon(Icons.edit, color: AcnooAppColors.kInfo,)),

                      IconButton(onPressed: () async {
                        await _deleteSubject(subject.id, token);
                      }, icon: const Icon(Icons.delete, color: AcnooAppColors.kError,)),
                    ],
                  ),
                ),
              ],
            );
          },
        ).toList(),
      ),
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

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SubjectCard({
    super.key,
    required this.subject,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                '${ApiConfig.subjectImageUrl}${subject.subjectImage}',
                height: double.infinity,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: double.infinity,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AcnooAppColors.kPrimary100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.image_not_supported, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AcnooAppColors.kSuccess.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      subject.classInfo.name ?? 'No Class',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AcnooAppColors.kSuccess,
                      ),
                    ),
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
                  tooltip: 'Edit Subject',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AcnooAppColors.kError),
                  onPressed: onDelete,
                  tooltip: 'Delete Subject',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
