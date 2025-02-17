import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../widgets/widgets.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

import '../../models/classes/class_info.dart';
import '../../models/subject/subject.dart';
import '../../models/board/board.dart';

import '../../core/api_service/subject_service.dart';
import '../../core/api_service/class_service.dart';
import '../../core/api_service/board_service.dart';
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
  String _selectedBoard = '';
  String _selectedYear = '';
  String _selectedClass = '';
  final List<String> _years = ['2025', '2026', '2027'];
  
  List<Subject> _subjectList = [];
  List<ClassInfo> _classList = [];
  List<Board> _boardList = [];

  final SubjectService _subjectService = SubjectService();
  final ClassService _classService = ClassService();
  final BoardService _boardService = BoardService();

  bool _loading = false;

  Future<void> _createRoutine() async {
    _loading = true;
    final url = 'https://apkobi.com/api/routine/create';
    final body = {
      'board': _selectedBoard,
      'class': _selectedClass,
      'year': int.parse(_selectedYear),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        logger.d('Routine created successfully');
        // Optionally show a success message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Routine created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/dashboard/schedule/all-schedule');

      } else {
        _loading = false;
        logger.e('Failed to create routine1: ${response.body}');
        // Optionally show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create routine1'),
            backgroundColor: Colors.red,
          ),
        );
      }

    } catch (e) {
      _loading = false;
      logger.e('Error creating routine2: $e');
      // Optionally show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create routine2'),
          backgroundColor: Color.fromARGB(255, 255, 106, 0),
        ),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchSubjectList();
    _fetchClassList();
    _fetchBoardList();
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

  // fetch board list
  Future<void> _fetchBoardList() async {
    final boardList = await _boardService.fetchAllBoards(token);
    setState(() {
      _boardList = boardList;
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
        child: _buildSelectionPanel(),
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
                            });
                          }
                        : null,

                    child: _loading ? const CircularProgressIndicator() : const Text('Create Routine'),
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
      items: _boardList.map((board) {

        return DropdownMenuItem(
          value: board.id.toString(),
          child: Text(board.name),
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
          value: cls.id.toString(),
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
