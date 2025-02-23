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
import '../../core/api_service/teacher_service.dart';
import '../../models/teacher/teacher.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';

class TeacherListView extends StatefulWidget {
  const TeacherListView({super.key});

  @override
  State<TeacherListView> createState() => _TeacherListViewState();
}

class _TeacherListViewState extends State<TeacherListView> {
  List<Teacher> _teachers = [];
  int _totalTeachers = 0;

  bool _isLoading = true;
  final TeacherService _teacherService = TeacherService();

  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchTeachers();
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
          title: const Text('Delete Teacher'),
          content: const Text('Do you want to delete this teacher?'),
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

  Future<void> _deleteTeacher(String teacherId) async {
    // Show confirmation dialog before deleting
    bool? confirmDelete = await _showDeleteConfirmationDialog();
    if (confirmDelete == true) {
      try {
        await _teacherService.deleteTeacher(teacherId, token);
        // Optionally, refresh the class list after deletion
        //await _fetchTeachers();
      } catch (e) {
        // Handle error appropriately
        print('Error deleting class: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete class: $e')),
        );
      }
    }
  }

  // New method to fetch Class data from the API
  Future<void> _fetchTeachers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Teacher> response = await _teacherService.fetchAllTeachers(token);
      setState(() {
        _teachers = response;
        _totalTeachers = response.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _teachers = []; // Ensure teachers is empty on error
        _isLoading = false;
      });
      print(e);
      throw Exception('Failed to load teachers');
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
                    // Header
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

                    // Data Table
                    isMobile || isTablet
                        ? RawScrollbar(
                            padding: const EdgeInsets.only(left: 18),
                            trackBorderColor: theme.colorScheme.surface,
                            trackVisibility: true,
                            scrollbarOrientation: ScrollbarOrientation.bottom,
                            controller: _scrollController,
                            thumbVisibility: true,
                            thickness: 8.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: constraints.maxWidth,
                                    ),
                                    child: _isLoading 
                                      ? const Center(child: CircularProgressIndicator())
                                      : _teachers.isEmpty 
                                        ? SizedBox(
                                            width: constraints.maxWidth,
                                            child: _buildNoTeachersMessage(context)
                                          )
                                        : userListDataTable(context),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: _isLoading 
                              ? const Center(child: CircularProgressIndicator())
                              : _teachers.isEmpty 
                                ? Container(
                                    width: constraints.maxWidth,
                                    constraints: BoxConstraints(
                                      minWidth: constraints.maxWidth,
                                      minHeight: 200,
                                    ),
                                    child: _buildNoTeachersMessage(context),
                                  )
                                : ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: constraints.maxWidth,
                                    ),
                                    child: userListDataTable(context),
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
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        setState(() {
          //_showFormDialog(context);
          context.go('/dashboard/teachers/add-teacher');
        });
      },
      label: Text(
        'Add New Teacher',
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

  // User List Data Table
  Theme userListDataTable(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Theme(
      data: ThemeData(
          dividerColor: theme.colorScheme.outline,
          dividerTheme: DividerThemeData(
            color: theme.colorScheme.outline,
          )),
      child: DataTable(
        checkboxHorizontalMargin: 16,
        dataRowMaxHeight: 70,
        headingTextStyle: textTheme.titleMedium,
        dataTextStyle: textTheme.bodySmall,
        headingRowColor: WidgetStateProperty.all(theme.colorScheme.surface),
        showBottomBorder: true,
        columns: const [
          DataColumn(label: Text('SN.')),
          DataColumn(label: Text('Username')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Action')),
        ],
        rows: _teachers.asMap().entries.map(
          (entry) {
            final index = entry.key + 1;
            final teacherInfo = entry.value;
            return DataRow(
              cells: [
                DataCell(Text(index.toString())),
                DataCell(Text(teacherInfo.username)),
                DataCell(Text(teacherInfo.fullName)),
                DataCell(Text(teacherInfo.email)),
                DataCell(
                  Row(
                    children: [
                      IconButton(onPressed: () {
                        context.go('/dashboard/teachers/teacher-profile', extra: teacherInfo.id);
                      }, icon: const Icon(Icons.visibility, color: AcnooAppColors.kDark3,)),
                      IconButton(onPressed: () {
                        context.go('/dashboard/teachers/edit-teacher');
                      }, icon: const Icon(Icons.edit, color: AcnooAppColors.kInfo,)),
                      IconButton(onPressed: () async {
                        await _deleteTeacher(teacherInfo.id);
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

  // Add this new method
  Widget _buildNoTeachersMessage(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No Teachers Added Yet',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Click the "Add New Teacher" button to add your first teacher',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
