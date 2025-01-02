// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../models/student/student.dart';

class StudentProfileDetailsWidget extends StatefulWidget {
  const StudentProfileDetailsWidget({
    super.key,
    required this.student,
    required double padding,
    required this.theme,
    required this.textTheme,
  }) : _padding = padding;

  final double _padding;
  final ThemeData theme;
  final TextTheme textTheme;
  final Student student;

  @override
  State<StudentProfileDetailsWidget> createState() => _StudentProfileDetailsWidgetState();
}

class _StudentProfileDetailsWidgetState extends State<StudentProfileDetailsWidget> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 140,
          width: MediaQuery.of(context).size.width,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://bbose.online/wp-content/uploads/2024/12/student-1.jpg'),
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
              opacity: 0.3,
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.color),
            ),
            //color: Colors.grey,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
          ),
          child: Image.network('https://bbose.online/wp-content/uploads/2024/12/student-1.jpg', fit: BoxFit.fitHeight, alignment: Alignment.bottomCenter,),
        ),
        //const SizedBox(height: 70),
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
                _buildProfileDetailRow('Name', widget.student.fullName),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                //Father Name
                _buildProfileDetailRow('Father Name', widget.student.fatherName),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                //Father Occupation
                _buildProfileDetailRow('Father Occupation', widget.student.fatherOccupation),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                //Mother Name
                _buildProfileDetailRow('Mother Name', widget.student.motherName),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                //Email
                _buildProfileDetailRow('Email', widget.student.email),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                //Phone Number
                _buildProfileDetailRow('Phone Number', widget.student.phoneNumber),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                //Alternate Phone Number
                _buildProfileDetailRow('Alternate Phone Number', widget.student.alternatePhoneNumber ?? ''),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                //Roll No
                _buildProfileDetailRow('Roll No', widget.student.rollNo),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                //Adhar Number
                _buildProfileDetailRow('Adhar Number', widget.student.adharNumber),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                //Date of Birth
                _buildProfileDetailRow('Date of Birth', widget.student.dateOfBirth.toString()),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                //Gender
                _buildProfileDetailRow('Gender', widget.student.gender),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                //Category
                _buildProfileDetailRow('Category', widget.student.category),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                //Disability
                _buildProfileDetailRow('Disability', widget.student.disability),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                //Type of Institution
                _buildProfileDetailRow('Type of Institution', widget.student.typeOfInstitution),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                //Board
                _buildProfileDetailRow('Board', widget.student.board.name),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                //Class
                _buildProfileDetailRow('Class', widget.student.classInfo.name),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                
              ],
            ),
          ),
        ),
      ],
    );
  }

}