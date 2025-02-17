// 🐦 Flutter imports:
import 'dart:typed_data';
import 'package:acnoo_flutter_admin_panel/app/core/api_service/board_service.dart';
import 'package:flutter/foundation.dart'; 

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
import '../../models/lecture/lecture.dart';
import '../../models/board/board.dart';

class EditLectureView extends StatefulWidget {
  final String lectureId;
  const EditLectureView({super.key, required this.lectureId});

  @override
  State<EditLectureView> createState() => _EditLectureViewState();

}

class _EditLectureViewState extends State<EditLectureView> {
  var logger = Logger();

  final browserDefaultFormKey = GlobalKey<FormState>();
  bool isBrowserDefaultChecked = false;

  bool _isInitialLoading = true;  // For initial data fetch
  bool _isLoading = false;        // For form submission

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

  String _boardId = "";
  String _classId = "";
  String _subjectId = "";
  String _teacherId = "";
  String lectureType = "";
  String startTime = "";
  String endTime = "";
  String prevThumbnail = "";
  String prevVideoFile = "";

  double _uploadProgress = 0.0;

  // Declare TextEditingControllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController recordingUrlController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();

  // Add lecture variable
  Lecture? _lecture;
  final _lectureService = LectureService();

  // Add new variable to store the uploaded thumbnail URL
  String? uploadedThumbnailUrl;

  // Add new variable to store the uploaded video URL
  String? uploadedVideoUrl;
  double _videoUploadProgress = 0.0;

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
      _uploadProgress = 0.0; // Reset progress when new image selected
    });

    // Upload the thumbnail immediately after selection
    try {
      setState(() {
        _isLoading = true;
      });

      final thumbnailUrl = await _lectureService.uploadLectureThumbnail(
        selectedImage!.bytes!,
        selectedImage!.name,
        titleController.text,
        prevThumbnail,
        token,
      );

      setState(() {
        uploadedThumbnailUrl = thumbnailUrl;
        _isLoading = false;
        _uploadProgress = 1.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thumbnail uploaded successfully')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _uploadProgress = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload thumbnail: $e')),
      );
    }
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
      _videoUploadProgress = 0.0; // Reset progress when new video selected
    });

    // Upload the video immediately after selection
    try {
      setState(() {
        _isLoading = true;
      });

      final videoUrl = await _lectureService.uploadLectureVideo(
        selectedVideo!.bytes!,
        selectedVideo!.name,
        titleController.text,
        prevVideoFile, // Previous video URL
        token,
      );

      setState(() {
        uploadedVideoUrl = videoUrl;
        _isLoading = false;
        _videoUploadProgress = 1.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video uploaded successfully')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _videoUploadProgress = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload video: $e')),
      );
    }
  }

