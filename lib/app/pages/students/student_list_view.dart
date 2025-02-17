// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:logger/logger.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../core/theme/_app_colors.dart';
import '../../widgets/widgets.dart';
import '../../core/api_service/student_service.dart';
import '../../models/student/student_all_response.dart';
import '../../models/student/student.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';

class StudentListView extends StatefulWidget {
  const StudentListView({super.key});

  @override
  State<StudentListView> createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  int _totalStudents = 0;
  List<Student> _students = [];

  var log = Logger();

  bool _isLoading = true;
  final StudentService _studentService = StudentService();

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  int _rowsPerPage = 10;
  int _totalPages = 0;
  String _searchQuery = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchStudents(_currentPage + 1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // New method to fetch student data from the API
  Future<void> _fetchStudents(int page) async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<StudentAllResponse> response = await _studentService.fetchStudents(page, token); // Fetch the response
      setState(() {
        _students = response[0].students;
        _totalStudents = response[0].total;
        _totalPages = response[0].totalPages;
        _isLoading = false;
      });
      log.i("astudents: ${_students.map((e) => e.email)}");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      //print(e);
      throw Exception('Failed to load students');
    }
  }

  // delete confirmation dialog
  Future<bool?> _showDeleteConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Student'),
          content: const Text('Do you want to delete this student?'),
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

  // delete student
  Future<void> _deleteStudent(String studentId) async {
    // Show confirmation dialog before deleting
    bool? confirmDelete = await _showDeleteConfirmationDialog();
    if (confirmDelete == true) {
      try {
        await _studentService.deleteStudent(studentId, token);
        // Check if the current page is now empty after deletion
        if (_students.length == 1 && _currentPage > 0) {
          _currentPage--; // Go back to the previous page if the current page is empty
        }
        // Optionally, refresh the class list after deletion
        await _fetchStudents(_currentPage + 1);
      } catch (e) {
        // Handle error appropriately
        print('Error deleting student: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete student: $e')),
        );
      }
    }
  }


  // search query
  void _setSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 0; // Reset to the first page when searching
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
                                    addStudentButton(textTheme),
                                    const Spacer(),
                                    // fakeStudentButton(textTheme),
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
                                addStudentButton(textTheme),
                                //const Spacer(flex: 1),
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
                                Padding(
                                  padding: _sizeInfo.padding,
                                  child: Text(
                                    '${l.S.of(context).showing} ${_currentPage * _rowsPerPage + 1} ${l.S.of(context).to} ${_currentPage * _rowsPerPage + _students.length} ${l.S.of(context).OF} ${_students.length} ${l.S.of(context).entries}',
                                    overflow: TextOverflow.ellipsis,
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

                    //______________________________________________________________________footer__________________
                    isTablet || isMobile
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: _sizeInfo.padding,
                            child: paginatedSection(theme, textTheme),
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

// new student add button
  ElevatedButton addStudentButton(TextTheme textTheme) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        setState(() {
          context.go('/dashboard/students/add-student');
        });
      },
      label: Text(
        'Add New Student',
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

// generate fake data
// new student add button
  // ElevatedButton fakeStudentButton(TextTheme textTheme) {
  //   return ElevatedButton.icon(
  //     style: ElevatedButton.styleFrom(
  //       padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
  //     ),
  //     onPressed: () {
  //       setState(() {
  //         _createFakeStudent();
  //       });
  //     },
  //     label: Text(
  //       'Generate Fake Students',
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

  // new method to create a fake student and send to API
  // Future<void> _createFakeStudent() async {
  //   // Generate a fake student with valid data
  //   final fakeStudent = StudentCreate.fromJson({
  //     "fullName": faker.person.name(), 
  //     "fatherName": faker.person.name(),
  //     "fatherOccupation": faker.person.name(),
  //     "motherName": faker.person.name(),
  //     "email": "ramngo${faker.randomGenerator.integer(1000, min: 1)}@gmail.com", 
  //     "rollNo": "RAMNGO${faker.randomGenerator.integer(1000, min: 1)}", 
  //     "phoneNumber": "${faker.randomGenerator.integer(100000000000, min: 100000000000)}",
  //     "alternatePhoneNumber": "${faker.randomGenerator.integer(100000000000, min: 100000000000)}",
  //     "adharNumber": "${faker.randomGenerator.integer(100000000000, min: 100000000000)}",
  //     "dateOfBirth": faker.date.dateTime().toString(),
  //     "gender": ["Male", "Female", "Other"][faker.randomGenerator.integer(3)],
  //     "category": ["General", "OBC", "SC", "ST"][faker.randomGenerator.integer(4)],
  //     "disability": ["Orthopedically Handicapped", "Mentally Handicapped", "Visually Handicapped", "Hearing Handicapped", "Speech Handicapped", "Multiple Handicapped", "Autistic", "Down Syndrome", "Other"][faker.randomGenerator.integer(9)],
  //     "typeOfInstitution": ["Government", "Private"][faker.randomGenerator.integer(2)],
  //     "board": [
  //       "6772e19171ffa2cea91265c0",
  //       "6772e1a171ffa2cea91265c6"
  //     ][faker.randomGenerator.integer(2)],
  //     "class": [
  //       "6772e0cd71ffa2cea91265af", 
  //       "6772e0ea71ffa2cea91265b5",
  //     ][faker.randomGenerator.integer(2)],
  //     "password": "123456789", 
  //   });

  //   print("fakeStudent: ${fakeStudent.toJson()}");

  //   try {
  //     // Send the fake student to the API
  //     await _studentService.createStudent(fakeStudent, token);
  //     // Optionally, refresh the student list after creation
  //     await _fetchStudents(_currentPage + 1);
  //   } catch (e) {
  //     print('Error creating fake student: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to create fake student: $e')),
  //     );
  //   }
  // }

  // total pages
  //int get _totalPages => (_totalPages).ceil();

  // go to next page
  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
        _fetchStudents(_currentPage + 1);
      });
    }
  }

  // go to previous page
  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _fetchStudents(_currentPage + 1);
      });
    }
  }

  // pagination footer
  Row paginatedSection(ThemeData theme, TextTheme textTheme) {
    //final lang = l.S.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '${l.S.of(context).showing} ${_currentPage * _rowsPerPage + 1} ${l.S.of(context).to} ${_currentPage * _rowsPerPage + _students.length} ${l.S.of(context).OF} ${_students.length} ${l.S.of(context).entries}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTablePaginator(
          currentPage: _currentPage + 1,
          totalPages: _totalPages,
          onPreviousTap: _goToPreviousPage,
          onNextTap: _goToNextPage,
        )
      ],
    );
  }

  // search field
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
  // user list data table
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
        headingTextStyle: textTheme.titleMedium,
        dataTextStyle: textTheme.bodySmall,
        headingRowColor: WidgetStateProperty.all(theme.colorScheme.surface),
        showBottomBorder: true,
        columns: const [
          DataColumn(label: Text('S.No')),
          DataColumn(label: Text('Roll No')),
          DataColumn(label: Text('Full Name')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Class')),
          DataColumn(label: Text('Action')),
        ],
        rows: _students.asMap().entries.map(
          (entry) {
            final index = entry.key + 1 + (_currentPage * _rowsPerPage);
            final student = entry.value;
            return DataRow(
              cells: [
                DataCell(Text(index.toString())),
                DataCell(Text(student.rollNo)),
                DataCell(Text(student.fullName)),
                DataCell(Text(student.email)),
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
                      student.classInfo.name ?? 'No Class',
                      style: textTheme.bodySmall?.copyWith(
                          color: true
                              ? AcnooAppColors.kSuccess
                              : AcnooAppColors.kError),
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      IconButton(onPressed: () {
                        context.go('/dashboard/students/student-profile/${student.id}');
                      }, icon: const Icon(Icons.visibility, color: AcnooAppColors.kDark3,)),
                      IconButton(onPressed: () {
                        context.go('/dashboard/students/edit-student/${student.id}');
                      }, icon: const Icon(Icons.edit, color: AcnooAppColors.kInfo,)),
                      IconButton(onPressed: () {
                        _deleteStudent(student.id);
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

// size info
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
