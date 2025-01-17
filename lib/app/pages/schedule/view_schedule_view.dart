import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../widgets/widgets.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class ViewScheduleView extends StatefulWidget {
  const ViewScheduleView({super.key});

  @override
  State<ViewScheduleView> createState() => _ViewScheduleViewState();
}

class _ViewScheduleViewState extends State<ViewScheduleView> {
  var logger = Logger();
  String token = '';
  String _selectedDay = _getCurrentDay();

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

  // Add these lists at the top of the _ViewScheduleViewState class
  final List<String> _subjects = [
    'Mathematics',
    'Science',
    'English',
    'History',
    'Physics',
    'Chemistry',
    'Biology',
    'Computer',
    'Geography',
    'Literature',
    'Physical Education',
    'Art',
    'Music'
  ];

  final List<String> _teachers = [
    'Mr. Smith',
    'Mrs. Johnson',
    'Ms. Davis',
    'Mr. Wilson',
    'Mrs. Brown',
    'Mr. White',
    'Ms. Green',
    'Mr. Anderson',
    'Mrs. Clark',
    'Mr. Lewis',
    'Mr. Mozart',
    'Ms. Parker'
  ];

  static String _getCurrentDay() {
    final now = DateTime.now();
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[now.weekday - 1];
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
    const _lg = 6;
    const _md = 6;

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
        child: ShadowContainer(
          headerText: 'Class 10 Schedule/Routine',
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
                onPressed: () => setState(() => _selectedDay = day),
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
              onPressed: () => setState(() {
                if (_routines[_selectedDay] == null) {
                  _routines[_selectedDay] = [];
                }
                _routines[_selectedDay]!.add(['${_routines[_selectedDay]!.length + 1}', '', '', '']);
              }),
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
                  onPressed: () => setState(() => _routines[_selectedDay]!.removeAt(index)),
                ),
              ] else ...[
                // Show edit and delete for existing rows
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
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  color: Colors.red,
                  onPressed: () => setState(() => _routines[_selectedDay]!.removeAt(index)),
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
                        final newStartTime = '${picked.format(context)}';
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
                        final newEndTime = '${picked.format(context)}';
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
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: DropdownButtonFormField<String>(
          value: initialValue.isEmpty ? null : initialValue,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          ),
          hint: Text(hintText!),
          items: _subjects.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
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
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: DropdownButtonFormField<String>(
          value: initialValue.isEmpty ? null : initialValue,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          ),
          hint: Text(hintText!),
          items: _teachers.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
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
