// 🐦 Flutter imports:
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Import this for kIsWeb

import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../core/api_config/api_config.dart';
import '../../widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_service/subject_service.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import '../../core/api_service/class_service.dart';
import '../../models/classes/class_info.dart';
import '../../core/helpers/field_styles/field_styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:logger/logger.dart';

class EditSubjectView extends StatefulWidget {
  final String subjectId;
  const EditSubjectView({super.key, required this.subjectId});


  @override
  State<EditSubjectView> createState() => _EditSubjectViewState();

}

class _EditSubjectViewState extends State<EditSubjectView> {
  var logger = Logger();


  final browserDefaultFormKey = GlobalKey<FormState>();
  bool isBrowserDefaultChecked = false;

  bool _isLoading = false;

  PlatformFile? selectedImage;
  String? selectedImagePath;
  Uint8List? selectedImageBytes;
  String? mimeType;
  int? imageSize;

  final customFormKey = GlobalKey<FormState>();
  bool isCustomFormChecked = false;
  String token = '';

  String _classId = "";
  String subjectImageUrl = '';

  final _subjectService = SubjectService();

  // Declare TextEditingControllers
  final TextEditingController subjectNameController = TextEditingController();
  final TextEditingController subjectDescriptionController = TextEditingController();
  final TextEditingController subjectImageController = TextEditingController();

  // Add new state variable for upload progress
  double _uploadProgress = 0;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result == null) {
      return;
    }

    setState(() {
      _isLoading = true;
      _uploadProgress = 0; // Reset progress when starting new upload
    });

    try {
      // Upload image immediately after selection
      String imageUrl = await _subjectService.uploadSubjectImage(
        result.files.first.bytes!,
        result.files.first.name,
        subjectNameController.text,
        subjectImageController.text,
        onProgress: (progress) {
          setState(() {
            _uploadProgress = progress;
          });
        },
      );
      
      // Update the controller with new image URL
      subjectImageController.text = imageUrl;
      
      setState(() {
        selectedImage = result.files.first;
        mimeType = selectedImage!.extension != null
            ? 'image/${selectedImage!.extension}'
            : 'unknown';
        imageSize = selectedImage!.size;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
        _uploadProgress = 0; // Reset progress when done
      });
    }
  }

// fetch existing subject data
Future<void> _fetchExistingSubject() async {
  // Wait for class list to be loaded first
  await _fetchClassList();
  
  final subject = await _subjectService.fetchSubjectById(widget.subjectId, token);
  if (mounted) {
    setState(() {
      subjectNameController.text = subject.name;
      _classId = subject.classInfo?.id ?? '';
      subjectDescriptionController.text = subject.description;
      subjectImageUrl = subject.subjectImage;
      subjectImageController.text = subject.subjectImage;
    });
  }
}

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchClassList();
    _fetchExistingSubject();
  }


// class service
  final _classService = ClassService();

// class list
  List<ClassInfo> _classList = [];

  // fetch class list
  Future<void> _fetchClassList() async {
    final classList = await _classService.fetchAllClasses(token);
    setState(() {
      _classList = classList;

    });
  }

  Future<void> _updateSubject() async {
    setState(() {
      _isLoading = true;  
    });

    try {
      // No need to upload image here since it's already uploaded
      final success = await _subjectService.updateSubject(
        widget.subjectId,
        subjectNameController.text,
        subjectDescriptionController.text,
        _classId,
        subjectImageController.text, // Use the stored image URL
        token,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Subject updated successfully')),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating subject: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const _lg = 4;
    const _md = 6;
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
            key: browserDefaultFormKey,
            child: ShadowContainer(
              headerText: 'Edit Subject',
              child: ResponsiveGridRow(
                children: [
                  // Subject Name
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Subject Name',
                        inputField: TextFormField(
                          controller: subjectNameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter subject name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter subject name';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                  // Classes
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Class',
                        inputField: DropdownButtonFormField2(
                          menuItemStyleData: _dropdownStyle.menuItemStyle,
                          buttonStyleData: _dropdownStyle.buttonStyle,
                          iconStyleData: _dropdownStyle.iconStyle,
                          dropdownStyleData: _dropdownStyle.dropdownStyle,
                          hint: const Text('Select Class'),
                          value: _classId.isNotEmpty ? _classId : null,
                          items: _classList
                              .map((classInfo) => DropdownMenuItem(
                                    value: classInfo.id,
                                    child: Text(classInfo.name),
                                  ))

                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _classId = value as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // Subject Description
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Subject Description',
                        inputField: TextFormField(
                          controller: subjectDescriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Enter subject description',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter subject description';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                  // Subject Image
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Subject Image',
                        inputField: Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _isLoading ? null : () async {
                                await _pickImage();
                              },
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Upload Image'),
                            ),
                            if (_isLoading) ...[
                              const SizedBox(height: 8),
                              LinearProgressIndicator(value: _uploadProgress),
                              Text('${(_uploadProgress * 100).toStringAsFixed(0)}%'),
                            ],
                            const SizedBox(height: 16),
                            // Display either the selected image or the existing image
                            if (selectedImage != null) ...[
                              Image.memory(
                                selectedImage!.bytes!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 8),
                              Text('Image Name: ${selectedImage!.name}'),
                              Text('MIME Type: $mimeType'),
                              Text('Image Size: $imageSize bytes'),
                            ] else if (subjectImageController.text.isNotEmpty) ...[
                              Image.network(
                                '${ApiConfig.subjectImageUrl}$subjectImageUrl',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text('Error loading image');
                                },
                              ),
                              const SizedBox(height: 8),
                              Text('Current Image URL: $subjectImageUrl'),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Save Form Button
                  ResponsiveGridCol(
                    lg: 12,
                    md: 3,
                    xl: 2,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          if (browserDefaultFormKey.currentState?.validate() ==
                              true) {
                            _updateSubject();
                          }
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Update Subject'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: _sizeInfo.innerSpacing),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    subjectNameController.dispose();
    subjectDescriptionController.dispose();
    subjectImageController.dispose();
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
