// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../widgets/widgets.dart';
import '../../models/student/student_all_response.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import '../../core/api_service/student_service.dart';
import 'package:logger/logger.dart';
import '../../models/teacher/teacher.dart';
import '../../core/api_service/teacher_service.dart';
import '../../widgets/shimmer_loading_card.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/api_service/exam_service.dart';
import '../../models/exam/get_exam.dart';
import '../../core/api_service/lecture_service.dart';
import '../../models/lecture/lecture.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});
  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _totalStudents = 0;
  int _totalTeachers = 0;
  int _totalExams = 0;
  int _totalAttendance = 0;
  int _totalLectures = 0;
  String token = "";
  bool _isLoading = false;

  List<StudentAllResponse> _students = [];
  int _totalPages = 0;

  final StudentService _studentService = StudentService();
  final TeacherService _teacherService = TeacherService();
  final ExamService _examService = ExamService();
  final LectureService _lectureService = LectureService();
  var log = Logger();

  int _activeUsers = 0;
  int _ongoingCourses = 0;
  double _averageAttendance = 0;
  int _upcomingExams = 0;
  List<Map<String, dynamic>> _recentActivities = [];
  Map<String, double> _attendanceData = {};
  List<Map<String, dynamic>> _upcomingSchedule = [];
  String _userRole = '';
  List<GetExam> _upcomingExamsList = [];
  List<Lecture> _upcomingLectures = [];

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _userRole = authProvider.getRole;
    _fetchStudents(1);
    if (_userRole != 'teacher') {
      _fetchTeachers();
    }
    _fetchUpcomingExams();
    _fetchUpcomingLectures();
  }

  Future<void> _fetchStudents(int page) async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<StudentAllResponse> response = await _studentService.fetchStudents(page, token); // Fetch the response
      setState(() {
        _totalStudents = response[0].total;
        _isLoading = false;
      });
      log.i("astudents: $_totalStudents");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      //print(e);
      throw Exception('Failed to load students');
    }
  }

  Future<void> _fetchTeachers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Teacher> response = await _teacherService.fetchAllTeachers(token); // Fetch the response
      print("response: ${response[0].fullName}");
        setState(() {
        _totalTeachers = response.length;
        _isLoading = false;
      });
      
        print("ateacher: $_totalTeachers");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
      throw Exception('Failed to load teachers');
    }
  }

  Future<void> _fetchUpcomingExams() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<GetExam> exams = await _examService.getAllExams(token);
      setState(() {
        _upcomingExamsList = exams;
        _upcomingExamsList.sort((a, b) => 
          (a.createdAt ?? DateTime.now()).compareTo(b.createdAt ?? DateTime.now())
        );
        _upcomingExamsList = _upcomingExamsList.take(5).toList(); // Show only 5 most recent exams
        _totalExams = exams.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      log.e("Failed to fetch exams: $e");
    }
  }

  Future<void> _fetchUpcomingLectures() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Lecture> lectures = await _lectureService.fetchAllLectures(token);
      setState(() {
        _upcomingLectures = lectures
            .where((lecture) => lecture.lectureType == 'live')
            .toList();
        _upcomingLectures.sort((a, b) => 
          DateTime.parse('${a.startDate} ${a.startTime}')
              .compareTo(DateTime.parse('${b.startDate} ${b.startTime}'))
        );
        _upcomingLectures = _upcomingLectures.take(5).toList(); // Show only 5 upcoming lectures
        _totalLectures = lectures.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      log.e("Failed to fetch lectures: $e");
    }
  }

  List<(int, String, String, Color)> get _overviewItems {
    final baseItems = [
      (_totalStudents, "Total Students", "group", const Color(0xFF6C63FF)),
    ];

    if (_userRole != 'teacher') {
      baseItems.addAll([
        (_totalTeachers, "Total Teachers", "school", const Color(0xFF4CAF50)),
        (_activeUsers, "Active Users", "person", const Color(0xFFFF6B6B)),
      ]);
    }

    baseItems.addAll([
      (_ongoingCourses, "Ongoing Courses", "book", const Color(0xFFFFB74D)),
      (_totalExams, "All Exams", "assignment", const Color(0xFF4DB6AC)),
      (_totalLectures, "Total Lectures", "class", const Color(0xFF64B5F6)),
    ]);

    return baseItems;
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final _mqSize = MediaQuery.sizeOf(context);

    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      lg: 24,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(_padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Overview',
              style: _theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // Overview Cards with enhanced styling
            ResponsiveGridRow(
              rowSegments: 12,
              children: List.generate(
                _overviewItems.length,
                (index) {
                  final _data = _overviewItems[index];

                  return ResponsiveGridCol(
                    lg: _mqSize.width < 1400 ? 4 : 3,
                    md: _mqSize.width < 768 ? 6 : 4,
                    xs: 12,
                    child: Padding(
                      padding: EdgeInsets.all(_padding / 2.5),
                      child: _isLoading 
                        ? const ShimmerLoadingCard()
                        : OverviewTileWidget(
                            value: _data.$1,
                            title: _data.$2,
                            imagePath: null,
                            icon: Icon(getIconData(_data.$3)),
                            iconSize: 48,
                            valueStyle: _theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _isDark ? Colors.white : null,
                            ),
                            titleStyle: _theme.textTheme.titleMedium?.copyWith(
                              color: _isDark ? Colors.white70 : Colors.black87,
                            ),
                            iconAlignment: IconAlignment.end,
                            tileColor: _data.$4.withOpacity(_isDark ? 0.15 : 0.1),
                            iconRadius: BorderRadius.circular(12),
                            iconBackgroundColor: _data.$4.withOpacity(_isDark ? 0.2 : 0.2),
                          ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions Card with consistent styling
            ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 12,
                  md: 12,
                  child: _buildSectionCard(
                    context: context,
                    icon: Icons.flash_on,
                    title: 'Quick Actions',
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _QuickActionButton(
                          icon: Icons.video_camera_front,
                          label: 'Start Live Class',
                          onTap: () {
                            context.go('/dashboard/lectures/add-lecture');
                          },
                        ),
                        _QuickActionButton(
                          icon: Icons.assignment,
                          label: 'Create Assignment',
                          onTap: () {
                            context.go('/dashboard/assignments/add-assignment');
                          },
                        ),
                        _QuickActionButton(
                          icon: Icons.calendar_today,
                          label: 'Schedule Exam',
                          onTap: () {
                            context.go('/dashboard/exams/add-exam');
                          },
                        ),
                        _QuickActionButton(
                          icon: Icons.upload_file,
                          label: 'Upload Material',
                          onTap: () {
                            context.go('/dashboard/study-materials/add-study-material');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Statistics Card
            ResponsiveGridRow(
              children: [
                // ResponsiveGridCol(
                //   lg: 6,
                //   md: 6,
                //   child: ConstrainedBox(
                //     constraints: const BoxConstraints.tightFor(height: 435),
                //     child: ShadowContainer(
                //       margin: EdgeInsetsDirectional.all(_padding / 2.5),
                //       headerText: 'Attendance Statistics',
                //       trailing: const FilterDropdownButton(),
                //       child: const comp.SMSHistoryStatisticsLineChart(),
                //     ),
                //   ),
                // ),

                // ResponsiveGridCol(
                //   lg: 6,
                //   md: 6,
                //   child: ShadowContainer(
                //     margin: EdgeInsetsDirectional.all(_padding / 2.5),
                //     contentPadding: EdgeInsetsDirectional.zero,
                //     headerText: 'Top Users',
                //     trailing: Text.rich(
                //       TextSpan(
                //         text: 'View All',
                //         style: TextStyle(
                //           color: _theme.colorScheme.primary,
                //         ),
                //         mouseCursor: SystemMouseCursors.click,
                //         children: [
                //           WidgetSpan(
                //             alignment: PlaceholderAlignment.middle,
                //             child: Container(
                //               margin:
                //                   const EdgeInsetsDirectional.only(start: 6),
                //               child: Icon(
                //                 Icons.arrow_forward,
                //                 color: _theme.colorScheme.primary,
                //                 size: 16,
                //               ),
                //             ),
                //           )
                //         ],
                //       ),
                //       style: _theme.textTheme.bodyMedium,
                //     ),
                //     child: const comp.TopUsersTable(),
                //   ),
                // ),
              ],
            ),

            const SizedBox(height: 24),

            // Bottom Section Cards
            ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 6,
                  md: 6,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 435),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      headerText: 'Scheduled Live Classes',
                      //trailing: const FilterDropdownButton(),
                      child: _buildUpcomingScheduleTable(),
                    ),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 6,
                  md: 6,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 435),
                    child: ShadowContainer(
                      margin: EdgeInsetsDirectional.all(_padding / 2.5),
                      headerText: 'Upcoming Exams',
                      //trailing: const FilterDropdownButton(),
                      child: _buildUpcomingExamsTable(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingScheduleTable() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        horizontalMargin: 24,
        columnSpacing: 32,
        headingRowHeight: 56,
        dataRowHeight: 64,
        columns: const [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Time')),
          DataColumn(label: Text('Subject')),
          DataColumn(label: Text('Title')),
        ],
        rows: _upcomingLectures.map((lecture) {
          return DataRow(
            cells: [
              DataCell(Text(lecture.startDate)),
              DataCell(Text(lecture.startTime)),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getSubjectColor(lecture.subject?.name ?? '').withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    lecture.subject?.name ?? '',
                    style: TextStyle(color: _getSubjectColor(lecture.subject?.name ?? '')),
                  ),
                ),
              ),
              DataCell(Text(lecture.title)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUpcomingExamsTable() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        horizontalMargin: 24,
        columnSpacing: 32,
        headingRowHeight: 56,
        dataRowHeight: 64,
        columns: const [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Time')),
          DataColumn(label: Text('Subject')),
          DataColumn(label: Text('Title')),
        ],
        rows: _upcomingExamsList.map((exam) {
          final DateTime examDate = exam.createdAt ?? DateTime.now();
          final String formattedDate = "${examDate.year}-${examDate.month.toString().padLeft(2, '0')}-${examDate.day.toString().padLeft(2, '0')}";
          final String formattedTime = "${examDate.hour.toString().padLeft(2, '0')}:${examDate.minute.toString().padLeft(2, '0')}";
          
          return DataRow(
            cells: [
              DataCell(Text(formattedDate)),
              DataCell(Text(formattedTime)),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getSubjectColor(exam.subject.name).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    exam.subject.name,
                    style: TextStyle(color: _getSubjectColor(exam.subject.name)),
                  ),
                ),
              ),
              DataCell(Text(exam.title)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'mathematics':
        return Colors.blue;
      case 'physics':
        return Colors.purple;
      case 'chemistry':
        return Colors.green;
      case 'biology':
        return Colors.orange;
      case 'english':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatisticsCharts() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                'Monthly Attendance',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barGroups: [
                      _makeGroupData(0, 85, 'Jan'),
                      _makeGroupData(1, 75, 'Feb'),
                      _makeGroupData(2, 90, 'Mar'),
                      _makeGroupData(3, 95, 'Apr'),
                      _makeGroupData(4, 88, 'May'),
                      _makeGroupData(5, 92, 'Jun'),
                    ],
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const titles = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                            return Text(
                              titles[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}%',
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      
      ],
    );
  }

  BarChartGroupData _makeGroupData(int x, double y, String title) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Theme.of(context).colorScheme.primary,
          width: 22,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  IconData getIconData(String name) {
    switch (name) {
      case 'group': return Icons.group;
      case 'school': return Icons.school;
      case 'person': return Icons.person;
      case 'book': return Icons.book;
      case 'assignment': return Icons.assignment;
      case 'class': return Icons.class_;
      default: return Icons.error;
    }
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24),
              const SizedBox(height: 8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}