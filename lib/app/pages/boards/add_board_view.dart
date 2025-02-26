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
import '../../core/api_service/board_service.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';


class AddBoardView extends StatefulWidget {
  const AddBoardView({super.key});

  @override
  State<AddBoardView> createState() => _AddBoardViewState();
}

class _AddBoardViewState extends State<AddBoardView> {
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
  final TextEditingController boardNameController = TextEditingController();
  final TextEditingController boardDescriptionController = TextEditingController();
  final TextEditingController boardImageController = TextEditingController();

  // Add new variable to store uploaded image URL
  String? uploadedImageUrl;

  // Add new variable for image upload loading state
  bool _isImageUploading = false;

  Future<void> _pickImage() async {
    // Check if board name is empty
    if (boardNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter board name before uploading an image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isImageUploading = true);
    try {
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

      // Start uploading immediately after image is selected
      if (selectedImage != null && selectedImage!.bytes != null) {
        final boardService = BoardService();
        try {
          final imageResponse = await boardService.uploadBoardImage(
            selectedImage!.bytes!,
            selectedImage!.name,
            boardNameController.text, // Now we know this isn't empty
            '', // empty string for new board
            token
          );
          print('imageResponse: $imageResponse');
          setState(() {
            uploadedImageUrl = imageResponse;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image uploaded successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error uploading image: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isImageUploading = false);
    }
  }

  // Modify _createBoard method
  Future<void> _createBoard(String boardName, String boardDescription) async {
    setState(() => _isLoading = true);
    try {
      final boardService = BoardService();

      // Create board with already uploaded image URL
      final response = await boardService.createBoard(
        boardName,
        boardDescription,
        uploadedImageUrl ?? '', // Use the previously uploaded image URL
        token
      );

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Board created successfully', style: TextStyle(color: Colors.green))),
        );
        context.go('/dashboard/boards/all-boards');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message, style: const TextStyle(color: Colors.red))),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
              headerText: 'Add Board',
              child: ResponsiveGridRow(
                children: [
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Board Name',
                        inputField: TextFormField(
                          controller: boardNameController,
                          decoration:  const InputDecoration(
                            hintText: 'Enter board name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter board name';
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
                        labelText: 'Board Description',
                        inputField: TextFormField(
                          controller: boardDescriptionController,
                          decoration:  const InputDecoration(
                            hintText: 'Enter board description',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter board description';
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
                        labelText: 'Board Image',
                        inputField: Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _isImageUploading ? null : () async {
                                await _pickImage();
                              },
                              icon: _isImageUploading 
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2)
                                  )
                                : const Icon(Icons.upload_file),
                              label: Text(_isImageUploading ? 'Uploading...' : 'Upload Image'),
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
                            final boardName = boardNameController.text; // Get the board name
                            final boardDescription = boardDescriptionController.text; // Get the board description
                            final boardImage = boardImageController.text; // Get the board image

                            // Call the method to create a student
                              _createBoard(boardName, boardDescription);
                          }
                        },
                        child: _isLoading ? const CircularProgressIndicator() : const Text('Save Board'),
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
    boardNameController.dispose();
    boardDescriptionController.dispose();
    boardImageController.dispose();
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
