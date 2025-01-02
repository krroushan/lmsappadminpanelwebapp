// 🐦 Flutter imports:
import 'package:flutter/material.dart';

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
  var log = Logger();

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchStudents(1);
    _fetchTeachers();
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

  List<(int, String, String, Color)> get _overviewItems => [
      (
        _totalStudents,
        "Total Students",
        "assets/images/widget_images/dashboard_overview_icon/total_orders.svg",
        const Color(0xffFFD7FD),
      ),
      (
        _totalTeachers,
        "Total Teachers",
        "assets/images/widget_images/dashboard_overview_icon/total_products.svg",
        const Color(0xffddecff),
      ),
      (
        50,
        "Total Exams",
        "assets/images/widget_images/dashboard_overview_icon/total_stores.svg",
        const Color(0xffEDD9FF),
      ),
      (
        8,
        "Total Attendance",
        "assets/images/widget_images/dashboard_overview_icon/total_delivery_boy.svg",
        const Color(0xffFFE5D9),
      ),
      (
        500,
        "Total Lectures",
        "",
        const Color(0xffCFFEEC),
      ),
    ];


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
        padding: EdgeInsetsDirectional.all(_padding / 2.5),
        child: Column(
          children: [
            // Overviews
            ResponsiveGridRow(
              rowSegments: 100,
              children: List.generate(
                _overviewItems.length,
                (index) {
                  final _data = _overviewItems[index];

                  return ResponsiveGridCol(
                    lg: _mqSize.width < 1400 ? 33 : 20,
                    md: _mqSize.width < 768 ? 50 : 33,
                    xs: 100,
                    child: Padding(
                      padding: EdgeInsets.all(_padding / 2.5),
                      child: _isLoading ? const Center(
                        child: CircularProgressIndicator(),
                      )
                      : OverviewTileWidget(
                        value: _data.$1,
                        title: _data.$2,
                        imagePath: null,
                        icon: const Icon(Icons.person),
                        iconSize: 60,
                        valueStyle: _theme.textTheme.titleLarge?.copyWith(
                          color: _isDark ? Colors.white : null,
                        ),
                        titleStyle: _theme.textTheme.bodyLarge?.copyWith(
                          color: _isDark ? Colors.white : null,
                        ),
                        iconAlignment: IconAlignment.end,
                        tileColor: _data.$4.withOpacity(_isDark ? 0.2 : 1),
                        iconRadius: BorderRadius.zero,
                        iconBackgroundColor: Colors.transparent,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Other Contents
           
            // Tables
          ],
        ),
      ),
    );
  }
}