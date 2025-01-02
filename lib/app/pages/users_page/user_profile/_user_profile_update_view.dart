// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import 'package:acnoo_flutter_admin_panel/app/pages/users_page/user_profile/user_profile_details_widget.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/users_page/user_profile/user_profile_update_widget.dart';
import '../../../../generated/l10n.dart' as l;
import '../../../core/helpers/fuctions/_get_image.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';

class UserProfileUpdateView extends StatelessWidget {
  const UserProfileUpdateView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = l.S.of(context);
    final textTheme = theme.textTheme;
    final _padding = responsiveValue<double>(
      context,
      xs: 16 / 2,
      sm: 16 / 2,
      md: 16 / 2,
      lg: 24 / 2,
    );
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_padding),
        child: ResponsiveGridCol(
          lg: 12,
          child: Padding(
                padding: EdgeInsets.all(_padding),
                child: ShadowContainer(
                  contentPadding: EdgeInsets.all(_padding),
                  headerText: 'Edit Student',
                child: UserProfileUpdateWidget(textTheme: textTheme),
              ),
            ),
          ),
        ),
      );
  }
}
