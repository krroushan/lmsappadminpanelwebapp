import 'package:flutter/material.dart';
import '../models/student/student.dart';
import '../core/theme/_app_colors.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onView;

  const StudentCard({
    super.key,
    required this.student,
    required this.onDelete,
    required this.onEdit,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student Avatar/Header
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: theme.primaryColor.withOpacity(0.2),
                child: Text(
                  student.fullName.substring(0, 1).toUpperCase(),
                  style: textTheme.headlineMedium?.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ),
          ),
          // Student Info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  student.email,
                  style: textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AcnooAppColors.kSuccess.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    student.classInfo.name ?? 'No Class',
                    style: textTheme.bodySmall?.copyWith(
                      color: AcnooAppColors.kSuccess,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onView,
                  icon: const Icon(Icons.visibility, color: AcnooAppColors.kDark3),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, color: AcnooAppColors.kInfo),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: AcnooAppColors.kError),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 