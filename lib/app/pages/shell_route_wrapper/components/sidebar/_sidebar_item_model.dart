part of '_sidebar.dart';

AuthProvider authProvider = AuthProvider(); // This is temporary, we'll improve it

class SidebarItemModel {
  final String name;
  final IconData iconPath;
  final SidebarItemType sidebarItemType;
  final List<SidebarSubmenuModel>? submenus;
  final String? navigationPath;
  final bool isPage;

  SidebarItemModel({
    required this.name,
    required this.iconPath,
    this.sidebarItemType = SidebarItemType.tile,
    this.submenus,
    this.navigationPath,
    this.isPage = false,
  }) : assert(
          sidebarItemType != SidebarItemType.submenu ||
              (submenus != null && submenus.isNotEmpty),
          'Sub menus cannot be null or empty if the item type is submenu',
        );
}

class SidebarSubmenuModel {
  final String name;
  final String? navigationPath;
  final bool isPage;

  SidebarSubmenuModel({
    required this.name,
    this.navigationPath,
    this.isPage = false,
  });
}

class GroupedMenuModel {
  final String name;
  final List<SidebarItemModel> menus;

  GroupedMenuModel({
    required this.name,
    required this.menus,
  });
}

enum SidebarItemType { tile, submenu }

List<GroupedMenuModel> _groupedMenus(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final userRole = authProvider.getRole;
  return <GroupedMenuModel>[
    // Application Group
    GroupedMenuModel(
      name: 'Application',
      menus: [
        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Dashboard',
          iconPath: Icons.home,
          navigationPath: '/dashboard',
        ),

        if (userRole == 'teacher')
        SidebarItemModel(
          name: 'Dashboard',
          iconPath: Icons.home,
          navigationPath: '/dashboard',
        ),

        if (userRole == 'admin' || userRole == 'teacher')
        SidebarItemModel(
          name: 'Video Lectures',
          iconPath: Icons.video_library,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/lectures',
          submenus: [
            SidebarSubmenuModel(
              name: "All Video Lectures",
              navigationPath: "all-lectures",
            ),
            SidebarSubmenuModel(
              name: "Add Video Lecture",
              navigationPath: "add-lecture",
            ),
          ],
        ),

        if (userRole == 'admin' || userRole == 'teacher')
        SidebarItemModel(
          name: 'Study Material',
          iconPath: Icons.library_books,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/study-materials',
          submenus: [
            SidebarSubmenuModel(
              name: "All Study Material",
              navigationPath: "all-study-materials",
            ),
            SidebarSubmenuModel(
              name: "Add Study Material",
              navigationPath: "add-study-material",
            ),
          ],
        ),

        if (userRole == 'admin' || userRole == 'teacher')
        SidebarItemModel(
          name: 'Exams',
          iconPath: Icons.assignment,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/exams',
          submenus: [
            SidebarSubmenuModel(
              name: "All Exams",
              navigationPath: "all-exams",
            ),
            SidebarSubmenuModel(
              name: "Add Exam",
              navigationPath: "add-exam",
            ),
            SidebarSubmenuModel(
              name: "All Questions",
              navigationPath: "all-questions",
            ),
            SidebarSubmenuModel(
              name: "Add Question",
              navigationPath: "add-question",
            ),
          ],
        ),

        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Students',
          iconPath: Icons.people,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/students',
          submenus: [
            SidebarSubmenuModel(
              name: "All Students",
              navigationPath: "all-students",
            ),
            SidebarSubmenuModel(
              name: "Add Student",
              navigationPath: "add-student",
            ),
          ],
        ),

      if (userRole == 'admin')
        SidebarItemModel(
          name: 'Schedule',
          iconPath: Icons.calendar_month,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/schedule',
          submenus: [
            SidebarSubmenuModel(
              name: "All Schedule",
              navigationPath: "all-schedule",
            ),
            SidebarSubmenuModel(
              name: "Add Schedule",
              navigationPath: "add-schedule",
            ),
          ],
        ),

        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Syllabus',
          iconPath: Icons.article,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/syllabus',
          submenus: [
            SidebarSubmenuModel(
              name: "All Syllabus",
              navigationPath: "all-syllabus",
            ),
            SidebarSubmenuModel(
              name: "Add Syllabus",
              navigationPath: "add-syllabus",
            ),
          ],
        ),

        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Subjects',
          iconPath: Icons.auto_stories,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/subjects',
          submenus: [
            SidebarSubmenuModel(
              name: "All Subjects",
              navigationPath: "all-subjects",
            ),
            SidebarSubmenuModel(
              name: "Add Subject",
              navigationPath: "add-subject",
            ),
          ],
        ),

        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Classes',
          iconPath: Icons.groups,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/classes',
          submenus: [
            SidebarSubmenuModel(
              name: "All Classes",
              navigationPath: "all-classes",
            ),
            SidebarSubmenuModel(
              name: "Add Class",
              navigationPath: "add-class",
            ),
          ],
        ),

        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Boards',
          iconPath: Icons.school,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/boards',
          submenus: [
            SidebarSubmenuModel(
              name: "All Boards",
              navigationPath: "all-boards",
            ),
            SidebarSubmenuModel(
              name: "Add Board",
              navigationPath: "add-board",
            ),
          ],
        ),

        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Teachers',
          iconPath: Icons.person,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/teachers',
          submenus: [
            SidebarSubmenuModel(
              name: "All Teachers",
              navigationPath: "all-teachers",
            ),
            SidebarSubmenuModel(
              name: "Add Teacher",
              navigationPath: "add-teacher",
            ),
          ],
        ),

        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Admins',
          iconPath: Icons.admin_panel_settings,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/admins',
          submenus: [
            SidebarSubmenuModel(
              name: "All Admins",
              navigationPath: "all-admins",
            ),
            SidebarSubmenuModel(
              name: "Add Admin",
              navigationPath: "add-admin",
            ),
          ],
        ),

        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Settings',
          iconPath: Icons.settings,
          navigationPath: '/dashboard/settings',
          sidebarItemType: SidebarItemType.submenu,
          submenus: [
            SidebarSubmenuModel(
              name: "Admin Setting",
              navigationPath: "admin-setting",
            ),
            SidebarSubmenuModel(
              name: "App Setting",
              navigationPath: "app-setting",
            ),
            SidebarSubmenuModel(
              name: "Page Setting",
              navigationPath: "page-setting",
            ),
          ],
        ),
      ],
    ),

    // Tables & Forms Group
    GroupedMenuModel(
      name: ' Tables & Forms',
      menus: [
       ],
    ),

    // Pages
    GroupedMenuModel(
      name: 'Pages',
      menus: [
       
      ],
    ),
  ];
}
