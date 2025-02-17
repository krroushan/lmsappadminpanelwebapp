// 🐦 Flutter imports:
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // Import this for kIsWeb

import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import '../../core/helpers/field_styles/field_styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:logger/logger.dart';

class AppSettingView extends StatefulWidget {
  const AppSettingView({super.key});

  @override
  State<AppSettingView> createState() => _AppSettingViewState();
}

class _AppSettingViewState extends State<AppSettingView> {
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

  // Keep only the website and app UI related controllers
  final TextEditingController websiteTitleController = TextEditingController();
  final TextEditingController metaDescriptionController = TextEditingController();
  PlatformFile? websiteLogoFile;
  PlatformFile? websiteIconFile;

  final TextEditingController primaryColorController = TextEditingController();
  final TextEditingController secondaryColorController = TextEditingController();
  PlatformFile? appThemePreviewImage;
  String selectedTheme = 'light';

  final List<Map<String, dynamic>> themePresets = [
    {
      'name': 'Classic',
      'primaryColor': Colors.blue,
      'secondaryColor': Colors.grey,
      'previewImage': 'https://play-lh.googleusercontent.com/QgaH8rBbQfoKc-052Ot_z_yFmajd9uu_7NQBlFOP2SURb2ITGyEBe7FoxF_f59hzb2I=w2560-h1440-rw',
    },
    {
      'name': 'Modern',
      'primaryColor': Colors.indigo,
      'secondaryColor': Colors.teal,
      'previewImage': 'https://play-lh.googleusercontent.com/QgaH8rBbQfoKc-052Ot_z_yFmajd9uu_7NQBlFOP2SURb2ITGyEBe7FoxF_f59hzb2I=w2560-h1440-rw',
    },
    // Add more theme presets as needed
  ];

  String selectedPreset = 'Classic'; // New state variable for selected preset

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

  // Add method to pick theme preview image
  Future<void> _pickThemePreview() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (result == null) return;

    setState(() {
      appThemePreviewImage = result.files.first;
    });
  }

  // Add method to save app UI settings
  Future<void> _saveAppUISettings() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Implement API call to save app UI settings
      // await _settingsService.updateAppUISettings(
      //   primaryColor: primaryColorController.text,
      //   secondaryColor: secondaryColorController.text,
      //   themePreview: appThemePreviewImage?.bytes,
      //   selectedTheme: selectedTheme,
      //   token: token,
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('App UI settings updated successfully'),
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
  }

  // Add new controllers for app settings
  final TextEditingController appNameController = TextEditingController();
  final TextEditingController appDescriptionController = TextEditingController();
  PlatformFile? appLogoFile;
  PlatformFile? appIconFile;

  // Add method to pick app logo/icon
  Future<void> _pickAppImage(bool isLogo) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (result == null) return;

    setState(() {
      if (isLogo) {
        appLogoFile = result.files.first;
      } else {
        appIconFile = result.files.first;
      }
    });
  }

  // Add method to save app settings
  // Future<void> _saveAppSettings() async {
  //   setState(() => _isLoading = true);
  //   try {
  //     // TODO: Implement API call to save app settings
  //     // await _settingsService.updateAppSettings(
  //     //   appName: appNameController.text,
  //     //   description: appDescriptionController.text,
  //     //   logo: appLogoFile?.bytes,
  //     //   icon: appIconFile?.bytes,
  //     //   token: token,
  //     // );

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('App settings updated successfully'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } catch (e) {
  //     logger.e('Error: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error: $e'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    const _lg = 12;
    const _md = 12;
    final _dropdownStyle = AcnooDropdownStyle(context);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Form(
            key: GlobalKey<FormState>(),
            child: ShadowContainer(
              headerText: 'App Settings',
              child: ResponsiveGridRow(
                children: [
                  // App Name
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: TextFieldLabelWrapper(
                        labelText: 'App Name',
                        inputField: TextFormField(
                          controller: appNameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter app name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter app name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  // App Description
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: TextFieldLabelWrapper(
                        labelText: 'App Description',
                        inputField: TextFormField(
                          controller: appDescriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Enter app description',
                          ),
                        ),
                      ),
                    ),
                  ),

                  // App Logo
                  ResponsiveGridCol(
                    lg: 6,
                    md: 6,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: TextFieldLabelWrapper(
                        labelText: 'App Logo',
                        inputField: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _pickAppImage(true),
                              icon: const Icon(Icons.upload),
                              label: const Text('Upload Logo'),
                            ),
                            if (appLogoFile != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text('Selected: ${appLogoFile!.name}'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // App Icon
                  ResponsiveGridCol(
                    lg: 6,
                    md: 6,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: TextFieldLabelWrapper(
                        labelText: 'App Icon',
                        inputField: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _pickAppImage(false),
                              icon: const Icon(Icons.upload),
                              label: const Text('Upload Icon'),
                            ),
                            if (appIconFile != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text('Selected: ${appIconFile!.name}'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Save Button
                  ResponsiveGridCol(
                    lg: 12,
                    md: 12,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () {
                          // Implement save logic here
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Save App Settings'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Form(
            key: GlobalKey<FormState>(),
            child: ShadowContainer(
              headerText: 'App UI Settings',
              child: ResponsiveGridRow(
                children: [
                  // Theme Selection
                  ResponsiveGridCol(
                    lg: 12,
                    md: 12,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: TextFieldLabelWrapper(
                        labelText: 'App Theme',
                        inputField: DropdownButtonFormField2(
                          menuItemStyleData: _dropdownStyle.menuItemStyle,
                          buttonStyleData: _dropdownStyle.buttonStyle,
                          iconStyleData: _dropdownStyle.iconStyle,
                          dropdownStyleData: _dropdownStyle.dropdownStyle,
                          value: selectedTheme,
                          items: const [
                            DropdownMenuItem(value: 'light', child: Text('Light Theme')),
                            DropdownMenuItem(value: 'dark', child: Text('Dark Theme')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedTheme = value.toString();
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // Theme Presets Grid
                  ResponsiveGridCol(
                    lg: 12,
                    md: 12,
                    child: Padding(
                        padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Theme Presets',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: themePresets.length,
                              itemBuilder: (context, index) {
                                final preset = themePresets[index];
                                final isSelected = preset['name'] == selectedPreset;
                                
                                return Card(
                                  margin: const EdgeInsets.only(right: 16),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPreset = preset['name'];
                                      });
                                      // Apply theme preset logic here
                                    },
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Image.network(
                                              preset['previewImage'],
                                              height: 150,
                                              width: 200,
                                              fit: BoxFit.cover,
                                            ),
                                            Text(preset['name']),
                                          ],
                                        ),
                                        if (isSelected)
                                          const Positioned(
                                            top: 8,
                                            right: 8,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.green,
                                              radius: 12,
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Custom Theme Preview Upload
                  ResponsiveGridCol(
                    lg: 6,
                    md: 6,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: TextFieldLabelWrapper(
                        labelText: 'Custom Theme Preview',
                        inputField: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _pickThemePreview,
                              icon: const Icon(Icons.upload),
                              label: const Text('Upload Theme Preview'),
                            ),
                            if (appThemePreviewImage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text('Selected: ${appThemePreviewImage!.name}'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Save Button
                  ResponsiveGridCol(
                    lg: 12,
                    md: 12,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveAppUISettings,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Save App UI Settings'),
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
    websiteTitleController.dispose();
    metaDescriptionController.dispose();
    primaryColorController.dispose();
    secondaryColorController.dispose();
    appNameController.dispose();
    appDescriptionController.dispose();
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
