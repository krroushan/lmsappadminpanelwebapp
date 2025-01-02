// 🎯 Dart imports:

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../core/theme/_app_colors.dart';
import '../../widgets/widgets.dart';
import '../../core/api_service/lecture_service.dart';
import '../../models/lecture/lecture.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class LectureListView extends StatefulWidget {
  const LectureListView({super.key});

  @override
  State<LectureListView> createState() => _LectureListViewState();
}

class _LectureListViewState extends State<LectureListView> {
  List<Lecture> _lectures = [];
  int _totalLectures = 0;

  bool _isLoading = true;
  final LectureService _lectureService = LectureService();

  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchLectures();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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

  Future<void> _deleteLecture(String lectureId) async {
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

  // Search Query
  void _setSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
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

    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: _sizeInfo.padding,
        child: ShadowContainer(
          showHeader: false,
          contentPadding: EdgeInsets.zero,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final isMobile = constraints.maxWidth < 481;
                final isTablet =
                    constraints.maxWidth < 992 && constraints.maxWidth >= 481;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    isMobile
                        ? Padding(
                            padding: _sizeInfo.padding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Spacer(),
                                    addUserButton(textTheme),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                searchFormField(textTheme: textTheme),
                              ],
                            ),
                          )
                        : Padding(
                            padding: _sizeInfo.padding,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: searchFormField(textTheme: textTheme),
                                ),
                                Spacer(flex: isTablet || isMobile ? 1 : 2),
                                addUserButton(textTheme),
                              ],
                            ),
                          ),

                    // Data Table
                    isMobile || isTablet
                        ? RawScrollbar(
                            padding: const EdgeInsets.only(left: 18),
                            trackBorderColor: theme.colorScheme.surface,
                            trackVisibility: true,
                            scrollbarOrientation: ScrollbarOrientation.bottom,
                            controller: _scrollController,
                            thumbVisibility: true,
                            thickness: 8.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: constraints.maxWidth,
                                    ),
                                    child: userListDataTable(context),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: _isLoading ? const Center(child: CircularProgressIndicator(),) : userListDataTable(context),
                            ),
                          ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton addUserButton(TextTheme textTheme) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        setState(() {
          //_showFormDialog(context);
          context.go('/dashboard/lectures/add-lecture');
        });
      },
      label: Text(
        'Add New Lecture',
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconAlignment: IconAlignment.start,
      icon: const Icon(
        Icons.add_circle_outline_outlined,
        color: AcnooAppColors.kWhiteColor,
        size: 20.0,
      ),
    );
  }

  // Search Field
  TextFormField searchFormField({required TextTheme textTheme}) {
    final lang = l.S.of(context);
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        // hintText: 'Search...',
        hintText: '${lang.search}...',
        hintStyle: textTheme.bodySmall,
        suffixIcon: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: AcnooAppColors.kPrimary700,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child:
              const Icon(IconlyLight.search, color: AcnooAppColors.kWhiteColor),
        ),
      ),
      onChanged: (value) {
        _setSearchQuery(value);
      },
    );
  }

  // User List Data Table
  Theme userListDataTable(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Theme(
      data: ThemeData(
          dividerColor: theme.colorScheme.outline,
          dividerTheme: DividerThemeData(
            color: theme.colorScheme.outline,
          )),
      child: DataTable(
        checkboxHorizontalMargin: 16,
        dataRowMaxHeight: 70,
        headingTextStyle: textTheme.titleMedium,
        dataTextStyle: textTheme.bodySmall,
        headingRowColor: WidgetStateProperty.all(theme.colorScheme.surface),
        showBottomBorder: true,
        columns: const [
          DataColumn(label: Text('SN.')),
          DataColumn(label: Text('Title')),
          DataColumn(label: Text('Teacher')),
          DataColumn(label: Text('Subject')),
          DataColumn(label: Text('Class')),
          DataColumn(label: Text('Action')),
        ],
        rows: _lectures.asMap().entries.map(
          (entry) {
            final index = entry.key + 1;
            final lectureInfo = entry.value;
            logger.d('lectureInfo: ${lectureInfo.id}');
            return DataRow(
              cells: [
                DataCell(Text(index.toString())),
                DataCell(Text(lectureInfo.title)),
                DataCell(Text(lectureInfo.teacher.fullName)),
                DataCell(Text(lectureInfo.subject.name)),
                DataCell(Text(lectureInfo.classInfo.name)),
                DataCell(
                  Row(
                    children: [
                      IconButton(onPressed: () {
                        context.go('/dashboard/lectures/view-lecture/${lectureInfo.id}');
                      }, icon: const Icon(Icons.visibility, color: AcnooAppColors.kDark3,)),
                      IconButton(onPressed: () {
                        context.go('/dashboard/lectures/edit-lecture/${lectureInfo.id}');
                      }, icon: const Icon(Icons.edit, color: AcnooAppColors.kInfo,)),
                      IconButton(onPressed: () async {
                        await _deleteLecture(lectureInfo.id);
                      }, icon: const Icon(Icons.delete, color: AcnooAppColors.kError,)),
                      if(lectureInfo.lectureType == 'live')
                      IconButton(onPressed: () {
                        context.go('/dashboard/lectures/publish-live-stream/${lectureInfo.streamId}');
                      }, icon: const Icon(Icons.video_call, color: AcnooAppColors.kSuccess,)),
                      if(lectureInfo.lectureType == 'recorded')
                      IconButton(onPressed: () {
                        context.go('/dashboard/lectures/play-lecture/${lectureInfo.id}');
                      }, icon: const Icon(Icons.play_arrow, color: AcnooAppColors.kSuccess,)),  
                    ],
                  ),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}

// Size Info
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
