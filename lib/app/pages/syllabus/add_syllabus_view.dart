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
import '../../core/api_service/subject_service.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import '../../core/api_service/class_service.dart';
import '../../models/classes/class_info.dart';
import '../../core/helpers/field_styles/field_styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:logger/logger.dart';

class AddSyllabusView extends StatefulWidget {
  const AddSyllabusView({super.key});

  @override
  State<AddSyllabusView> createState() => _AddSyllabusViewState();
}

class _AddSyllabusViewState extends State<AddSyllabusView> {
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

  // Declare TextEditingControllers
  final TextEditingController subjectNameController = TextEditingController();
  final TextEditingController subjectDescriptionController = TextEditingController();
  final TextEditingController subjectImageController = TextEditingController();

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result == null) {
      return;
    }

    setState(() {
      selectedImage = result.files.first;
      mimeType = selectedImage!.extension != null
          ? 'image/${selectedImage!.extension}'
          : 'unknown';
      imageSize = selectedImage!.size;
    });
    print("selectedImage: ${selectedImage!.name}");
  }

// Create Class method
  Future<void> _createSubject(
      String subjectName, String subjectDescription, String classId) async {
    logger.d('subjectName: $subjectName');
    logger.d('subjectDescription: $subjectDescription');
    logger.d('classId: $classId');
    setState(() => _isLoading = true);
    try {
      // Create an instance of the ClassService
      final subjectService = SubjectService();

      // Prepare the image data for upload
      Uint8List? imageBytes = selectedImage?.bytes;

      final response = await subjectService.createSubject(subjectName,
          subjectDescription, imageBytes!, selectedImage!.name, token, classId);
      logger.d('response: ${response.message}');
      // Check if the response is successful
      if (response.success) {
        // Handle the successful response (e.g., show a success message)

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Subject created successfully',
                  style: TextStyle(color: Colors.green))),
        );
        context.go('/dashboard/subjects/all-subjects');
      } else {
        // Handle the case where the response is null or not successful
        print(
            'Failed to create subject1: ${response.message}'); // Log the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message,
                  style: const TextStyle(color: Colors.red))),
        );
      }
    } catch (e) {
      // Catch any errors and display a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error1: $e')),
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
    _fetchClassList();
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
              headerText: 'Add Subject',
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

                  // Class
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
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
                              onPressed: () async {
                                await _pickImage();
                              },
                              icon:
                                  const Icon(Icons.upload_file), // Upload icon
                              label: const Text('Upload Image'),
                            ),
                            // Display the selected image here
                            if (selectedImage !=
                                null) // Check if an image is selected
                              Column(
                                children: [
                                  Image.memory(
                                    Uint8List.fromList(selectedImage!
                                        .bytes!), // Display the selected image
                                    width: 100, // Adjust the image fit
                                    height: 100, // Adjust the image fit
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Image Name: ${selectedImage!.name}', // Display the name of the selected image
                                    style: const TextStyle(
                                        fontSize:
                                            16), // Set the desired text style
                                  ),
                                  Text(
                                    'MIME Type: $mimeType', // Display the bytes as a base64 string
                                    style: const TextStyle(
                                        fontSize:
                                            16), // Set the desired text style
                                  ),
                                  Text(
                                    'Image Size: $imageSize bytes', // Display the bytes as a base64 string
                                    style: const TextStyle(
                                        fontSize:
                                            16), // Set the desired text style
                                  ),
                                ],
                              ),
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
                            browserDefaultFormKey.currentState?.save();
                            final subjectName = subjectNameController
                                .text; // Get the class name
                            final subjectDescription =
                                subjectDescriptionController
                                    .text; // Get the class description
                            final subjectImage = subjectImageController
                                .text; // Get the class image

                            // Call the method to create a student
                            _createSubject(
                                subjectName, subjectDescription, _classId);
                          }
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Save Subject'),
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
