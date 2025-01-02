// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/helpers/fuctions/_get_image.dart';
import '../../../models/student_data_model.dart';

class UserProfileDetailsWidget extends StatefulWidget {
  const UserProfileDetailsWidget({
    super.key,
    required this.userProfile,
    required double padding,
    required this.theme,
    required this.textTheme,
  }) : _padding = padding;

  final double _padding;
  final ThemeData theme;
  final TextTheme textTheme;
  final StudentDataModel userProfile;

  @override
  State<UserProfileDetailsWidget> createState() => _UserProfileDetailsWidgetState();
}

class _UserProfileDetailsWidgetState extends State<UserProfileDetailsWidget> {
  Widget _buildProfileDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.all(widget._padding),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: widget.textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Text(
                  ':',
                  style: widget.textTheme.bodyMedium,
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: widget.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
          ),
          child: getImageType('', fit: BoxFit.cover, alignment: Alignment.bottomCenter),
        ),
        const SizedBox(height: 70),
        Padding(
          padding: EdgeInsets.all(widget._padding),
          child: Container(
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: widget.theme.colorScheme.outline,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileDetailRow('${lang.fullName}', widget.userProfile.fullName),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow(lang.email, widget.userProfile.email),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow(lang.phoneNumber, widget.userProfile.rollNo),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow(lang.registrationDate, widget.userProfile.classId),
              ],
            ),
          ),
        ),
      ],
    );
  }
}