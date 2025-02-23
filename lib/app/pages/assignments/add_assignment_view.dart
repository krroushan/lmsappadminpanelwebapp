// add assignment view

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';
import '../../widgets/widgets.dart';
import 'package:go_router/go_router.dart';
//import '../../core/api_service/assignment_service.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';

class AddAssignmentView extends StatefulWidget {
  const AddAssignmentView({super.key});

  @override
  State<AddAssignmentView> createState() => _AddAssignmentViewState();
}

class _AddAssignmentViewState extends State<AddAssignmentView> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String token = '';

  // Controllers for form fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();

  Future<void> _createAssignment() async {
    setState(() => _isLoading = true);
    try {
      // final assignmentService = AssignmentService();
      
      // final response = await assignmentService.createAssignment(
      //   titleController.text,
      //   descriptionController.text,
      //   dueDateController.text,
      //   int.parse(pointsController.text),
      //   token
      // );

      // if (response.success) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Assignment created successfully', style: TextStyle(color: Colors.green))),
      //   );
        context.go('/dashboard/assignments');
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(response.message, style: const TextStyle(color: Colors.red))),
      //   );
      // }
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
            key: formKey,
            child: ShadowContainer(
              headerText: 'Add Assignment',
              child: ResponsiveGridRow(
                children: [
                  ResponsiveGridCol(
                    lg: 12,
                    md: 12,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Assignment Title',
                        inputField: TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            hintText: 'Enter assignment title',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter assignment title';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                  ResponsiveGridCol(
                    lg: 12,
                    md: 12,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Description',
                        inputField: TextFormField(
                          controller: descriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Enter assignment description',
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

                  ResponsiveGridCol(
                    lg: _lg,
                    md: _md,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Due Date',
                        inputField: TextFormField(
                          controller: dueDateController,
                          decoration: InputDecoration(
                            hintText: 'Select due date',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2025),
                                );
                                if (date != null) {
                                  dueDateController.text = date.toIso8601String().split('T')[0];
                                }
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select due date';
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
                        labelText: 'Points',
                        inputField: TextFormField(
                          controller: pointsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Enter points',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter points';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ),
                  ),

                  ResponsiveGridCol(
                    lg: 12,
                    md: 12,
                    xl: 12,
                    child: Padding(
                      padding: EdgeInsets.all(_sizeInfo.innerSpacing / 2),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: _isLoading ? null : () {
                          if (formKey.currentState?.validate() == true) {
                            _createAssignment();
                          }
                        },
                        child: _isLoading 
                          ? const CircularProgressIndicator() 
                          : const Text('Create Assignment'),
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
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    pointsController.dispose();
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


