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
import 'package:http/http.dart' as http;
import 'dart:convert';


class SchedulesListView extends StatefulWidget {
  const SchedulesListView({super.key});

  @override
  State<SchedulesListView> createState() => _SchedulesListViewState();
}

class _SchedulesListViewState extends State<SchedulesListView> {
  final String API_BASE_URL = 'https://api.ramaanya.com/api';
  List<Subject> _subjects = [];
  int _totalSubjects = 0;


  List<dynamic> _routinesList = [];

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
    _fetchRoutines();
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

  Future<void> _deleteRoutine(String routineId, String token) async {
  // Show confirmation dialog before deleting
  bool? confirmDelete = await _showDeleteConfirmationDialog();
  if (confirmDelete == true) {
    try {
      // Call the API to delete the routine
      final response = await http.delete(
        Uri.parse('$API_BASE_URL/routine/$routineId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Successfully deleted, now refresh the routines list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Routine deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        await _fetchRoutines();
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete routine'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle error appropriately
      print('Error deleting routine: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete routine: $e')),
      );
    }
  }
}

  ///_____________________________________________________________________Search_query_________________________
  void _setSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

Future<void> _fetchRoutines() async {
  _isLoading = true;
    final url = '$API_BASE_URL/routine/all';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _routinesList = jsonDecode(response.body);
          logger.d('Fetched ${_routinesList.length} routines');
          logger.d('routines: $_routinesList');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Routines fetched successfully'),
              backgroundColor: Colors.green,
            ),
          );
          _isLoading = false;
        });
      } else {
        logger.e('Failed to fetch routines: ${response.body}');

        // Optionally show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to fetch routines'),
            backgroundColor: Colors.red,
          ),
        );
        _isLoading = false;
      }


    } catch (e) {
      logger.e('Error fetching routines: $e');
      // Optionally show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to fetch routines'),
          backgroundColor: Colors.red,
        ),
      );
      _isLoading = false;
    }
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
                                    child: userListDataTable(context),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: _isLoading ? const Center(child: CircularProgressIndicator(),) : userListDataTable(context),
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
          context.go('/dashboard/schedule/add-schedule');
        });
      },
      label: Text(
        'Add New Schedule',
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
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Action')),
        ],
        rows: _routinesList.asMap().entries.map(
          (entry) {
            final index = entry.key + 1;
            final routine = entry.value;
            return DataRow(
              cells: [
                DataCell(Text(index.toString())),
                DataCell(Text(routine['board']['name']+" "+routine['class']['name']+" "+routine['year'].toString()+" Routine")),
                DataCell(
                  Row(
                    children: [
                      IconButton(onPressed: () {
                        context.go('/dashboard/schedule/view-schedule/${routine['_id']}');
                      }, icon: const Icon(Icons.visibility, color: AcnooAppColors.kDark3,)),


                      IconButton(onPressed: () {
                        context.go('/dashboard/schedule/edit-schedule/${routine['_id']}');
                      }, icon: const Icon(Icons.edit, color: AcnooAppColors.kInfo,)),



                      IconButton(onPressed: () async {
                        await _deleteRoutine(routine['_id'].toString(), token);
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
