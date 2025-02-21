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
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: widget.theme.colorScheme.outline.withOpacity(0.1),
          ),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: widget._padding * 1.5,
        vertical: widget._padding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: widget.textTheme.bodyLarge?.copyWith(
                color: widget.theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(
            ' : ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: widget.textTheme.bodyLarge?.copyWith(
                color: widget.theme.colorScheme.onSurface.withOpacity(0.8),
              ),
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
          padding: EdgeInsets.all(widget._padding * 2),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.theme.colorScheme.primary.withOpacity(0.5),
                widget.theme.colorScheme.primary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 120,
                    height: 140,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://bbose.online/wp-content/uploads/2024/12/student-1.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.student.fullName,
                          style: widget.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoText('Roll No: ${widget.student.rollNo}'),
                        _buildInfoText('Board: ${widget.student.board.name}'),
                        _buildInfoText('Class: ${widget.student.classInfo.name}'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(widget._padding),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(widget._padding * 1.5),
                  decoration: BoxDecoration(
                    color: widget.theme.colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: widget.theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Personal Details',
                        style: widget.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: widget.theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: widget.textTheme.titleMedium?.copyWith(
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
}