// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import 'components/_components.dart';

export 'pages/pages.dart';
export 'services/_services.dart';

class EmailView extends StatelessWidget {
  const EmailView({
    super.key,
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    final _mqSize = MediaQuery.sizeOf(context);
    final _isDesktop = _mqSize.width >= 1240;

    final _padding = responsiveValue<double>(context, xs: 16, lg: 24);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(_padding / 2.5),
        child: Row(
          children: [
            if (_isDesktop)
              Padding(
                padding: EdgeInsets.all(_padding / 2.5),
                child: const EmailSidebarWidget(),
              ),
            Expanded(
              flex: 30,
              child: Container(
                width: double.maxFinite,
                margin: EdgeInsets.all(_padding / 2.5),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
