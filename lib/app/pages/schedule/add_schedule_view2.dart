import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../widgets/widgets.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

import '../../models/classes/class_info.dart';
import '../../models/subject/subject.dart';
import '../../models/teacher/teacher.dart';

import '../../core/api_service/subject_service.dart';
import '../../core/api_service/teacher_service.dart';
import '../../core/api_service/class_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AddScheduleView extends StatefulWidget {
  const AddScheduleView({super.key});

  @override
  State<AddScheduleView> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<AddScheduleView> with WidgetsBindingObserver {
  var logger = Logger();
  String token = '';
  String _selectedDay = _getCurrentDay();
  String _selectedBoard = '';
  String _selectedYear = '';
  String _selectedClass = '';
  final List<String> _boards = ['CBSE', 'ICSE', 'State Board'];
  final List<String> _years = ['2024', '2025', '2026', '2027'];
  
  List<Subject> _subjectList = [];
  List<Teacher> _teacherList = [];
  List<ClassInfo> _classList = [];

  List<dynamic> _routinesList = [];

  final SubjectService _subjectService = SubjectService();
  final TeacherService _teacherService = TeacherService();
  final ClassService _classService = ClassService();

  Future<void> _createRoutine() async {
    final url = 'http://localhost:8000/api/routine/create';
    final body = {
      'board': _selectedBoard,
      'class': _selectedClass,
      'year': int.parse(_selectedYear),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        logger.d('Routine created successfully');
        // Optionally show a success message to the user
      } else {
        logger.e('Failed to create routine: ${response.body}');
        // Optionally show an error message to the user
      }
    } catch (e) {
      logger.e('Error creating routine: $e');
      // Optionally show an error message to the user
    }
  }

   Future<void> _fetchRoutines() async {
    final url = 'http://localhost:8000/api/routine/all';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _routinesList = jsonDecode(response.body);
          logger.d('Fetched ${_routinesList.length} routines');
        });
      } else {
        logger.e('Failed to fetch routines: ${response.body}');
        // Optionally show an error message to the user
      }
    } catch (e) {
      logger.e('Error fetching routines: $e');
      // Optionally show an error message to the user
    }
  }

  // Add this map to store routines for each day
  final Map<String, List<List<String>>> _routines = {
    'Monday': [
      ['1', '8:00 - 8:45', 'Mathematics', 'Mr. Smith'],
      ['2', '8:45 - 9:30', 'Science', 'Mrs. Johnson'],
      ['3', '9:30 - 10:15', 'English', 'Ms. Davis'],
      ['4', '10:15 - 11:00', 'History', 'Mr. Wilson'],
    ],
    'Tuesday': [
      ['1', '8:00 - 8:45', 'Physics', 'Mrs. Brown'],
      ['2', '8:45 - 9:30', 'Chemistry', 'Mr. White'],
      ['3', '9:30 - 10:15', 'Biology', 'Ms. Green'],
    ],
    'Wednesday': [
      ['1', '8:00 - 8:45', 'Computer', 'Mr. Anderson'],
      ['2', '8:45 - 9:30', 'Mathematics', 'Mr. Smith'],
      ['3', '9:30 - 10:15', 'English', 'Ms. Davis'],
    ],
    'Thursday': [
      ['1', '8:00 - 8:45', 'History', 'Mr. Wilson'],
      ['2', '8:45 - 9:30', 'Geography', 'Mrs. Clark'],
      ['3', '9:30 - 10:15', 'Literature', 'Mr. Lewis'],
    ],
    'Friday': [
      ['1', '8:00 - 8:45', 'Physical Education', 'Mr. Johnson'],
      ['2', '8:45 - 9:30', 'Art', 'Ms. Parker'],
      ['3', '9:30 - 10:15', 'Music', 'Mr. Mozart'],
    ],
    // Saturday and Sunday have no routines
  };

  // Add this to track which row is being edited
  int? _editingIndex;

  // Add this variable to track newly added row
  int? _newRowIndex;

  bool _showSchedule = false;

  static String _getCurrentDay() {
    final now = DateTime.now();
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final index = (now.weekday - 1) % 7;
    return days[index];
  }

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchSubjectList();
    _fetchTeacherList();
    _fetchClassList();
    _fetchRoutines();
  }

  // fetch class list
  Future<void> _fetchClassList() async {
    try {
      final classList = await _classService.fetchAllClasses(token);
      setState(() {
        _classList = classList;
        logger.d('Fetched ${classList.length} classes');
      });
    } catch (e) {
      logger.e('Error fetching classes: $e');
      // Optionally show an error message to the user
    }
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

    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 992,
          value: _SizeInfo(
            fonstSize: 12,
            padding: EdgeInsets.all(0),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    return Scaffold(
      body: Padding(
        padding: _sizeInfo.padding,
        child: !_showSchedule 
            ? _buildSelectionPanel()
            : ShadowContainer(
                headerText: '$_selectedBoard $_selectedClass Schedule/Routine for $_selectedYear',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 8),
                      child: Text(
                        'Select Day',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    _buildDaySelector(),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildTimeTable(),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSelectionPanel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600; // Breakpoint for wide screens
        
        return ShadowContainer(
          headerText: 'Select Board, Class and Year',
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isWideScreen)
                  // Wide screen - Row layout
                  Row(
                    children: [
                      Expanded(child: _buildBoardDropdown()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildClassDropdown()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildYearDropdown()),
                    ],
                  )
                else
                  // Narrow screen - Column layout
                  Column(
                    children: [
                      _buildBoardDropdown(),
                      const SizedBox(height: 16),
                      _buildClassDropdown(),
                      const SizedBox(height: 16),
                      _buildYearDropdown(),
                    ],
                  ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: (_selectedBoard.isNotEmpty && 
                              _selectedClass.isNotEmpty && 
                              _selectedYear.isNotEmpty)
                        ? () {
                            setState(() {
                              _createRoutine();
                              _showSchedule = true;
                            });
                          }
                        : null,
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  // Helper methods to reduce code duplication
  Widget _buildBoardDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Board'),
      value: _selectedBoard.isEmpty ? null : _selectedBoard,
      items: _boards.map((board) {
        return DropdownMenuItem(
          value: board,
          child: Text(board),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedBoard = value ?? '';
        });
      },
    );
  }

  Widget _buildClassDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Class'),
      value: _selectedClass.isEmpty ? null : _selectedClass,
      items: _classList.map((cls) {
        return DropdownMenuItem(
          value: cls.name,
          child: Text(cls.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedClass = value ?? '';
        });
      },
    );
  }

  Widget _buildYearDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Year'),
      value: _selectedYear.isEmpty ? null : _selectedYear,
      items: _years.map((year) {
        return DropdownMenuItem(
          value: year,
          child: Text(year),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedYear = value ?? '';
        });
      },
    );
  }

  Widget _buildDaySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (String day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'])
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: MaterialButton(
                elevation: 0,
                color: _selectedDay == day ? Theme.of(context).primaryColor : Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onPressed: () => _handleDayChange(day),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Text(
                    day,
                    style: TextStyle(
                      color: _selectedDay == day ? Colors.white : Colors.black87,
                      fontWeight: _selectedDay == day ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleDayChange(String newDay) {
    if (_selectedDay == newDay) return;
    
    // Delete any empty rows before checking for unsaved changes
    _deleteIncompleteRows();
    
    if (_hasUnsavedChanges()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Unsaved Changes'),
          content: const Text('You have unsaved changes. Please save or delete your changes using the row buttons before switching days.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _editingIndex = null;
      _newRowIndex = null;
      _selectedDay = newDay;
    });
  }

  void _deleteIncompleteRows() {
    final dayRoutine = _routines[_selectedDay];
    if (dayRoutine == null) return;

    _routines[_selectedDay] = dayRoutine.where((row) {
      return !row.skip(1).any((cell) => cell.isEmpty);
    }).toList();
  }

  Widget _buildTimeTable() {
    final dayRoutine = _routines[_selectedDay];
    
    if (dayRoutine == null || dayRoutine.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No routine available for $_selectedDay',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_routines[_selectedDay] == null) {
                    _routines[_selectedDay] = [];
                  }
                  final newIndex = _routines[_selectedDay]!.length;
                  _routines[_selectedDay]!.add(['${newIndex + 1}', '', '', '']);
                  _newRowIndex = newIndex;
                });
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Table(
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey[300]!),
                  verticalInside: BorderSide(color: Colors.grey[300]!),
                ),
                columnWidths: const {
                  0: FixedColumnWidth(50), // Period
                  1: FlexColumnWidth(1.2), // Time
                  2: FlexColumnWidth(2), // Subject
                  3: FlexColumnWidth(1.5), // Teacher
                  4: FixedColumnWidth(120), // Actions
                },
                children: [
                  _buildTableRow(['#', 'Time', 'Subject', 'Teacher', 'Actions'], isHeader: true),
                  ...dayRoutine.asMap().entries.map((entry) => 
                    _buildEditableTableRow(
                      entry.value, 
                      entry.key,
                      isNewRow: entry.key == _newRowIndex
                    )),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  // Add new row
                  _addNewRow();
                },
                icon: const Icon(Icons.add, size: 20, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ],
        ),
        // Positioned(
        //   bottom: -16,
        //   right: 0,
        //   child: FloatingActionButton(
        //     onPressed: _addNewRow,
        //     backgroundColor: Colors.green,
        //     elevation: 0,
        //     child: const Icon(Icons.add, size: 20, color: Colors.white),
        //   ),
        // ),
      ],
    );
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey[100] : null,
      ),
      children: cells.map((cell) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Text(
          cell,
          style: TextStyle(
            fontSize: 14,
            color: isHeader ? Colors.black87 : Colors.black54,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      )).toList(),
    );
  }

  TableRow _buildEditableTableRow(List<String> cells, int index, {bool isNewRow = false}) {
    final isEditing = _editingIndex == index;
    final showEditMode = isEditing || isNewRow;
    final isLastRow = _routines[_selectedDay]?.length == index + 1;

    return TableRow(
      children: [
        // Period number cell (readonly)
        _buildCell(cells[0], readonly: true),
        // Time cell
        showEditMode
            ? _buildInlineEditableCell(
                cells[1],
                (newValue) => setState(() => _routines[_selectedDay]![index][1] = newValue),
                hintText: 'Enter time',
              )
            : _buildCell(cells[1]),
        // Subject cell
        showEditMode
            ? _buildInlineEditableCell(
                cells[2],
                (newValue) => setState(() => _routines[_selectedDay]![index][2] = newValue),
                hintText: 'Enter subject',
              )
            : _buildCell(cells[2]),
        // Teacher cell
        showEditMode
            ? _buildInlineEditableCell(
                cells[3],
                (newValue) => setState(() => _routines[_selectedDay]![index][3] = newValue),
                hintText: 'Enter teacher',
              )
            : _buildCell(cells[3]),
        // Actions cell
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isNewRow) ...[
                // Show tick and delete for new rows
                IconButton(
                  icon: const Icon(Icons.check_circle, size: 20),
                  color: Colors.green,
                  onPressed: () => setState(() => _newRowIndex = null),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      final routines = _routines[_selectedDay];
                      if (routines != null && routines.length > index) {
                        routines.removeAt(index);
                        _updatePeriodNumbers();
                      }
                      _newRowIndex = null;
                    });
                  },
                ),
              ] else ...[
                // Show edit for all rows, but delete only for last row
                IconButton(
                  icon: Icon(isEditing ? Icons.check : Icons.edit, size: 20),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() {
                      if (isEditing) {
                        _editingIndex = null;
                      } else {
                        _editingIndex = index;
                      }
                    });
                  },
                ),
                if (isLastRow)
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        final routines = _routines[_selectedDay];
                        if (routines != null && routines.length > index) {
                          routines.removeAt(index);
                          _updatePeriodNumbers();
                        }
                      });
                    },
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCell(String text, {bool readonly = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black54),
      ),
    );
  }

  Widget _buildInlineEditableCell(String initialValue, Function(String) onChanged, {String? hintText}) {
    // Time input handling remains the same
    if (hintText == 'Enter time') {
      final times = initialValue.split(' - ');
      final startTime = times.isNotEmpty ? times[0] : '';
      final endTime = times.length > 1 ? times[1] : '';

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: TextEditingController(text: startTime),
                decoration: InputDecoration(
                  hintText: 'Start',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        final newStartTime = picked.format(context);
                        onChanged('$newStartTime - $endTime');
                      }
                    },
                  ),
                  border: const UnderlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                ),
                readOnly: true,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('-'),
            ),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: endTime),
                decoration: InputDecoration(
                  hintText: 'End',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        final newEndTime = picked.format(context);
                        onChanged('$startTime - $newEndTime');
                      }
                    },
                  ),
                  border: const UnderlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                ),
                readOnly: true,
              ),
            ),
          ],
        ),
      );
    }

    // Handle subject dropdown
    if (hintText == 'Enter subject') {
      // Validate that initialValue exists in _subjects list
      final validValue = _subjectList.any((subject) => subject.name == initialValue) ? initialValue : null;
      
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: DropdownButtonFormField<String>(
          value: validValue,  // Use validated value
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          ),
          hint: Text(hintText!),
          items: _subjectList.map((Subject value) {
            return DropdownMenuItem<String>(
              value: value.name,
              child: Text(value.name),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      );
    }

    // Handle teacher dropdown
    if (hintText == 'Enter teacher') {
      // Validate that initialValue exists in _teachers list
      final validValue = _teacherList.any((teacher) => teacher.fullName == initialValue) ? initialValue : null;
      
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: DropdownButtonFormField<String>(
          value: validValue,  // Use validated value
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          ),
          hint: Text(hintText!),
          items: _teacherList.map((Teacher value) {
            return DropdownMenuItem<String>(
              value: value.fullName,
              child: Text(value.fullName),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      );
    }

    // Original implementation for other fields
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: TextField(
        controller: TextEditingController(text: initialValue),
        decoration: InputDecoration(
          hintText: hintText,
          border: const UnderlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        ),
        onChanged: onChanged,
      ),
    );
  }

  void _addNewRow() {
    setState(() {
      if (_routines[_selectedDay] == null) {
        _routines[_selectedDay] = [];
      }
      final newIndex = _routines[_selectedDay]!.length;
      _routines[_selectedDay]!.add(['${newIndex + 1}', '', '', '']);
      _newRowIndex = newIndex;
    });
  }

  // Modified to only check for rows being edited
  bool _hasUnsavedChanges() {
    return _editingIndex != null || _newRowIndex != null;
  }

  void _updatePeriodNumbers() {
    if (_routines[_selectedDay] == null) return;
    
    for (int i = 0; i < _routines[_selectedDay]!.length; i++) {
      _routines[_selectedDay]![i][0] = '${i + 1}';
    }
  }

  @override
  void dispose() {
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
