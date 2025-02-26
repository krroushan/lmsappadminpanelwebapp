class ProjectDataModel {
  final int id;
  final String projectName;
  final String title;
  final String startDate;
  final String endDate;
  final String status;
  final String priority;
  bool isSelected = false;
  final String imagePath;

  ProjectDataModel({
    required this.id,
    required this.projectName,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.priority,
    required this.imagePath,
  });

  @override
  String toString() =>
      'DataModel(id: $id, projectName: $projectName, title: $title, startDate: $startDate, endDate: $endDate, status: $status, priority: $priority)';
}

class AllUsers {
  static List<ProjectDataModel> allData = [
    ProjectDataModel(
        id: 1,
        projectName: 'Project Alpha',
        title: 'Initial Phase',
        startDate: '2024-01-01',
        endDate: '2024-06-30',
        status: 'Pending',
        priority: 'High',
        imagePath: _userProfile.$1),
    ProjectDataModel(
        id: 2,
        projectName: 'Project Beta',
        title: 'Development',
        startDate: '2023-11-01',
        endDate: '2024-03-31',
        status: 'InProgress',
        priority: 'Medium',
        imagePath: _userProfile.$2),
    ProjectDataModel(
        id: 3,
        projectName: 'Project Gamma',
        title: 'Testing',
        startDate: '2024-02-01',
        endDate: '2024-08-01',
        status: 'New',
        priority: 'Low',
        imagePath: _userProfile.$3),
    ProjectDataModel(
        id: 4,
        projectName: 'Project Delta',
        title: 'Deployment',
        startDate: '2024-03-01',
        endDate: '2024-09-30',
        status: 'Complete',
        priority: 'High',
        imagePath: _userProfile.$4),
    ProjectDataModel(
        id: 5,
        projectName: 'Project Epsilon',
        title: 'Maintenance',
        startDate: '2023-12-01',
        endDate: '2024-06-01',
        status: 'InProgress',
        priority: 'Low',
        imagePath: _userProfile.$5),
    ProjectDataModel(
        id: 6,
        projectName: 'Project Zeta',
        title: 'Planning',
        startDate: '2024-01-15',
        endDate: '2024-07-15',
        status: 'Complete',
        priority: 'Medium',
        imagePath: _userProfile.$6),
    ProjectDataModel(
        id: 7,
        projectName: 'Project Eta',
        title: 'Execution',
        startDate: '2024-02-10',
        endDate: '2024-08-10',
        status: 'Pending',
        priority: 'High',
        imagePath: _userProfile.$7),
    ProjectDataModel(
        id: 8,
        projectName: 'Project Theta',
        title: 'Closure',
        startDate: '2023-10-01',
        endDate: '2024-04-01',
        status: 'InProgress',
        priority: 'Low',
        imagePath: _userProfile.$8),
    ProjectDataModel(
        id: 9,
        projectName: 'Project Iota',
        title: 'Design',
        startDate: '2023-11-15',
        endDate: '2024-05-15',
        status: 'New',
        priority: 'High',
        imagePath: _userProfile.$9),
    ProjectDataModel(
        id: 10,
        projectName: 'Project Kappa',
        title: 'Review',
        startDate: '2024-01-20',
        endDate: '2024-07-20',
        status: 'Complete',
        priority: 'Medium',
        imagePath: _userProfile.$10),
    ProjectDataModel(
        id: 11,
        projectName: 'Project Lambda',
        title: 'Conceptualization',
        startDate: '2024-02-05',
        endDate: '2024-08-05',
        status: 'Pending',
        priority: 'High',
        imagePath: _userProfile.$1),
    ProjectDataModel(
        id: 12,
        projectName: 'Project Mu',
        title: 'Prototyping',
        startDate: '2024-03-01',
        endDate: '2024-09-01',
        status: 'InProgress',
        priority: 'Medium',
        imagePath: _userProfile.$2),
    ProjectDataModel(
        id: 13,
        projectName: 'Project Nu',
        title: 'Implementation',
        startDate: '2024-04-01',
        endDate: '2024-10-01',
        status: 'New',
        priority: 'Low',
        imagePath: _userProfile.$3),
    ProjectDataModel(
        id: 14,
        projectName: 'Project Xi',
        title: 'Execution Phase 1',
        startDate: '2024-05-01',
        endDate: '2024-11-01',
        status: 'Pending',
        priority: 'High',
        imagePath: _userProfile.$4),
    ProjectDataModel(
        id: 15,
        projectName: 'Project Omicron',
        title: 'Analysis',
        startDate: '2024-06-01',
        endDate: '2024-12-01',
        status: 'InProgress',
        priority: 'Low',
        imagePath: _userProfile.$5),
    ProjectDataModel(
        id: 16,
        projectName: 'Project Pi',
        title: 'System Integration',
        startDate: '2024-07-01',
        endDate: '2025-01-01',
        status: 'Pending',
        priority: 'Medium',
        imagePath: _userProfile.$6),
    ProjectDataModel(
        id: 17,
        projectName: 'Project Rho',
        title: 'Verification',
        startDate: '2024-08-01',
        endDate: '2025-02-01',
        status: 'Pending',
        priority: 'High',
        imagePath: _userProfile.$7),
    ProjectDataModel(
        id: 18,
        projectName: 'Project Sigma',
        title: 'Final Testing',
        startDate: '2024-09-01',
        endDate: '2025-03-01',
        status: 'InProgress',
        priority: 'Low',
        imagePath: _userProfile.$8),
    ProjectDataModel(
        id: 19,
        projectName: 'Project Tau',
        title: 'Deployment Preparation',
        startDate: '2024-10-01',
        endDate: '2025-04-01',
        status: 'Pending',
        priority: 'High',
        imagePath: _userProfile.$9),
    ProjectDataModel(
        id: 20,
        projectName: 'Project Upsilon',
        title: 'Go Live',
        startDate: '2024-11-01',
        endDate: '2025-05-01',
        status: 'Pending',
        priority: 'Medium',
        imagePath: _userProfile.$10),
    ProjectDataModel(
        id: 21,
        projectName: 'Project Phi',
        title: 'Feedback Collection',
        startDate: '2024-12-01',
        endDate: '2025-06-01',
        status: 'Pending',
        priority: 'High',
        imagePath: _userProfile.$1),
    ProjectDataModel(
        id: 22,
        projectName: 'Project Chi',
        title: 'Improvements',
        startDate: '2025-01-01',
        endDate: '2025-07-01',
        status: 'InProgress',
        priority: 'Medium',
        imagePath: _userProfile.$2),
    ProjectDataModel(
        id: 23,
        projectName: 'Project Psi',
        title: 'Optimization',
        startDate: '2025-02-01',
        endDate: '2025-08-01',
        status: 'Pending',
        priority: 'Low',
        imagePath: _userProfile.$3),
    ProjectDataModel(
        id: 24,
        projectName: 'Project Omega',
        title: 'Final Review',
        startDate: '2025-03-01',
        endDate: '2025-09-01',
        status: 'Pending',
        priority: 'High',
        imagePath: _userProfile.$4),
    ProjectDataModel(
        id: 25,
        projectName: 'Project Alpha 2',
        title: 'Phase 2',
        startDate: '2025-04-01',
        endDate: '2025-10-01',
        status: 'InProgress',
        priority: 'Low',
        imagePath: _userProfile.$5),
    ProjectDataModel(
        id: 26,
        projectName: 'Project Beta 2',
        title: 'Development Phase 2',
        startDate: '2025-05-01',
        endDate: '2025-11-01',
        status: 'Pending',
        priority: 'Medium',
        imagePath: _userProfile.$6),
    ProjectDataModel(
        id: 27,
        projectName: 'Project Gamma 2',
        title: 'Testing Phase 2',
        startDate: '2025-06-01',
        endDate: '2025-12-01',
        status: 'Pending',
        priority: 'High',
        imagePath: _userProfile.$7),
    ProjectDataModel(
        id: 28,
        projectName: 'Project Delta 2',
        title: 'Deployment Phase 2',
        startDate: '2025-07-01',
        endDate: '2026-01-01',
        status: 'InProgress',
        priority: 'Low',
        imagePath: _userProfile.$8),
    ProjectDataModel(
        id: 29,
        projectName: 'Project Epsilon 2',
        title: 'Maintenance Phase 2',
        startDate: '2025-08-01',
        endDate: '2026-02-01',
        status: 'Pending',
        priority: 'High',
        imagePath: _userProfile.$9),
    ProjectDataModel(
        id: 30,
        projectName: 'Project Zeta 2',
        title: 'Planning Phase 2',
        startDate: '2025-09-01',
        endDate: '2026-03-01',
        status: 'New',
        priority: 'Medium',
        imagePath: _userProfile.$10),
    ProjectDataModel(
        id: 31,
        projectName: 'Project Eta 2',
        title: 'Execution Phase 2',
        startDate: '2025-10-01',
        endDate: '2026-04-01',
        status: 'Pending',
        priority: 'High',
        imagePath: _userProfile.$1),
    ProjectDataModel(
        id: 32,
        projectName: 'Project Theta 2',
        title: 'Closure Phase 2',
        startDate: '2025-11-01',
        endDate: '2026-05-01',
        status: 'InProgress',
        priority: 'Low',
        imagePath: _userProfile.$2),
    ProjectDataModel(
        id: 33,
        projectName: 'Project Iota 2',
        title: 'Design Phase 2',
        startDate: '2025-12-01',
        endDate: '2026-06-01',
        status: 'New',
        priority: 'High',
        imagePath: _userProfile.$3),
    ProjectDataModel(
        id: 34,
        projectName: 'Project Kappa 2',
        title: 'Review Phase 2',
        startDate: '2026-01-01',
        endDate: '2026-07-01',
        status: 'Pending',
        priority: 'Medium',
        imagePath: _userProfile.$4),
    ProjectDataModel(
        id: 35,
        projectName: 'Project Lambda 2',
        title: 'Conceptualization Phase 2',
        startDate: '2026-02-01',
        endDate: '2026-08-01',
        status: 'InProgress',
        priority: 'Low',
        imagePath: _userProfile.$5),
    ProjectDataModel(
        id: 36,
        projectName: 'Project Mu 2',
        title: 'Prototyping Phase 2',
        startDate: '2026-03-01',
        endDate: '2026-09-01',
        status: 'Pending',
        priority: 'High',
        imagePath: _userProfile.$6),
    ProjectDataModel(
        id: 37,
        projectName: 'Project Nu 2',
        title: 'Implementation Phase 2',
        startDate: '2026-04-01',
        endDate: '2026-10-01',
        status: 'New',
        priority: 'Medium',
        imagePath: _userProfile.$7),
    ProjectDataModel(
        id: 38,
        projectName: 'Project Xi 2',
        title: 'Execution Phase 3',
        startDate: '2026-05-01',
        endDate: '2026-11-01',
        status: 'InProgress',
        priority: 'Low',
        imagePath: _userProfile.$8),
    ProjectDataModel(
        id: 39,
        projectName: 'Project Omicron 2',
        title: 'Analysis Phase 2',
        startDate: '2026-06-01',
        endDate: '2026-12-01',
        status: 'Pending',
        priority: 'High',
        imagePath: _userProfile.$9),
    ProjectDataModel(
        id: 40,
        projectName: 'Project Pi 2',
        title: 'System Integration Phase 2',
        startDate: '2026-07-01',
        endDate: '2027-01-01',
        status: 'New',
        priority: 'Medium',
        imagePath: _userProfile.$10),
    ProjectDataModel(
        id: 41,
        projectName: 'Project Rho 2',
        title: 'Verification Phase 2',
        startDate: '2026-08-01',
        endDate: '2027-02-01',
        status: 'Pending',
        priority: 'High',
        imagePath: _userProfile.$1),
    ProjectDataModel(
        id: 42,
        projectName: 'Project Sigma 2',
        title: 'Final Testing Phase 2',
        startDate: '2026-09-01',
        endDate: '2027-03-01',
        status: 'InProgress',
        priority: 'Low',
        imagePath: _userProfile.$2),
    ProjectDataModel(
        id: 43,
        projectName: 'Project Tau 2',
        title: 'Deployment Preparation Phase 2',
        startDate: '2026-10-01',
        endDate: '2027-04-01',
        status: 'Pending',
        priority: 'High',
        imagePath: _userProfile.$3),
    ProjectDataModel(
        id: 44,
        projectName: 'Project Upsilon 2',
        title: 'Go Live Phase 2',
        startDate: '2026-11-01',
        endDate: '2027-05-01',
        status: 'Pending',
        priority: 'Medium',
        imagePath: _userProfile.$4),
    ProjectDataModel(
        id: 45,
        projectName: 'Project Phi 2',
        title: 'Feedback Collection Phase 2',
        startDate: '2026-12-01',
        endDate: '2027-06-01',
        status: 'Pending',
        priority: 'High',
        imagePath: _userProfile.$5),
    ProjectDataModel(
        id: 46,
        projectName: 'Project Chi 2',
        title: 'Improvements Phase 2',
        startDate: '2027-01-01',
        endDate: '2027-07-01',
        status: 'InProgress',
        priority: 'Medium',
        imagePath: _userProfile.$6),
    ProjectDataModel(
        id: 47,
        projectName: 'Project Psi 2',
        title: 'Optimization Phase 2',
        startDate: '2027-02-01',
        endDate: '2027-08-01',
        status: 'Pending',
        priority: 'Low',
        imagePath: _userProfile.$7),
    ProjectDataModel(
        id: 48,
        projectName: 'Project Omega 2',
        title: 'Final Review Phase 2',
        startDate: '2027-03-01',
        endDate: '2027-09-01',
        status: 'New',
        priority: 'High',
        imagePath: _userProfile.$8),
    ProjectDataModel(
        id: 49,
        projectName: 'Project Alpha 3',
        title: 'Initial Phase 3',
        startDate: '2027-04-01',
        endDate: '2027-10-01',
        status: 'InProgress',
        priority: 'Low',
        imagePath: _userProfile.$9),
    ProjectDataModel(
        id: 50,
        projectName: 'Project Beta 3',
        title: 'Development Phase 3',
        startDate: '2027-05-01',
        endDate: '2027-11-01',
        status: 'Pending',
        priority: 'Medium',
        imagePath: _userProfile.$10),
  ];
}

const (
  String,
  String,
  String,
  String,
  String,
  String,
  String,
  String,
  String,
  String
) _userProfile = (
  'assets/images/static_images/avatars/person_images/person_image_01.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_02.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_03.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_04.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_05.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_06.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_07.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_08.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_09.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_10.jpeg',
);
