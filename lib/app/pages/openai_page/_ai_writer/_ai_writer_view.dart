// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../widgets/widgets.dart';
import 'components/_components.dart';

class AiWriterView extends StatelessWidget {
  const AiWriterView({super.key});

  @override
  Widget build(BuildContext context) {
    final _padding = responsiveValue<double>(context, xs: 16, lg: 24);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(_padding / 2.5),
        child: ResponsiveGridRow(
          rowSegments: 100,
          children: [
            ResponsiveGridCol(
              lg: 40,
              xs: 100,
              child: Padding(
                padding: EdgeInsetsDirectional.all(_padding / 2.5),
                child: ShadowContainer(
                  showHeader: false,
                  contentPadding: EdgeInsetsDirectional.all(_padding),
                  child: const AIWriterPromptForm(),
                ),
              ),
            ),
            ResponsiveGridCol(
              lg: 60,
              xs: 100,
              child: Padding(
                padding: EdgeInsetsDirectional.all(_padding / 2.5),
                child: ShadowContainer(
                  showHeader: false,
                  contentPadding: EdgeInsetsDirectional.all(_padding),
                  customHeader: Row(
                    children: [
                      Flexible(
                        child: TextFormField(),
                      ),
                    ],
                  ),
                  child: const GeneratedDocumentField(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
