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
import '../../core/api_service/class_service.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';


class AddClassView extends StatefulWidget {
  const AddClassView({super.key});

  @override
  State<AddClassView> createState() => _AddClassViewState();
}

class _AddClassViewState extends State<AddClassView> {
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

  // Declare TextEditingControllers
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController classDescriptionController = TextEditingController();
  final TextEditingController classImageController = TextEditingController();

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
Future<void> _createClass(String className, String classDescription) async {
  setState(() => _isLoading = true);
  try {
    // Create an instance of the ClassService
    final classService = ClassService();

    // Prepare the image data for upload
    Uint8List? imageBytes = selectedImage?.bytes;

    final response = await classService.createClass(
      className, 
      classDescription, 
      imageBytes!, 
      selectedImage!.name, 
      token
    );
    print('response: ${response.message}');
    // Check if the response is successful
    if (response.success) {
      // Handle the successful response (e.g., show a success message)

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Class created successfully', style: TextStyle(color: Colors.green))),
      );
      context.go('/dashboard/classes/all-classes');
    } else {
      // Handle the case where the response is null or not successful
      print('Failed to create class1: ${response.message}'); // Log the error message
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(response.message, style: const TextStyle(color: Colors.red))),
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
}

  @override
  Widget build(BuildContext context) {
    const _lg = 4;
    const _md = 6;

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
              headerText: 'Add Class',
              child: ResponsiveGridRow(
                children: [
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Class Name',
                        inputField: TextFormField(
                          controller: classNameController,
                          decoration:  const InputDecoration(
                            hintText: 'Enter class name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter class name';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Class Description',
                        inputField: TextFormField(
                          controller: classDescriptionController,
                          decoration:  const InputDecoration(
                            hintText: 'Enter class description',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter class description';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                  
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Class Image',
                        inputField: Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                await _pickImage();
                              },
                              icon: const Icon(Icons.upload_file), // Upload icon
                              label: const Text('Upload Image'),
                            ),
                            // Display the selected image here
                            if (selectedImage != null) // Check if an image is selected
                              Column(
                                children: [
                                  Image.memory(
                                    Uint8List.fromList(selectedImage!.bytes!), // Display the selected image
                                    width: 100, // Adjust the image fit
                                    height: 100, // Adjust the image fit
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Image Name: ${selectedImage!.name}', // Display the name of the selected image
                                    style: const TextStyle(fontSize: 16), // Set the desired text style
                                  ),
                                  Text(
                                    'MIME Type: $mimeType', // Display the bytes as a base64 string
                                    style: const TextStyle(fontSize: 16), // Set the desired text style
                                  ),
                                  Text(
                                    'Image Size: $imageSize bytes', // Display the bytes as a base64 string
                                    style: const TextStyle(fontSize: 16), // Set the desired text style
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
                    md: 12,
                    xl: 12,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: () {
                          if (browserDefaultFormKey.currentState?.validate() ==
                              true) {
                            browserDefaultFormKey.currentState?.save();
                            final className = classNameController.text; // Get the class name
                            final classDescription = classDescriptionController.text; // Get the class description
                            final classImage = classImageController.text; // Get the class image

                            // Call the method to create a student
                            _createClass(className, classDescription);
                          }
                        },
                        child: _isLoading ? const CircularProgressIndicator() : const Text('Save Class'),
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
    classNameController.dispose();
    classDescriptionController.dispose();
    classImageController.dispose();
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
