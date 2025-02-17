// 🐦 Flutter imports:
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // Import this for kIsWeb

import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import '../../core/api_service/class_service.dart';
import '../../models/classes/class_info.dart';
import '../../core/helpers/field_styles/field_styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:logger/logger.dart';
import '../../models/subject/subject.dart';
import '../../models/teacher/teacher.dart';
import '../../models/board/board.dart';
import '../../core/api_service/subject_service.dart';
import '../../core/api_service/teacher_service.dart';
import '../../core/api_service/syllabus_service.dart';
import '../../core/api_service/board_service.dart';

class PageSettingView extends StatefulWidget {
  const PageSettingView({super.key});

  @override
  State<PageSettingView> createState() => _PageSettingViewState();
}

class _PageSettingViewState extends State<PageSettingView> {
  var logger = Logger();

  final browserDefaultFormKey = GlobalKey<FormState>();
  bool isBrowserDefaultChecked = false;

  bool _isLoading = false;

  PlatformFile? selectedFile;
  String? selectedFilePath;
  Uint8List? selectedFileBytes;
  String? mimeType;
  int? fileSize;

  final customFormKey = GlobalKey<FormState>();
  bool isCustomFormChecked = false;
  String token = '';

  String _classId = "";
  String _subjectId = "";
  String _teacherId = "";
  String _boardId = "";

   // Declare TextEditingControllers
  final TextEditingController titleController = TextEditingController();

  final _syllabusService = SyllabusService();

  // Add new controllers for metadata fields
  final TextEditingController websiteTitleController = TextEditingController();
  final TextEditingController metaDescriptionController = TextEditingController();
  PlatformFile? websiteLogoFile;
  PlatformFile? websiteIconFile;

  // Add new controllers for page content
  final TextEditingController privacyPolicyController = TextEditingController();
  final TextEditingController termsConditionsController = TextEditingController();
  final TextEditingController contactUsController = TextEditingController();
  final TextEditingController aboutUsController = TextEditingController();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) {
      return;
    }

    setState(() {
      selectedFile = result.files.first;
      mimeType = selectedFile!.extension != null
          ? 'pdf/${selectedFile!.extension}'
          : 'unknown';
      fileSize = selectedFile!.size;
    });
    print("selectedFile: ${selectedFile!.bytes}");
  }

  // Add new method to pick logo/icon
  Future<void> _pickImage(bool isLogo) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (result == null) return;

    setState(() {
      if (isLogo) {
        websiteLogoFile = result.files.first;
      } else {
        websiteIconFile = result.files.first;
      }
    });
  }

  // Add method to save website settings
  Future<void> _saveWebsiteSettings() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Implement API call to save website settings
      // await _settingsService.updateWebsiteSettings(
      //   title: websiteTitleController.text,
      //   description: metaDescriptionController.text,
      //   logo: websiteLogoFile?.bytes,
      //   icon: websiteIconFile?.bytes,
      //   token: token,
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Website settings updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      logger.e('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Add method to save page settings
  Future<void> _savePageSettings() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Implement API call to save page settings
      // await _settingsService.updatePageSettings(
      //   privacyPolicy: privacyPolicyController.text,
      //   termsConditions: termsConditionsController.text,
      //   contactUs: contactUsController.text,
      //   aboutUs: aboutUsController.text,
      //   token: token,
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Page settings updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      logger.e('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    // Set teacher ID if user is a teacher
    if (authProvider.getRole == 'teacher') {
      _teacherId = authProvider.getUserId;
    }
    // Only fetch teacher list if user is not a teacher
  }


  @override
  Widget build(BuildContext context) {
    const _lg = 12;
    const _md = 12;
    final _dropdownStyle = AcnooDropdownStyle(context);

    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 992,
          value: _SizeInfo(
            fonstSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

  
    return Scaffold(
      body: ListView(
        padding: _sizeInfo.padding,
        children: [
          Form(
            key: GlobalKey<FormState>(),
            child: ShadowContainer(
              headerText: 'Page Settings',
              child: ResponsiveGridRow(
                children: [
                  // Privacy Policy
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Privacy Policy',
                        inputField: TextFormField(
                          controller: privacyPolicyController,
                          maxLines: 10,
                          decoration: const InputDecoration(
                            hintText: 'Enter privacy policy content',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Terms and Conditions
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Terms and Conditions',
                        inputField: TextFormField(
                          controller: termsConditionsController,
                          maxLines: 10,
                          decoration: const InputDecoration(
                            hintText: 'Enter terms and conditions content',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Contact Us
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Contact Us',
                        inputField: TextFormField(
                          controller: contactUsController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: 'Enter contact information',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // About Us
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'About Us',
                        inputField: TextFormField(
                          controller: aboutUsController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: 'Enter about us content',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Save Button
                  ResponsiveGridCol(
                    lg: 12,
                    md: 12,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _savePageSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Save Page Settings'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    titleController.dispose();
    websiteTitleController.dispose();
    metaDescriptionController.dispose();
    privacyPolicyController.dispose();
    termsConditionsController.dispose();
    contactUsController.dispose();
    aboutUsController.dispose();
    super.dispose();
  }
}

class _SizeInfo {
  final double? fonstSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.fonstSize,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}
