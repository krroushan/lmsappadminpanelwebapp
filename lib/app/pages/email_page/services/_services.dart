// 📦 Package imports:
import 'package:go_router/go_router.dart';

class EmailPageListener {
  EmailPageListener._(this._page);
  static EmailPageListener? _instance;

  static StatefulNavigationShell get page => _instance!._page;
  static set page(StatefulNavigationShell value) {
    if (_instance != null) {
      _instance!._page = value;
    }
  }

  factory EmailPageListener.initialize(StatefulNavigationShell page) {
    _instance ??= EmailPageListener._(page);
    return _instance!;
  }
  StatefulNavigationShell _page;
}
