// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:go_router/go_router.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../open_ai_page.dart';
import 'components/_components.dart';
import 'services/_services.dart';

export 'pages/pages.dart';
export 'services/_services.dart';

class AiChatView extends StatelessWidget {
  const AiChatView({super.key, required this.page});

  final StatefulNavigationShell page;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _mqSize = MediaQuery.sizeOf(context);
    final _isDesktop = _mqSize.width >= 1240;
    // final _isTablet = _mqSize.width >= 1080 && !_isDesktop;

    final _padding = responsiveValue<double>(context, xs: 16, lg: 24);
    AIChatPageListener.page = page;

    return Scaffold(
      body: Container(
        width: double.maxFinite,
        margin: EdgeInsets.all(_padding),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: _theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (_isDesktop) AiChatSidebar(page: page),
            Expanded(child: page)
          ],
        ),
      ),
    );
  }
}
