// 🐦 Flutter imports:
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; 

import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_service/lecture_service.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import '../../core/api_service/class_service.dart';
import '../../models/classes/class_info.dart';
import '../../core/helpers/field_styles/field_styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:logger/logger.dart';
import '../../models/subject/subject.dart';
import '../../models/teacher/teacher.dart';
import '../../core/api_service/subject_service.dart';
import '../../core/api_service/teacher_service.dart';


class AddLectureView extends StatefulWidget {
  const AddLectureView({super.key});

  @override
  State<AddLectureView> createState() => _AddLectureViewState();
}

class _AddLectureViewState extends State<AddLectureView> {
  var logger = Logger();

  final browserDefaultFormKey = GlobalKey<FormState>();
  bool isBrowserDefaultChecked = false;

  bool _isLoading = false;

  PlatformFile? selectedImage;
  String? selectedImagePath;
  Uint8List? selectedImageBytes;
  String? mimeType;
  int? imageSize;
  String isImageSelected = '';

  PlatformFile? selectedVideo;
  String? selectedVideoPath;
  Uint8List? selectedVideoBytes;
  String? videoMimeType;
  int? videoSize;

  final customFormKey = GlobalKey<FormState>();
  bool isCustomFormChecked = false;
  String token = '';

  String _classId = "";
  String _subjectId = "";
  String _teacherId = "";
  String lectureType = "";
  String startTime = "";
  String endTime = "";

  double _uploadProgress = 0.0;

  // Declare TextEditingControllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController recordingUrlController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

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

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result == null) {
      return;
    }

    setState(() {
      selectedVideo = result.files.first;
      videoMimeType = selectedVideo!.extension != null
          ? 'video/${selectedVideo!.extension}'
          : 'unknown';
      videoSize = selectedVideo!.size;
    });
    logger.d('selectedVideo: ${selectedVideo!.name}');
  }

// Create Class method
  Future<void> _createLecture(
      String title, 
      String description, 
      String recordingUrl, 
      String classId, 
      String subjectId, 
      String teacherId, 
      String lectureType, 
      String startTime, 
      String endTime
    ) async {

      // Check for null or empty values before proceeding
    // if (title.isEmpty || description.isEmpty || classId.isEmpty || subjectId.isEmpty || teacherId.isEmpty || lectureType.isEmpty || startTime.isEmpty || endTime.isEmpty) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(content: Text('Please fill all fields')),
    //     );
    //     return; // Exit if any required field is empty
    // }

    setState(() {
      _isLoading = true;
      _uploadProgress = 0.0;
    });
    try {
      // Create an instance of the ClassService
      final lectureService = LectureService();

      // Prepare the image data for upload
      Uint8List? imageBytes = selectedImage?.bytes;

      // Ensure imageBytes is not null
        // if (imageBytes == null) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //         const SnackBar(content: Text('Please select an image')),
        //     );
        //     return; // Exit if no image is selected
        // }
    var response;

    if (lectureType == 'recorded') {
      // If lectureType is 'live', selectedVideo can be null or empty
      Uint8List? videoBytes = selectedVideo!.bytes;

      response = await lectureService.createLectureRecorded(
        title, 
        description, 
        imageBytes!, 
        selectedImage!.name,
        lectureType, 
        videoBytes,
        selectedVideo!.name,
        classId, 
        subjectId, 
        teacherId, 
        startTime, 
        endTime, 
        token,
      );

    } else {
      response = await lectureService.createLectureLive(
        title, 
        description, 
        imageBytes!, 
        selectedImage!.name,
        lectureType, 
        classId, 
        subjectId, 
        teacherId, 
        startTime, 
        endTime, 
        token,
      );
    }


      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Lecture created successfully',
                  style: TextStyle(color: Colors.green))),
        );
        context.go('/dashboard/lectures/all-lectures');

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.message}: ${response.error}')),
        );
        logger.e('Errorhere1: ${response.error}');
      }
    } catch (e) {
      // Catch any errors and display a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error1: $e')),
      );
      logger.e('Errorhere2: $e');
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
    _fetchSubjectList();
    _fetchTeacherList();
  }

