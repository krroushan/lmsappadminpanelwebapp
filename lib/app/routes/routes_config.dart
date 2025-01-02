//routes config class

abstract class RoutesConfig {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String students = '$dashboard/students/all-students';
  static const String teachers = '$dashboard/teachers/all-teachers';
}
