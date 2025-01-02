part of '../dragndrop_view.dart';

class Employee {
  final DateTime registeredOn;
  final String userName;
  final String imagePath;
  final String email;
  final String phoneNumber;
  final String position;
  final bool isActive;

  const Employee({
    required this.registeredOn,
    required this.userName,
    required this.imagePath,
    required this.email,
    required this.phoneNumber,
    required this.position,
    required this.isActive,
  });
}

final List<Employee> employees = [
  Employee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Hank Murazik',
    imagePath:
        'assets/images/static_images/avatars/person_images/person_image_01.jpeg',
    email: 'doormat@att.net',
    phoneNumber: '(316) 555-0116',
    position: 'UI/UX Designer',
    isActive: true,
  ),
  Employee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Dena Harber',
    imagePath:
        'assets/images/static_images/avatars/person_images/person_image_02.jpeg',
    email: 'hwestiii@mac.com',
    phoneNumber: '(208) 555-0112',
    position: 'UI/UX Designer',
    isActive: false,
  ),
  Employee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Wava Nikolaus',
    imagePath:
        'assets/images/static_images/avatars/person_images/person_image_03.jpeg',
    email: 'adamk@yahoo.com',
    phoneNumber: '(303) 555-0105',
    position: 'UI/UX Designer',
    isActive: true,
  ),
  Employee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Josefina Brekke',
    imagePath:
        'assets/images/static_images/avatars/person_images/person_image_04.jpeg',
    email: 'sumdumass@gmail.com',
    phoneNumber: '(219) 555-0114',
    position: 'Flutter Developer ',
    isActive: false,
  ),
  Employee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Monserrat Gibson',
    imagePath:
        'assets/images/static_images/avatars/person_images/person_image_05.jpeg',
    email: 'kspiteri@live.com',
    phoneNumber: '(319) 555-0115',
    position: 'Flutter Developer ',
    isActive: false,
  ),
  Employee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Noemy MacGyver',
    imagePath:
        'assets/images/static_images/avatars/person_images/person_image_06.jpeg',
    email: 'sinclair@att.net',
    phoneNumber: '(405) 555-0128',
    position: 'Flutter Developer ',
    isActive: true,
  ),
  Employee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Mathilde Witting',
    imagePath:
        'assets/images/static_images/avatars/person_images/person_image_07.jpeg',
    email: 'crowemojo@hotmail.com',
    phoneNumber: '(702) 555-0122',
    position: 'Flutter Developer ',
    isActive: false,
  ),
  Employee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Suzanne Medhurst',
    imagePath:
        'assets/images/static_images/avatars/person_images/person_image_08.jpeg',
    email: 'mobileip@mac.com',
    phoneNumber: '(252) 555-0126',
    position: 'Frontend Developer ',
    isActive: false,
  ),
  Employee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Adeline Schinner',
    imagePath:
        'assets/images/static_images/avatars/person_images/person_image_09.jpeg',
    email: 'dgatwood@msn.com',
    phoneNumber: '(629) 555-0129',
    position: 'Frontend Developer ',
    isActive: false,
  ),
  Employee(
    registeredOn: DateTime(2021, 07, 22),
    userName: 'Adeline Schinner',
    imagePath:
        'assets/images/static_images/avatars/person_images/person_image_10.jpeg',
    email: 'bockelboy@att.net',
    phoneNumber: '(207) 555-0119',
    position: 'Frontend Developer ',
    isActive: false,
  ),
];
