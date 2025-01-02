// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import 'package:acnoo_flutter_admin_panel/app/pages/users_page/user_profile/user_profile_details_widget.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/users_page/user_profile/user_profile_update_widget.dart';
import '../../../../generated/l10n.dart' as l;
import '../../../core/helpers/fuctions/_get_image.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import '../../../models/student_data_model.dart';
import '../../../core/api_service/student_service.dart';

class UserProfileView extends StatefulWidget {
  final String studentId;
  const UserProfileView({super.key, required this.studentId});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  StudentDataModel _student = StudentDataModel(rollNo: '', fullName: '', email: '', password: '', classId: '');
  @override
  void initState() {
    super.initState();
    //_fetchStudentData();
    print("widgetstudentId: ${widget.studentId}");
  }

  // Future<StudentDataModel> _fetchStudentData() async {
  //   final studentService = StudentService();
  //   _student = await studentService.getStudent(widget.studentId); // Assign single instance
  //   print("student: ${_student.fullName}");
  //   setState(() {});
  //   return _student; // Return the single instance
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = l.S.of(context);
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
            ///-----------------------------user_profile_details
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
                      child: UserProfileDetailsWidget(
                          padding: _padding,
                          theme: theme,
                          textTheme: textTheme,
                          userProfile: _student),
                    ),

                    /// -------------image
                    Positioned(
                      top: 10,
                      child: Container(
                        height: 110,
                        width: 110,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: getImageType(
                          _userProfile.$1,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ///-----------------------------user_profile_update
            // ResponsiveGridCol(
            //   lg: 6,
            //   child: Padding(
            //     padding: EdgeInsets.all(_padding),
            //     child: ShadowContainer(
            //       contentPadding: EdgeInsets.all(_padding),
            //       // headerText: 'User Profile',
            //       headerText: lang.userProfile,
            //       child: UserProfileUpdateWidget(textTheme: textTheme),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

const (String,) _userProfile =
    ('assets/images/static_images/avatars/person_images/person_image_01.jpeg',);
