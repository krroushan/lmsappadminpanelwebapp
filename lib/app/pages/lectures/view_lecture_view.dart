// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import 'lecture_profile.dart';
import '../../widgets/shadow_container/_shadow_container.dart';
import '../../core/api_service/lecture_service.dart';
import '../../models/lecture/lecture.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import '../../models/classes/class_info.dart';
import '../../models/subject/subject.dart';
import '../../models/teacher/teacher.dart';

final logger = Logger();

class ViewLectureView extends StatefulWidget {
  final String lectureId;
  const ViewLectureView({required this.lectureId, super.key});

  @override
  State<ViewLectureView> createState() => _ViewLectureViewState();
}

class _ViewLectureViewState extends State<ViewLectureView> {
  bool _isLoading = true;
  String lectureId = '';
  String token = '';
  Lecture lecture = Lecture(
    id: '',
    title: '',
    description: '',
    startDate: '',
    startTime: '',
    teacher: Teacher(id: '', username: '', fullName: '', role: '', password: '', createdAt: DateTime.now(), updatedAt: DateTime.now(), email: ''),
    classInfo: ClassInfo(id: '', name: '', description: '', classImage: '', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    subject: Subject(id: '', name: '', description: '', subjectImage: '', classId: ''),
    lectureType: '',
    streamId: '',
    thumbnail: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    lectureId = widget.lectureId;
    _fetchLecture();
  }

  Future<Lecture> _fetchLecture() async {
    setState(() {
      _isLoading = true;
    });
    final lectureService = LectureService();
    try { 
      final lectureData = await lectureService.getLectureById(lectureId, token);
      setState(() {
        lecture = lectureData;
        _isLoading = false;
      });
      return lectureData;
    } catch (e) {
      logger.e(e);
      throw Exception('Failed to fetch lecture');
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
                      child: LectureProfileDetailsWidget(
                          padding: _padding,
                          theme: theme,
                          textTheme: textTheme,
                          lecture: lecture),
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

