import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Import necessary models and services
import '../../models/classes/class_info.dart';
import '../../models/subject/subject.dart';
import '../../models/teacher/teacher.dart';
import '../../providers/_auth_provider.dart';
import '../../core/api_service/subject_service.dart';
import '../../core/api_service/teacher_service.dart';
import '../../core/api_service/class_service.dart';
import '../../widgets/widgets.dart';

class RoutineService {
  final String baseUrl;
  String token;

  RoutineService({required this.baseUrl, required this.token});

  Future<dynamic> fetchRoutineById(String routineId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/routine/$routineId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load routine1111: ${response.body}');
    }
  }

  Future<dynamic> addPeriodToRoutine({
    required String routineId,
    required Map<String, dynamic> periodData,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/routine/$routineId/periods/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(periodData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add period: ${response.body}');
    }
  }

  Future<dynamic> updatePeriod({
    required String routineId,
    required String periodId,
    required Map<String, dynamic> periodData,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/routine/$routineId/periods/$periodId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(periodData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update period: ${response.body}');
    }
  }

  Future<bool> deletePeriod({
    required String routineId,
    required String periodId,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/routine/$routineId/periods/$periodId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }
}

class ViewScheduleView extends StatefulWidget {
  final String scheduleId;
  const ViewScheduleView({super.key, required this.scheduleId});

  @override
  State<ViewScheduleView> createState() => _ViewScheduleViewState();
}

class _ViewScheduleViewState extends State<ViewScheduleView> with WidgetsBindingObserver {
  final Logger _logger = Logger();
  late RoutineService _routineService;
  
  bool _isLoading = false;
  String _selectedDay = _getCurrentDay();
  String _selectedBoard = '';
  String _selectedYear = '';
  String _selectedClass = '';

  List<Subject> _subjectList = [];
  List<Teacher> _teacherList = [];
  List<ClassInfo> _classList = [];
  List<dynamic> _routinesList = [];

  final SubjectService _subjectService = SubjectService();
  final TeacherService _teacherService = TeacherService();
  final ClassService _classService = ClassService();

  bool _addPeriodLoading = false;
  bool _updatePeriodLoading = false;

  // Editable states
  int? _editingIndex;
  int? _newRowIndex;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    
    _routineService = RoutineService(
      baseUrl: 'https://api.ramaanya.com/api',
      token: authProvider.getToken,
    );

    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() => _isLoading = true);
    try {
      await Future.wait([
        _fetchSubjectList(),
        _fetchTeacherList(),
        _fetchClassList(),
        _fetchRoutineDetails(),
      ]);
    } catch (e) {
      _showErrorSnackBar('Failed to load initial data');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchRoutineDetails() async {
    try {
      final routine = await _routineService.fetchRoutineById(widget.scheduleId);
      setState(() {
        _routinesList = routine['periods'] ?? [];
        _logger.d("Routine Details1: $_routinesList");
        _selectedBoard = routine['board']['name'];
         _logger.d("Routine Details2: $_selectedBoard");
        _selectedClass = routine['class']['name'];
        _logger.d("Routine Details3: $_selectedClass");
        _selectedYear = routine['year'].toString();


        // _logger.d("Routine Details4: $_selectedYear");


      });
    } catch (e) {
      _logger.e("Error fetching routine details: $e");
      _showErrorSnackBar('Failed to fetch routine details');
    }

  }

  Future<void> _fetchSubjectList() async {
    _subjectList = await _subjectService.fetchAllSubjects(_routineService.token);
  }

  Future<void> _fetchTeacherList() async {
    _teacherList = await _teacherService.fetchAllTeachers(_routineService.token);
  }

  Future<void> _fetchClassList() async {
    _classList = await _classService.fetchAllClasses(_routineService.token);
  }

  void _addNewPeriod(Map<String, dynamic> periodData) async {
    setState(() => _addPeriodLoading = true);
    try {
      final updatedRoutine = await _routineService.addPeriodToRoutine(
        routineId: widget.scheduleId,
        periodData: periodData,
      );

      setState(() {
         //_routinesList = updatedRoutine['periods'];
        // _logger.d("Routine Details2: $_routinesList");
        _fetchRoutineDetails();
        _newRowIndex = null;
        _addPeriodLoading = false;
      });


      _showSuccessSnackBar('Period added successfully');
    } catch (e) {
      _showErrorSnackBar('Failed to add period');
    } finally {
      setState(() => _addPeriodLoading = false);
    }
  }


  void _updatePeriod(String periodId, Map<String, dynamic> periodData) async {
    setState(() => _updatePeriodLoading = true);
    try {
      final updatedRoutine = await _routineService.updatePeriod(
        routineId: widget.scheduleId,
        periodId: periodId,
        periodData: periodData,
      );

      setState(() {
        //_routinesList = updatedRoutine['periods'];
        _fetchRoutineDetails();
        _editingIndex = null;
        _updatePeriodLoading = false;

      });


      _showSuccessSnackBar('Period updated successfully');
    } catch (e) {
      _showErrorSnackBar('Failed to update period');
    } finally {
      setState(() => _updatePeriodLoading = false);
    }
  }


  void _deletePeriod(String periodId) async {
    try {
      final success = await _routineService.deletePeriod(
        routineId: widget.scheduleId,
        periodId: periodId,
      );

      if (success) {
        setState(() {
          _routinesList.removeWhere((period) => period['_id'] == periodId);
        });
        _showSuccessSnackBar('Period deleted successfully');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to delete period');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  static String _getCurrentDay() {
    final now = DateTime.now();
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[(now.weekday - 1) % 7];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _buildMainContent(),
      ),
    );
  }

  Widget _buildMainContent() {
    return ShadowContainer(
      headerText: '$_selectedBoard $_selectedClass Schedule for $_selectedYear | $_selectedDay',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDaySelector(),
          const SizedBox(height: 24),
          // Add column headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildTableHeader(),
          ),
          const Divider(thickness: 2),
          Expanded(child: _addPeriodLoading ? const Center(child: CircularProgressIndicator()) : _buildScheduleTable()),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Period'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  onPressed: _addNewRowPrompt,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildHeaderCell('Period'),
        ),
        Expanded(
          flex: 3,
          child: _buildHeaderCell('Time'),
        ),
        Expanded(
          flex: 3,
          child: _buildHeaderCell('Subject'),
        ),
        Expanded(
          flex: 3,
          child: _buildHeaderCell('Teacher'),
        ),
        const SizedBox(width: 100), // Space for action buttons
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildDaySelector() {
    final dayButtons = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
        .map((day) => _buildDayButton(day))
        .toList();

    return SizedBox(
      height: 48,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: dayButtons.map((button) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SizedBox(
                width: 120,
                child: button,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDayButton(String day) {
    final isSelected = _selectedDay == day;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () => _handleDayChange(day),
      child: Text(day),
    );
  }

  void _handleDayChange(String newDay) {
    if (_selectedDay == newDay) return;

    if (_hasUnsavedChanges()) {
      _showUnsavedChangesDialog(newDay);
      return;
    }

    setState(() {
      _selectedDay = newDay;
      _editingIndex = null;
      _newRowIndex = null;
    });
  }

  void _showUnsavedChangesDialog(String newDay) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('You have unsaved changes. Please save or cancel before switching days.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTable() {
    final dayRoutines = _routinesList
        .where((routine) => routine['day'] == _selectedDay.toLowerCase())
        .toList();

    if (dayRoutines.isEmpty) {
      return _buildEmptyStateWidget();
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ListView.builder(
          itemCount: dayRoutines.length,
          itemBuilder: (context, index) {
            final routine = dayRoutines[index];
            return _buildRoutineRow(routine, index);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyStateWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No periods scheduled for this day'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addNewRowPrompt,
            child: const Text('Add New Period'),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineRow(Map<String, dynamic> routine, int index) {
    return Container(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.grey.shade50 : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                '#${routine['periodNumber']}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey.shade700),
                  const SizedBox(width: 8),
                  Text(
                    '${routine['timeSlot']['startTime']} - ${routine['timeSlot']['endTime']}',
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                routine['subject']['name'],
                style: const TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                routine['teacher']['fullName'],
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    tooltip: 'Edit Period',
                    color: Colors.grey.shade700,
                    onPressed: () => _startEditing(routine),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    tooltip: 'Delete Period',
                    color: Colors.red[700],
                    onPressed: () => _showDeleteConfirmation(routine['_id']),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startEditing(Map<String, dynamic> routine) {
    final formKey = GlobalKey<FormState>();
    String? selectedSubjectId = routine['subject']['_id'];
    String? selectedTeacherId = routine['teacher']['_id'];
    
    final startTimeController = TextEditingController(text: routine['timeSlot']['startTime']);
    final endTimeController = TextEditingController(text: routine['timeSlot']['endTime']);
    int periodNumber = routine['periodNumber'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Period'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Period Number
                  TextFormField(
                    initialValue: periodNumber.toString(),
                    decoration: const InputDecoration(labelText: 'Period Number'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a period number';
                      }
                      return null;
                    },
                    onChanged: (value) => periodNumber = int.tryParse(value) ?? periodNumber,
                  ),
                  const SizedBox(height: 16),
                  
                  // Subject Dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Subject'),
                    value: selectedSubjectId,
                    items: _subjectList.map((subject) {
                      return DropdownMenuItem(
                        value: subject.id,
                        child: Text(subject.name),
                      );
                    }).toList(),
                    onChanged: (value) => selectedSubjectId = value,
                    validator: (value) {
                      if (value == null) return 'Please select a subject';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Teacher Dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Teacher'),
                    value: selectedTeacherId,
                    items: _teacherList.map((teacher) {
                      return DropdownMenuItem(
                        value: teacher.id,
                        child: Text(teacher.fullName),
                      );
                    }).toList(),
                    onChanged: (value) => selectedTeacherId = value,
                    validator: (value) {
                      if (value == null) return 'Please select a teacher';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Time Selection
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: startTimeController,
                          decoration: const InputDecoration(labelText: 'Start Time'),
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                DateTime.parse('2024-01-01 ${startTimeController.text}:00'),
                              ),
                            );
                            if (picked != null) {
                              setState(() {
                                startTimeController.text = 
                                    '${picked.hour.toString().padLeft(2, '0')}:'
                                    '${picked.minute.toString().padLeft(2, '0')}';
                              });
                            }
                          },
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: endTimeController,
                          decoration: const InputDecoration(labelText: 'End Time'),
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                DateTime.parse('2024-01-01 ${endTimeController.text}:00'),
                              ),
                            );
                            if (picked != null) {
                              setState(() {
                                endTimeController.text = 
                                    '${picked.hour.toString().padLeft(2, '0')}:'
                                    '${picked.minute.toString().padLeft(2, '0')}';
                              });
                            }
                          },
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final periodData = {
                    'day': _selectedDay.toLowerCase(),
                    'periodNumber': periodNumber,
                    'subject': selectedSubjectId,
                    'teacher': selectedTeacherId,
                    'timeSlot': {
                      'startTime': startTimeController.text,
                      'endTime': endTimeController.text,
                    },
                  };
                  
                  Navigator.pop(context);
                  _updatePeriod(routine['_id'], periodData);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewRowPrompt() {
    final formKey = GlobalKey<FormState>();
    String? selectedSubjectId;
    String? selectedTeacherId;
    
    // Create TextEditingControllers for the time fields
    final startTimeController = TextEditingController(text: '00:00');
    final endTimeController = TextEditingController(text: '00:00');
    int periodNumber = 1;

    // Calculate next period number
    final dayRoutines = _routinesList
        .where((routine) => routine['day'] == _selectedDay.toLowerCase())
        .toList();
    if (dayRoutines.isNotEmpty) {
      periodNumber = dayRoutines
          .map<int>((routine) => routine['periodNumber'] as int)
          .reduce((max, value) => value > max ? value : max) + 1;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Period'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Period Number
                  TextFormField(
                    initialValue: periodNumber.toString(),
                    decoration: const InputDecoration(labelText: 'Period Number'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a period number';
                      }
                      return null;
                    },
                    onChanged: (value) => periodNumber = int.tryParse(value) ?? periodNumber,
                  ),
                  const SizedBox(height: 16),
                  
                  // Subject Dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Subject'),
                    items: _subjectList.map((subject) {
                      return DropdownMenuItem(
                        value: subject.id,
                        child: Text(subject.name),
                      );
                    }).toList(),
                    onChanged: (value) => selectedSubjectId = value,
                    validator: (value) {
                      if (value == null) return 'Please select a subject';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Teacher Dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Teacher'),
                    items: _teacherList.map((teacher) {
                      return DropdownMenuItem(
                        value: teacher.id,
                        child: Text(teacher.fullName),
                      );
                    }).toList(),
                    onChanged: (value) => selectedTeacherId = value,
                    validator: (value) {
                      if (value == null) return 'Please select a teacher';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Updated Time Selection
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: startTimeController,
                          decoration: const InputDecoration(labelText: 'Start Time'),
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                DateTime.parse('2024-01-01 ${startTimeController.text}:00'),
                              ),
                            );
                            if (picked != null) {
                              setState(() {
                                startTimeController.text = 
                                    '${picked.hour.toString().padLeft(2, '0')}:'
                                    '${picked.minute.toString().padLeft(2, '0')}';
                              });
                            }
                          },
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: endTimeController,
                          decoration: const InputDecoration(labelText: 'End Time'),
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                DateTime.parse('2024-01-01 ${endTimeController.text}:00'),
                              ),
                            );
                            if (picked != null) {
                              setState(() {
                                endTimeController.text = 
                                    '${picked.hour.toString().padLeft(2, '0')}:'
                                    '${picked.minute.toString().padLeft(2, '0')}';
                              });
                            }
                          },
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final periodData = {
                    'day': _selectedDay.toLowerCase(),
                    'periodNumber': periodNumber,
                    'subject': selectedSubjectId,
                    'teacher': selectedTeacherId,
                    'timeSlot': {
                      'startTime': startTimeController.text,
                      'endTime': endTimeController.text,
                    },
                  };
                  
                  Navigator.pop(context);
                  _addNewPeriod(periodData);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String periodId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Period'),
        content: const Text('Are you sure you want to delete this period?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePeriod(periodId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  bool _hasUnsavedChanges() {
    return _editingIndex != null || _newRowIndex != null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}