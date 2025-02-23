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


class EditBoardView extends StatefulWidget {
  final String boardId;
  const EditBoardView({super.key, required this.boardId});


  @override
  State<EditBoardView> createState() => _EditBoardViewState();

}

class _EditBoardViewState extends State<EditBoardView> {
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
  String? prevBoardImage; // To store the previous board image URL

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
  
  // Upload image immediately after picking
  if (selectedImage != null && selectedImage!.bytes != null) {
    setState(() => _isLoading = true);
    try {
      final boardService = BoardService();
      final imageResponse = await boardService.uploadBoardImage(
        selectedImage!.bytes!,
        selectedImage!.name,
        boardNameController.text, // Use current board name
        prevBoardImage ?? '',
        token
      );
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
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

// Modify _createBoard method to _updateBoard
Future<void> _updateBoard(String boardName, String boardDescription) async {
  setState(() => _isLoading = true);
  try {
    final boardService = BoardService();

    // Update board with new or existing image URL
    final response = await boardService.updateBoard(
      widget.boardId,
      boardName,
      boardDescription,
      uploadedImageUrl ?? prevBoardImage ?? '', // Use already uploaded URL or keep existing
      token
    );

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Board updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/dashboard/boards/all-boards');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
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

// Add method to fetch board details
Future<void> _fetchBoardDetails() async {
  setState(() => _isLoading = true);
  try {
    final boardService = BoardService();
    final response = await boardService.getBoardById(widget.boardId, token);
    
    if (response['success']) {
      final boardData = response['data'];
      setState(() {
        boardNameController.text = boardData['name'];
        boardDescriptionController.text = boardData['description'];
        prevBoardImage = boardData['boardImage'];
        uploadedImageUrl = boardData['boardImage']; // Store current image URL
      });
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching board details: $e'),
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
  _fetchBoardDetails(); // Fetch board details when widget initializes
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
                            final boardName = boardNameController.text;
                            final boardDescription = boardDescriptionController.text;
                            _updateBoard(boardName, boardDescription);
                          }
                        },
                        child: _isLoading ? const CircularProgressIndicator() : const Text('Update Board'),
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
