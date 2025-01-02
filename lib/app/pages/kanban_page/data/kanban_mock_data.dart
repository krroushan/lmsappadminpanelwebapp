part of '../kanban_view.dart';

class KanbanTaskItem extends AppFlowyGroupItem {
  final String taskId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<TaskEmployee> users;

  KanbanTaskItem(
    this.taskId, {
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.users,
  });

  @override
  String get id => taskId;

  @override
  String toString() {
    return 'KanbanTaskItem('
        '$taskId,'
        'title: $title,'
        'description: $description,'
        'startDate:$startDate,'
        'endDate:$endDate,'
        'users: ${users.map((e) => e.toString())}'
        ')';
  }
}

class TaskEmployee {
  final DateTime registeredOn;
  final String userName;
  final String imagePath;
  final String email;
  final String phoneNumber;
  final String position;
  final bool isActive;

  const TaskEmployee({
    required this.registeredOn,
    required this.userName,
    required this.imagePath,
    required this.email,
    required this.phoneNumber,
    required this.position,
    required this.isActive,
  });

  @override
  String toString() {
    return 'TaskEmployee { '
        'registeredOn: $registeredOn, '
        'userName: $userName, '
        'imagePath: $imagePath, '
        'email: $email, '
        'phoneNumber: $phoneNumber, '
        'position: $position, '
        'isActive: $isActive '
        '}';
  }
}

final List<TaskEmployee> taskEmployee = [
  TaskEmployee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Hank Murazik',
    imagePath: _userProfile.$1,
    email: 'doormat@att.net',
    phoneNumber: '(316) 555-0116',
    position: 'UI/UX Designer',
    isActive: false,
  ),
  TaskEmployee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Dena Harber',
    imagePath: _userProfile.$2,
    email: 'hwestiii@mac.com',
    phoneNumber: '(208) 555-0112',
    position: 'UI/UX Designer',
    isActive: false,
  ),
  TaskEmployee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Wava Nikolaus',
    imagePath: _userProfile.$3,
    email: 'adamk@yahoo.com',
    phoneNumber: '(303) 555-0105',
    position: 'UI/UX Designer',
    isActive: false,
  ),
  TaskEmployee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Josefina Brekke',
    imagePath: _userProfile.$4,
    email: 'sumdumass@gmail.com',
    phoneNumber: '(219) 555-0114',
    position: 'Flutter Developer ',
    isActive: false,
  ),
  TaskEmployee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Monserrat Gibson',
    imagePath: _userProfile.$5,
    email: 'kspiteri@live.com',
    phoneNumber: '(319) 555-0115',
    position: 'Flutter Developer ',
    isActive: false,
  ),
  TaskEmployee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Noemy MacGyver',
    imagePath: _userProfile.$6,
    email: 'sinclair@att.net',
    phoneNumber: '(405) 555-0128',
    position: 'Flutter Developer ',
    isActive: false,
  ),
  TaskEmployee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Mathilde Witting',
    imagePath: _userProfile.$7,
    email: 'crowemojo@hotmail.com',
    phoneNumber: '(702) 555-0122',
    position: 'Flutter Developer ',
    isActive: false,
  ),
  TaskEmployee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Suzanne Medhurst',
    imagePath: _userProfile.$8,
    email: 'mobileip@mac.com',
    phoneNumber: '(252) 555-0126',
    position: 'Frontend Developer ',
    isActive: false,
  ),
  TaskEmployee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Adeline Schinner',
    imagePath: _userProfile.$9,
    email: 'dgatwood@msn.com',
    phoneNumber: '(629) 555-0129',
    position: 'Frontend Developer ',
    isActive: false,
  ),
  TaskEmployee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Adeline Schinner',
    imagePath: _userProfile.$10,
    email: 'bockelboy@att.net',
    phoneNumber: '(207) 555-0119',
    position: 'Frontend Developer ',
    isActive: false,
  ),
];

List<KanbanTaskItem> get tasks => [
      KanbanTaskItem(
        generateRandomString(),
        title: l.S.current.businessDashboard,
        //'Business Dashboard',
        description: l.S.current.loremIpsumDolorSitAmet,
        //'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore',
        startDate: DateTime(2024, 07, 18),
        endDate: DateTime(2024, 08, 22),
        users: taskEmployee.take(5).toList(),
      ),
      KanbanTaskItem(
        generateRandomString(),
        title: l.S.current.businessDashboard,
        //'Business Dashboard',
        description: l.S.current.loremIpsumDolorSitAmet,
        //'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore',
        startDate: DateTime(2024, 07, 18),
        endDate: DateTime(2024, 08, 22),
        users: taskEmployee.take(5).toList(),
      ),
      KanbanTaskItem(
        generateRandomString(),
        title: l.S.current.businessDashboard,
        //'Business Dashboard',
        description: l.S.current.loremIpsumDolorSitAmet,
        //'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore',
        startDate: DateTime(2024, 07, 18),
        endDate: DateTime(2024, 08, 22),
        users: taskEmployee.take(5).toList(),
      ),
      KanbanTaskItem(
        generateRandomString(),
        title: l.S.current.businessDashboard,
        //'Business Dashboard',
        description: l.S.current.loremIpsumDolorSitAmet,
        //'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore',
        startDate: DateTime(2024, 07, 18),
        endDate: DateTime(2024, 08, 22),
        users: taskEmployee.take(5).toList(),
      ),
      KanbanTaskItem(
        generateRandomString(),
        title: l.S.current.businessDashboard,
        //'Business Dashboard',
        description: l.S.current.loremIpsumDolorSitAmet,
        //'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore',
        startDate: DateTime(2024, 07, 18),
        endDate: DateTime(2024, 08, 22),
        users: taskEmployee.take(5).toList(),
      )
    ];

String generateRandomString({int length = 8}) {
  const characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = math.Random();
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => characters.codeUnitAt(
        random.nextInt(characters.length),
      ),
    ),
  );
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
