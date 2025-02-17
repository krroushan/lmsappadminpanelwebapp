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
import '../../core/api_service/study_material_service.dart';
import '../../models/study-material/study-material.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class StudyMaterialListView extends StatefulWidget {
  const StudyMaterialListView({super.key});

  @override
  State<StudyMaterialListView> createState() => _StudyMaterialListViewState();
}

class _StudyMaterialListViewState extends State<StudyMaterialListView> {
  List<StudyMaterial> _studyMaterials = [];
  int _totalStudyMaterials = 0;

  bool _isLoading = true;
  final StudyMaterialService _studyMaterialService = StudyMaterialService();

  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchStudyMaterials();
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
          title: const Text('Delete Study Material'),
          content: const Text('Do you want to delete this study material?'),
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

  Future<void> _deleteStudyMaterial(String studyMaterialId) async {
    // Show confirmation dialog before deleting
    bool? confirmDelete = await _showDeleteConfirmationDialog();
    if (confirmDelete == true) {
      try {
        await _studyMaterialService.deleteStudyMaterial(studyMaterialId, token);
        // Optionally, refresh the class list after deletion
        await _fetchStudyMaterials();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Study Material deleted successfully')),
        );
      } catch (e) {
        // Handle error appropriately
        logger.e('Error deleting study material: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete study material: $e')),
        );
      }
    }
  }

  // New method to fetch Class data from the API
  Future<void> _fetchStudyMaterials() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<StudyMaterial> response = await _studyMaterialService.fetchAllStudyMaterials(token); // Fetch the response
      logger.i('Study Materials fetched successfullyname: ${response[0].title}');
      setState(() {
            _studyMaterials = response;
        _totalStudyMaterials = response.length;
        _isLoading = false;
      });
      
          logger.i('Study Materials fetched successfullylength: ${_studyMaterials.length}');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      logger.e('Failed to load study materials: $e');
      throw Exception('Failed to load study materials');
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
          context.go('/dashboard/study-materials/add-study-material');
        });
      },
      label: Text(
        'Add New Study Material',
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
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Search Study Material...',
        hintStyle: textTheme.bodySmall,
        suffixIcon: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: AcnooAppColors.kPrimary700,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: const Icon(IconlyLight.search, color: AcnooAppColors.kWhiteColor),
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
      child: _studyMaterials.isEmpty
          ? Center(child: Text('No study materials available.'))
          : DataTable(
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
              rows: _studyMaterials.asMap().entries.map(
                (entry) {
                  final index = entry.key + 1;
                  final studyMaterialInfo = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text(index.toString())),
                      DataCell(Text(studyMaterialInfo.title)),
                      DataCell(Text(studyMaterialInfo.teacher?.fullName ?? '')),
                      DataCell(Text(studyMaterialInfo.subject?.name ?? '')),
                      DataCell(Text(studyMaterialInfo.classInfo?.name ?? '')),
                      DataCell(
                        Row(
                          children: [
                            // IconButton(onPressed: () {
                            //   context.go('/dashboard/study-materials/study-material-profile', extra: studyMaterialInfo.id);
                            // }, icon: const Icon(Icons.visibility, color: AcnooAppColors.kDark3,)),
                            IconButton(onPressed: () {
                              context.go('/dashboard/study-materials/update-study-material/${studyMaterialInfo.id}');
                            }, icon: const Icon(Icons.edit, color: AcnooAppColors.kInfo,)),
                            IconButton(onPressed: () async {
                              await _deleteStudyMaterial(studyMaterialInfo.id);
                            }, icon: const Icon(Icons.delete, color: AcnooAppColors.kError,)),
                            IconButton(onPressed: () {
                              context.go('/dashboard/study-materials/view-pdf/${studyMaterialInfo.id}');
                            }, icon: const Icon(Icons.file_present, color: AcnooAppColors.kSuccess,)),
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
