// 📦 Package imports:
import 'package:go_router/go_router.dart';

class AIChatPageListener {
  AIChatPageListener._(this._page);
  static AIChatPageListener? _instance;

  static StatefulNavigationShell get page => _instance!._page;
  static set page(StatefulNavigationShell value) {
    if (_instance != null) {
      _instance!._page = value;
    }
  }

  factory AIChatPageListener.initialize(StatefulNavigationShell page) {
    _instance ??= AIChatPageListener._(page);
    return _instance!;
  }
  StatefulNavigationShell _page;
}
