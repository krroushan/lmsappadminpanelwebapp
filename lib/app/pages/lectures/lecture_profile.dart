// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../models/lecture/lecture.dart';

class LectureProfileDetailsWidget extends StatefulWidget {
  const LectureProfileDetailsWidget({
    super.key,
    required this.lecture,
    required double padding,
    required this.theme,
    required this.textTheme,
  }) : _padding = padding;

  final double _padding;
  final ThemeData theme;
  final TextTheme textTheme;
  final Lecture lecture;

  @override
  State<LectureProfileDetailsWidget> createState() => _LectureProfileDetailsWidgetState();
}

class _LectureProfileDetailsWidgetState extends State<LectureProfileDetailsWidget> {
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
          height: 300,
          width: MediaQuery.of(context).size.width,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: NetworkImage('https://apkobi.com/uploads/lectures/thumbnails/${widget.lecture.thumbnail}',),
            //   fit: BoxFit.cover,
            //   alignment: Alignment.bottomCenter,
            //   opacity: 0.3,
            //   colorFilter: const ColorFilter.mode(Colors.black, BlendMode.color),
            // ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
          ),
          child: Image.network(
            'https://apkobi.com/uploads/lectures/thumbnails/${widget.lecture.thumbnail}',
            fit: BoxFit.fitHeight,
            alignment: Alignment.bottomCenter,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: widget.theme.colorScheme.error,
                ),
              );
            },
          ),
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
                _buildProfileDetailRow('Title', widget.lecture.title),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow('Description', widget.lecture.description),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow('Lecture Type', widget.lecture.lectureType),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow('Class', widget.lecture.classInfo?.name ?? ''),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow('Subject', widget.lecture.subject?.name ?? ''),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow('Teacher', widget.lecture.teacher?.fullName ?? ''),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow('Start Date', widget.lecture.startDate.toString()),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow('Start Time', widget.lecture.startTime.toString()),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow('Stream ID', widget.lecture.streamId),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow('Thumbnail', widget.lecture.thumbnail),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow('Created At', widget.lecture.createdAt.toString()),
                Divider(
                  color: widget.theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow('Updated At', widget.lecture.updatedAt.toString()),
              ],
            ),
          ),
        ),
      ],
    );
  }

}