// fetch lecture
  Future<void> _fetchLecture() async {
    try {
      final lecture = await _lectureService.getLectureById(widget.lectureId, token);
      setState(() {
        _lecture = lecture;
        // Populate form fields with existing lecture data
        titleController.text = lecture.title;
        descriptionController.text = lecture.description;
        _boardId = lecture.board?.id ?? "";
        logger.i('vvgvdv ${_boardId}');
        _classId = lecture.classInfo?.id ?? "";
        _subjectId = lecture.subject?.id ?? "";
        _teacherId = lecture.teacher?.id ?? "";
        lectureType = lecture.lectureType;
        startDateController.text = lecture.startDate;
        startTimeController.text = lecture.startTime;
        prevThumbnail = lecture.thumbnail;
        prevVideoFile = lecture.recordingUrl!;
      });
    } catch (e) {
      logger.e('Error fetching lecture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading lecture: $e')),
      );
    } finally {
      setState(() {
        _isInitialLoading = false;
      });
    }
  }

  // update lecture
  Future<void> _updateLecture() async {
    if (!browserDefaultFormKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> updateData = {
        'title': titleController.text,
        'description': descriptionController.text,
        'board': _boardId,
        'class': _classId,
        'subject': _subjectId,
        'teacher': _teacherId,
        'lectureType': lectureType,
        'thumbnail': uploadedThumbnailUrl,
        'recordingUrl': uploadedVideoUrl,
        'startDate': startDateController.text,
        'startTime': startTimeController.text,
      };

      // Add thumbnail URL to update data if it was uploaded
      if (uploadedThumbnailUrl != null) {
        updateData['thumbnailImage'] = uploadedThumbnailUrl;
      }

      // Add video URL to update data if it was uploaded
      if (uploadedVideoUrl != null) {
        updateData['recordingUrl'] = uploadedVideoUrl;
      }

      logger.d('updateData: $updateData');

      final updatedLecture = await _lectureService.updateLecture(
        widget.lectureId,
        updateData,
        token,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lecture updated successfully')),
      );
      context.go('/dashboard/lectures/all-lectures');

    } catch (e) {
      logger.e('Failed to update lecture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update lecture: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    if (authProvider.getRole == 'teacher') {
      _teacherId = authProvider.getUserId;
    }
    _fetchLecture();
    _fetchBoardList();
    _fetchClassList();
    _fetchSubjectList();
    if (authProvider.getRole != 'teacher') {
      _fetchTeacherList();
    }
    // Add this line to fetch lecture data
  }

// class service
final _boardService = BoardService();
  final _classService = ClassService();
  final _subjectService = SubjectService();
  final _teacherService = TeacherService();

// class list
List<Board> _boardList = [];
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

  // fetch teacher list
  Future<void> _fetchBoardList() async {
    final boardList = await _boardService.fetchAllBoards(token);
    logger.i('gvhv ${boardList[0].id}');
    setState(() {
      _boardList = boardList;
      logger.i('gvhv $boardList');
    });
  }

  @override
  Widget build(BuildContext context) {
    const _lg = 12;
    const _md = 12;
    final _inputFieldStyle = AcnooInputFieldStyles(context);

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

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isTeacher = authProvider.getRole == 'teacher';

    return Scaffold(
      body: _isInitialLoading 
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
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
                          value: lectureType.isNotEmpty ? lectureType : null,
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

                  // boards
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Boards',
                        inputField: DropdownButtonFormField2(
                          menuItemStyleData: _dropdownStyle.menuItemStyle,
                          buttonStyleData: _dropdownStyle.buttonStyle,
                          iconStyleData: _dropdownStyle.iconStyle,
                          dropdownStyleData: _dropdownStyle.dropdownStyle,
                          hint: const Text('Select Board'),
                          value: _boardList.isNotEmpty ? _boardId : null,
                          items: _boardList
                              .map((board) => DropdownMenuItem(
                                    value: board.id,
                                    child: Text(board.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _boardId = value as String;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select Board';
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
                          value: _subjectId.isNotEmpty ? _subjectId : null,
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
                  if (!isTeacher) ResponsiveGridCol(
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
                          value: _teacherId.isNotEmpty ? _teacherId : null,
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

                  // Start Date
                  ResponsiveGridCol(
                    lg: 4,
                    md: 6,
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Input Date',
                        inputField: TextFormField(
                          controller: startDateController,
                          keyboardType: TextInputType.visiblePassword,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'mm/dd/yyyy',
                            suffixIcon: const Icon(Icons.calendar_today, size: 20),
                            suffixIconConstraints: _inputFieldStyle.iconConstraints,
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                            );

                            if (pickedDate != null) {
                              setState(() {
                                startDateController.text = DateFormat('MM/dd/yyyy').format(pickedDate);
                              });
                            }
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
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Select Start Time',
                            suffixIcon: const Icon(Icons.access_time, size: 20),
                            suffixIconConstraints: _inputFieldStyle.iconConstraints,
                          ),
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              setState(() {
                                // Format time to 12-hour format with AM/PM
                                final hour = pickedTime.hourOfPeriod;
                                final minute = pickedTime.minute.toString().padLeft(2, '0');
                                final period = pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
                                startTimeController.text = '$hour:$minute $period';
                              });
                            }
                          },
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
                              onPressed: _isLoading ? null : () async {
                                await _pickVideo();
                              },
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Upload Recorded Video'),
                            ),
                            if (selectedVideo != null)
                              Column(
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    'Video Name: ${selectedVideo!.name}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'MIME Type: $videoMimeType',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Video Size: $videoSize bytes',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  if (_isLoading && _videoUploadProgress < 1)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: LinearProgressIndicator(
                                                value: _videoUploadProgress,
                                                backgroundColor: Colors.grey,
                                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                                              ),
                                            ),
                                          ),
                                          Positioned.fill(
                                            child: Center(
                                              child: Text(
                                                '${(_videoUploadProgress * 100).toStringAsFixed(0)}%',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: _isLoading ? null : _updateLecture,
                        child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text('Update Lecture'),
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
    startDateController.dispose();
    startTimeController.dispose();
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
