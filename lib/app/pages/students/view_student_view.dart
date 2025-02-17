// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import 'student_profile.dart';
import '../../widgets/shadow_container/_shadow_container.dart';
import '../../core/api_service/student_service.dart';
import '../../models/student/student.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import '../../models/classes/class_info.dart';
import '../../models/board/board.dart';

final logger = Logger();

class ViewStudentView extends StatefulWidget {
  final String studentId;
  const ViewStudentView({required this.studentId, super.key});

  @override
  State<ViewStudentView> createState() => _ViewStudentViewState();
}

class _ViewStudentViewState extends State<ViewStudentView> {
  bool _isLoading = true;
  String studentId = '';
  String token = '';
  Student student = Student(
    id: '',
    fullName: '',
    fatherName: '',
    fatherOccupation: '',
    motherName: '',
    phoneNumber: '',
    alternatePhoneNumber: '',
    rollNo: '',
    schoolIdRollNumber: '',
    schoolInstitutionName: '',
    email: '',
    board: Board(id: '', name: '', description: '', boardImage: '', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    classInfo: ClassInfo(id: '', name: '', description: '', classImage: '', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    adharNumber: '',
    dateOfBirth: '',
    gender: '',
    category: '',
    disability: '',
    typeOfInstitution: '',
    password: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    studentId = widget.studentId;
    _fetchStudent();
  }

  Future<Student> _fetchStudent() async {
    setState(() {
      _isLoading = true;
    });
    final studentService = StudentService();
    try { 
      final studentData = await studentService.getStudentById(studentId, token);
      setState(() {
        student = studentData;
        _isLoading = false;
      });
      return studentData;
    } catch (e) {
      logger.e(e);
      throw Exception('Failed to fetch student');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final _padding = responsiveValue<double>(
      context,
      xs: 16 / 2,
      sm: 16 / 2,
      md: 16 / 2,
      lg: 24 / 2,
    );
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_padding),
        child: ResponsiveGridRow(
          children: [
            ResponsiveGridCol(
              lg: 12,
              child: Padding(
                padding: EdgeInsets.all(_padding),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ShadowContainer(
                      contentPadding: EdgeInsets.zero,
                      showHeader: false,
                      child: StudentProfileDetailsWidget(
                          padding: _padding,
                          theme: theme,
                          textTheme: textTheme,
                          student: student),
                    ),

                    /// -------------image
  //                   Positioned(
  //                     top: 10,
  //                     child: Container(
  //                       height: 300,
  //                       width: 700,
  //                       decoration: const BoxDecoration(
  //                         shape: BoxShape.rectangle,
  //                       ),
  //                       clipBehavior: Clip.antiAlias,
  //                       child: Image.network(
  // 'https://apnahomeopathy.com/wp-content/uploads/2024/10/homeopathic-doctors-at-apnahomeopathy-clinic.webp',
  // fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

