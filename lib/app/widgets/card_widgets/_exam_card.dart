import '../../models/exam/get_exam.dart';
import '../../core/theme/_app_colors.dart';
import 'package:flutter/material.dart';

class ExamCard extends StatefulWidget {
  const ExamCard({
    super.key,
    required this.exam,
    required this.onDelete,
    required this.onEdit,
    required this.onView,
  });

  final GetExam exam;
  final Future<void> Function(String) onDelete;
  final Function(GetExam) onEdit;
  final Function(String) onView;

  @override
  State<ExamCard> createState() => _ExamCardState();
}

class _ExamCardState extends State<ExamCard> {
  bool isHovering = false;

  void changeHoverState(bool value) {
    setState(() => isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return MouseRegion(
      onEnter: (event) => changeHoverState(true),
      onExit: (event) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: Material(
        color: _theme.colorScheme.primaryContainer,
        elevation: isHovering ? 4.75 : 0,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              color: _theme.colorScheme.primary.withOpacity(0.1),
              child: Center(
                child: Icon(
                  Icons.assignment,
                  size: 64,
                  color: _theme.colorScheme.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildChip(widget.exam.subject.name, Colors.blue),
                      const SizedBox(width: 4),
                      _buildChip(widget.exam.classInfo.name, Colors.green),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.exam.title,
                    style: _theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoItem(Icons.timer, '${widget.exam.duration} mins'),
                      const SizedBox(width: 16),
                      _buildInfoItem(Icons.grade, '${widget.exam.totalMarks} marks'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => widget.onView(widget.exam.id),
                        icon: const Icon(Icons.visibility),
                        color: AcnooAppColors.kDark3,
                      ),
                      IconButton(
                        onPressed: () => widget.onEdit(widget.exam),
                        icon: const Icon(Icons.edit),
                        color: AcnooAppColors.kInfo,
                      ),
                      IconButton(
                        onPressed: () => widget.onDelete(widget.exam.id),
                        icon: const Icon(Icons.delete),
                        color: AcnooAppColors.kError,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}