// class service
  final _classService = ClassService();
  final _subjectService = SubjectService();
  final _teacherService = TeacherService();

// class list
  List<ClassInfo> _classList = [];
  List<Subject> _subjectList = [];
  List<Teacher> _teacherList = [];

  // fetch class list
  Future<void> _fetchClassList() async {
    final classList = await _classService.fetchAllClasses(token);
    setState(() {
      _classList = classList;
    });
  }

  // fetch subject list
  Future<void> _fetchSubjectList() async {
    final subjectList = await _subjectService.fetchAllSubjects(token);
    setState(() {
      _subjectList = subjectList;
    });
  }

  // fetch teacher list
  Future<void> _fetchTeacherList() async {
    final teacherList = await _teacherService.fetchAllTeachers(token);
    setState(() {
      _teacherList = teacherList;
    });
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
            key: browserDefaultFormKey,
            child: ShadowContainer(
              headerText: 'Add Lecture',
              child: ResponsiveGridRow(
                children: [
                  // Lecture Title
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Lecture Title',
                        inputField: TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            hintText: 'Enter title',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter title';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                  // Lecture Description
                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Description',
                        inputField: TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Enter description',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                  // Lecture Type
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Lecture Type',
                        inputField: DropdownButtonFormField2(
                          menuItemStyleData: _dropdownStyle.menuItemStyle,
                          buttonStyleData: _dropdownStyle.buttonStyle,
                          iconStyleData: _dropdownStyle.iconStyle,
                          dropdownStyleData: _dropdownStyle.dropdownStyle,
                          hint: const Text('Select Lecture Type'),
                          items: [
                            // key and value
                            {'key': 'Live', 'value': 'live'},
                            {'key': 'Recorded', 'value': 'recorded'}
                            ]
                              .map((lectureType) => DropdownMenuItem(
                                    value: lectureType['value'],
                                    child: Text(lectureType['key']!),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              lectureType = value as String;
                              logger.d('lectureType: $lectureType');
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select lecture type';
                            }
                            return null;
                          },
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select class';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                   // Subjects
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Subject',
                        inputField: DropdownButtonFormField2(
                          menuItemStyleData: _dropdownStyle.menuItemStyle,
                          buttonStyleData: _dropdownStyle.buttonStyle,
                          iconStyleData: _dropdownStyle.iconStyle,
                          dropdownStyleData: _dropdownStyle.dropdownStyle,
                          hint: const Text('Select Subject'),
                          items: _subjectList
                              .map((subject) => DropdownMenuItem(
                                    value: subject.id,
                                    child: Text(subject.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _subjectId = value as String;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select subject';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                   // Teachers
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Teacher',
                        inputField: DropdownButtonFormField2(
                          menuItemStyleData: _dropdownStyle.menuItemStyle,
                          buttonStyleData: _dropdownStyle.buttonStyle,
                          iconStyleData: _dropdownStyle.iconStyle,
                          dropdownStyleData: _dropdownStyle.dropdownStyle,
                          hint: const Text('Select Teacher'),
                          items: _teacherList
                              .map((teacher) => DropdownMenuItem(
                                    value: teacher.id,
                                    child: Text(teacher.fullName),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _teacherId = value as String;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select teacher';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

// date and time picker for live lecture start time and end time
// start time
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Start Time',
                        inputField: TextFormField(
                          controller: startTimeController,
                          decoration: const InputDecoration(
                            hintText: 'Select Start Time',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select start time';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

// end time
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'End Time',
                        inputField: TextFormField(
                          controller: endTimeController,
                          decoration: const InputDecoration(
                            hintText: 'Select End Time',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select end time';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),


                //  ResponsiveGridCol(
                //    lg: 4,
                //    md: 6,
                //    child: Padding(
                //      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                //      child: TextFieldLabelWrapper(
                //        labelText: 'Start Time',
                //        inputField: DateTimePicker(
                //          type: DateTimePickerType.dateTime,
                //          decoration: const InputDecoration(
                //            hintText: 'Select Start Time',
                //          ),
                //        ),
                //      ),
                //    ),
                //  ),

                 // End Time Picker
                //  ResponsiveGridCol(
                //    lg: 4,
                //    md: 6,
                //    child: Padding(
                //      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                //      child: TextFieldLabelWrapper(
                //        labelText: 'End Time',
                //        inputField: DateTimePicker(
                //          type: DateTimePickerType.dateTime,
                //          decoration: const InputDecoration(
                //            hintText: 'Select End Time',
                //          ),
                //        ),
                //      ),
                //    ),
                //  ),


                  // Lecture Thumbnail
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Thumbnail',
                        inputField: Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                await _pickImage();
                              },
                              icon:
                                  const Icon(Icons.upload_file), // Upload icon
                              label: const Text('Upload Thumbnail'),
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

                              if (isImageSelected == 'false')
                              const Text(
                               'Please select an image',
                               style: TextStyle(
                                 color: Colors.red, // Error message color
                                 fontSize: 14, // Error message font size
                               ),
                             ),
                          ],
                        ),
                        
                      ),
                    ),
                  ),

              // if lecture type selected is recorded
              if (lectureType == 'recorded') 
                  // Lecture Recorded Video
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Recorded Video',
                        inputField: Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                await _pickVideo();
                              },
                              icon:
                                  const Icon(Icons.upload_file), // Upload icon
                              label: const Text('Upload Recorded Video'),
                            ),
                            // Display the selected image here
                            if (selectedVideo !=
                                null) // Check if an image is selected
                              Column(
                                children: [
                                  Text('Video Selected ${selectedVideo!.name}'),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Video Name: ${selectedVideo!.name}', // Display the name of the selected image
                                    style: const TextStyle(
                                        fontSize:
                                            16), // Set the desired text style
                                  ),
                                  Text(
                                    'MIME Type: $videoMimeType', // Display the bytes as a base64 string
                                    style: const TextStyle(
                                        fontSize:
                                            16), // Set the desired text style
                                  ),
                                  Text(
                                    'Video Size: $videoSize bytes', // Display the bytes as a base64 string
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

                  // Upload Progress
                  // Add a LinearProgressIndicator to show upload progress
                  if (_isLoading)
                  ResponsiveGridCol(
                    lg: 12,
                    md: 12,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 20,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: _uploadProgress,
                                backgroundColor: Colors.grey,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Text(
                                '${(_uploadProgress * 100).toStringAsFixed(0)}%', // Display percentage
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ) // Show progress bar
                    ),
                  ),

                  // Increase Progress Button
                  // ResponsiveGridCol(
                  //   lg: 12,
                  //   md: 12,
                  //   child: Padding(
                  //     padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                  //     child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.blue,
                  //       ),
                  //       onPressed: () {
                  //         setState(() {
                  //           _uploadProgress += 0.1; // Increase progress by 10%
                  //           if (_uploadProgress > 1.0) _uploadProgress = 1.0; // Cap progress at 100%
                  //         });
                  //       },
                  //       child: const Text('Increase Progress'),
                  //     ),
                  //   ),
                  // ),


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
                            final title = titleController.text; // Get the class name
                            final description = descriptionController.text; // Get the class description
                            final recordingUrl = recordingUrlController.text; // Get the class image

                            
                             isImageSelected = selectedImage != null ? 'true' : 'false';
                           

                            logger.d('isImageSelected: $isImageSelected');
                            // Call the method to create a student
                            _createLecture(
                                  title, 
                                  description, 
                                  recordingUrl, 
                                  _classId, 
                                  _subjectId, 
                                  _teacherId, 
                                  lectureType,
                                  startTimeController.text,
                                  endTimeController.text
                                );
                          }
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text('Create Lecture'),
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
    titleController.dispose();
    descriptionController.dispose();
    recordingUrlController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
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
