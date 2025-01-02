// 🎯 Dart imports:
import 'dart:io';

class DemoChat {
  static List<ChatModel> chatList = [
    ChatModel(
        text: 'Hello, we are trying to design UI/UX for app',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        isSentByMe: false),
    ChatModel(
        text: 'Oh, Hello Angela Young',
        date: DateTime.now().subtract(const Duration(hours: 1)),
        isSentByMe: true),
    ChatModel(
        text: 'At first i need to know about your project details',
        date: DateTime.now().subtract(const Duration(hours: 1)),
        isSentByMe: true),
    ChatModel(
        text: 'Yes sure, please wait',
        date: DateTime.now().subtract(const Duration(minutes: 5)),
        isSentByMe: false),
    ChatModel(
        text: 'Can we talk about the project other platfrom',
        date: DateTime.now().subtract(const Duration(minutes: 1)),
        isSentByMe: true),
  ];
}

class ChatModel {
  final File? file;
  final String? text;
  final DateTime date;
  final bool isSentByMe;
  final String? senderImage;

  ChatModel(
      {this.file,
      this.text,
      required this.date,
      required this.isSentByMe,
      this.senderImage});
}

class UserModel {
  String? influencerImage;
  String influencerName;
  bool isGroup;
  bool isPublic;

  UserModel({
    this.influencerImage,
    required this.influencerName,
    required this.isGroup,
    required this.isPublic,
  });
}

class MaanDemoGig {
  static List<UserModel> usersList = [
    UserModel(
        isGroup: false,
        isPublic: false,
        influencerName: 'Devon Lane',
        influencerImage: _userProfile.$1),
    UserModel(
        isGroup: false,
        isPublic: false,
        influencerName: 'Marvin McKinney',
        influencerImage: _userProfile.$2),
    UserModel(
        isPublic: true,
        isGroup: false,
        influencerName: 'Kristin Watson',
        influencerImage: _userProfile.$3),
    UserModel(
        isPublic: true,
        isGroup: false,
        influencerName: 'Arlene McCoy',
        influencerImage: _userProfile.$4),
    UserModel(
        isPublic: true,
        isGroup: false,
        influencerName: 'Albert Flores',
        influencerImage: _userProfile.$5),
    UserModel(
        isPublic: true,
        isGroup: false,
        influencerName: 'Jenny Wilson',
        influencerImage: _userProfile.$6),
    UserModel(
        isPublic: true,
        isGroup: false,
        influencerName: 'Dianne Russell',
        influencerImage: _userProfile.$7),
    UserModel(
        isPublic: true,
        isGroup: false,
        influencerName: 'Jane Cooper',
        influencerImage: _userProfile.$8),
    UserModel(
        isPublic: true,
        isGroup: false,
        influencerName: 'Brooklyn Simmons',
        influencerImage: _userProfile.$9),
    UserModel(
        isPublic: false,
        isGroup: true,
        influencerName: 'Ui/Ux Designers',
        influencerImage: _userProfile.$10),
    UserModel(
        isPublic: false,
        isGroup: true,
        influencerName: 'Flutter Devs',
        influencerImage: _userProfile.$1),
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
