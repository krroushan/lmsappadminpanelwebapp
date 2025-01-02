// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../widgets/widgets.dart';
import '../../core/api_service/lecture_service.dart';
import '../../models/lecture/lecture.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class LectureCardListView extends StatefulWidget {
  const LectureCardListView({super.key});

  @override
  State<LectureCardListView> createState() => _LectureCardListViewState();
}

class _LectureCardListViewState extends State<LectureCardListView> {

  List<Lecture> _lectures = [];
  int _totalLectures = 0;

  bool _isLoading = true;
  final LectureService _lectureService = LectureService();
  String token = '';

  Future<bool?> _showDeleteConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Lecture'),
          content: const Text('Do you want to delete this lecture?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteLecture(String? lectureId) async {
    if (lectureId == null) return;
    // Show confirmation dialog before deleting
    bool? confirmDelete = await _showDeleteConfirmationDialog();
    if (confirmDelete == true) {
      try {
        await _lectureService.deleteLecture(lectureId, token);
        // Optionally, refresh the class list after deletion
        await _fetchLectures();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lecture deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        // Handle error appropriately
        logger.e('Error deleting class: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete class: $e'),
          backgroundColor: Colors.red,),
        );
      }
    }
  }

  // New method to fetch Class data from the API
  Future<void> _fetchLectures() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Lecture> response = await _lectureService.fetchAllLectures(token); // Fetch the response
      logger.i('Lectures fetched successfullyname: ${response[0].title}');
      setState(() {
          _lectures = response;
        _totalLectures = response.length;
        _isLoading = false;
      });
      
        logger.i('Lectures fetched successfullylength: ${_lectures.length}');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      logger.e('Failed to load lectures: $e');
      throw Exception('Failed to load lectures');
    }
  }

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchLectures();
  }


  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        addAutomaticKeepAlives: false,
        padding: _sizeInfo.padding / 2.5,
        children: [
          // Card Image
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  (_sizeInfo.padding.horizontal / 2) / 2.5,
                  16,
                  (_sizeInfo.padding.horizontal / 2) / 2.5,
                  0,
                ),
                child: Text(
                  'Lectures',
                  style: _theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ResponsiveGridRow(
                children: _isLoading 
                  ? <ResponsiveGridCol>[
                      ResponsiveGridCol(
                        lg: 12, // Full width
                        md: 12,
                        sm: 12,
                        xs: 12,
                        child: Container(
                          height: 200, // Provide some height for the loading container
                          child: Center(
                            child: CircularProgressIndicator(
                              color: _theme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ]
                  : _lectures.asMap().entries.map(
                      (entry) => ResponsiveGridCol(
                        lg: 3,
                        md: 4,
                        sm: 12,
                        xs: 12,
                        child: Padding(
                          padding: _sizeInfo.padding / 2.5,
                          child: BlogCardWidget(
                            title: entry.value.title,
                            description: entry.value.description,
                            cardWidgetType: BlogCardWidgetType.contentBL,
                            image: NetworkImage('https://apkobi.com/uploads/lectures/thumbnails/${entry.value.thumbnail}'),
                            isLoading: false,
                            lectureId: entry.value.id,
                            createdBy: entry.value.teacher.fullName,
                            createdDate: entry.value.createdAt,
                            board: 'CBSE',
                            className: 'Class 10',
                            subject: 'Maths',
                            onDelete: _deleteLecture,
                          ),
                        ),
                      ),
                    ).toList(),
              ),
            ],
          ),
],
      ),
    );
  }
}

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}

