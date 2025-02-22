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
    // Dashboard
    GroupedMenuModel(
      name: 'Dashboard',
      menus: [
        if (userRole == 'admin' || userRole == 'teacher')
        SidebarItemModel(
          name: 'Dashboard',
          iconPath: Icons.home,
          navigationPath: '/dashboard',
        ),
      ],
    ),

    // Academic Management
    GroupedMenuModel(
      name: 'Academic Management',
      menus: [
        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Boards',
          iconPath: Icons.school,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/boards',
          submenus: [
            SidebarSubmenuModel(name: "All Boards", navigationPath: "all-boards"),
            SidebarSubmenuModel(name: "Add Board", navigationPath: "add-board"),
          ],
        ),

        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Classes',
          iconPath: Icons.groups,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/classes',
          submenus: [
            SidebarSubmenuModel(name: "All Classes", navigationPath: "all-classes"),
            SidebarSubmenuModel(name: "Add Class", navigationPath: "add-class"),
          ],
        ),

        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Subjects',
          iconPath: Icons.auto_stories,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/subjects',
          submenus: [
            SidebarSubmenuModel(name: "All Subjects", navigationPath: "all-subjects"),
            SidebarSubmenuModel(name: "Add Subject", navigationPath: "add-subject"),
          ],
        ),

        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Syllabus',
          iconPath: Icons.article,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/syllabus',
          submenus: [
            SidebarSubmenuModel(name: "All Syllabus", navigationPath: "all-syllabus"),
            SidebarSubmenuModel(name: "Add Syllabus", navigationPath: "add-syllabus"),
          ],
        ),
      ],
    ),

    // Learning Materials
    GroupedMenuModel(
      name: 'Learning Materials',
      menus: [
        if (userRole == 'admin' || userRole == 'teacher')
        SidebarItemModel(
          name: 'Video Lectures',
          iconPath: Icons.video_library,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/lectures',
          submenus: [
            SidebarSubmenuModel(name: "All Video Lectures", navigationPath: "all-lectures"),
            SidebarSubmenuModel(name: "Add Video Lecture", navigationPath: "add-lecture"),
          ],
        ),

        if (userRole == 'admin' || userRole == 'teacher')
        SidebarItemModel(
          name: 'Study Material',
          iconPath: Icons.library_books,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/study-materials',
          submenus: [
            SidebarSubmenuModel(name: "All Study Material", navigationPath: "all-study-materials"),
            SidebarSubmenuModel(name: "Add Study Material", navigationPath: "add-study-material"),
          ],
        ),
      ],
    ),

    // Assessment
    GroupedMenuModel(
      name: 'Assessment',
      menus: [
        if (userRole == 'admin' || userRole == 'teacher')
        SidebarItemModel(
          name: 'Exams',
          iconPath: Icons.assignment,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/exams',
          submenus: [
            SidebarSubmenuModel(name: "All Exams", navigationPath: "all-exams"),
            SidebarSubmenuModel(name: "Add Exam", navigationPath: "add-exam"),
            SidebarSubmenuModel(name: "All Questions", navigationPath: "all-questions"),
            SidebarSubmenuModel(name: "Add Question", navigationPath: "add-question"),
          ],
        ),
      ],
    ),

    // User Management
    GroupedMenuModel(
      name: 'User Management',
      menus: [
        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Admins',
          iconPath: Icons.admin_panel_settings,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/admins',
          submenus: [
            SidebarSubmenuModel(name: "All Admins", navigationPath: "all-admins"),
            SidebarSubmenuModel(name: "Add Admin", navigationPath: "add-admin"),
          ],
        ),

        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Teachers',
          iconPath: Icons.person,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/teachers',
          submenus: [
            SidebarSubmenuModel(name: "All Teachers", navigationPath: "all-teachers"),
            SidebarSubmenuModel(name: "Add Teacher", navigationPath: "add-teacher"),
          ],
        ),

        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Students',
          iconPath: Icons.people,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/students',
          submenus: [
            SidebarSubmenuModel(name: "All Students", navigationPath: "all-students"),
            SidebarSubmenuModel(name: "Add Student", navigationPath: "add-student"),
          ],
        ),
      ],
    ),

    // Schedule
    GroupedMenuModel(
      name: 'Schedule',
      menus: [
        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Schedule',
          iconPath: Icons.calendar_month,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/schedule',
          submenus: [
            SidebarSubmenuModel(name: "All Schedule", navigationPath: "all-schedule"),
            SidebarSubmenuModel(name: "Add Schedule", navigationPath: "add-schedule"),
          ],
        ),
      ],
    ),

    // Fees Management
    GroupedMenuModel(
      name: 'Fees Management',
      menus: [
        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Fees',
          iconPath: Icons.payments,
          sidebarItemType: SidebarItemType.submenu,
          navigationPath: '/dashboard/fees',
          submenus: [
            SidebarSubmenuModel(name: "All Fees", navigationPath: "all-fees"),
            SidebarSubmenuModel(name: "Add Fee", navigationPath: "add-fee"),
            SidebarSubmenuModel(name: "Fee Categories", navigationPath: "fee-categories"),
            SidebarSubmenuModel(name: "Fee Collection", navigationPath: "fee-collection"),
            SidebarSubmenuModel(name: "Payment History", navigationPath: "payment-history"),
          ],
        ),
      ],
    ),

    // Settings
    GroupedMenuModel(
      name: 'Settings',
      menus: [
        if (userRole == 'admin')
        SidebarItemModel(
          name: 'Settings',
          iconPath: Icons.settings,
          navigationPath: '/dashboard/settings',
          sidebarItemType: SidebarItemType.submenu,
          submenus: [
            SidebarSubmenuModel(name: "Admin Setting", navigationPath: "admin-setting"),
            SidebarSubmenuModel(name: "App Setting", navigationPath: "app-setting"),
            SidebarSubmenuModel(name: "Page Setting", navigationPath: "page-setting"),
          ],
        ),
      ],
    ),
  ];
}
