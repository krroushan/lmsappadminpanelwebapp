// add fees view

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../widgets/widgets.dart';
import '../../core/theme/_app_colors.dart';

class AddFeesView extends StatefulWidget {
  const AddFeesView({super.key});

  @override
  State<AddFeesView> createState() => _AddFeesViewState();
}

class _AddFeesViewState extends State<AddFeesView> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController boardController = TextEditingController();

  Future<void> _createFee() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Implement fee creation logic
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fee created successfully'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/dashboard/fees/all-fees');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating fee: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dueDateController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const lg = 4;
    const md = 6;

    final sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 992,
          value: _SizeInfo(
            fontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    return Scaffold(
      body: ListView(
        padding: sizeInfo.padding,
        children: [
          Form(
            key: formKey,
            child: ShadowContainer(
              headerText: 'Add Fee',
              child: ResponsiveGridRow(
                children: [
                  // Fee Name
                  ResponsiveGridCol(
                    lg: lg,
                    md: md,
                    child: Padding(
                      padding: EdgeInsets.all(sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Fee Name',
                        inputField: TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter fee name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter fee name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  // Amount
                  ResponsiveGridCol(
                    lg: lg,
                    md: md,
                    child: Padding(
                      padding: EdgeInsets.all(sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Amount (₹)',
                        inputField: TextFormField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Enter amount',
                            prefixText: '₹ ',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid amount';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  // Due Date
                  ResponsiveGridCol(
                    lg: lg,
                    md: md,
                    child: Padding(
                      padding: EdgeInsets.all(sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Due Date',
                        inputField: TextFormField(
                          controller: dueDateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: 'Select due date',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: _selectDate,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select due date';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  // Class
                  ResponsiveGridCol(
                    lg: lg,
                    md: md,
                    child: Padding(
                      padding: EdgeInsets.all(sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Class',
                        inputField: TextFormField(
                          controller: classController,
                          decoration: const InputDecoration(
                            hintText: 'Enter class',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter class';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  // Board
                  ResponsiveGridCol(
                    lg: lg,
                    md: md,
                    child: Padding(
                      padding: EdgeInsets.all(sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Board',
                        inputField: TextFormField(
                          controller: boardController,
                          decoration: const InputDecoration(
                            hintText: 'Enter board',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter board';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  // Description
                  ResponsiveGridCol(
                    lg: 12,
                    md: 12,
                    child: Padding(
                      padding: EdgeInsets.all(sizeInfo.innerSpacing / 2),
                      child: TextFieldLabelWrapper(
                        labelText: 'Description',
                        inputField: TextFormField(
                          controller: descriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Enter fee description',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  // Submit Button
                  ResponsiveGridCol(
                    lg: 12,
                    md: 12,
                    child: Padding(
                      padding: EdgeInsets.all(sizeInfo.innerSpacing / 2),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AcnooAppColors.kPrimary700,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (formKey.currentState?.validate() ?? false) {
                                  _createFee();
                                }
                              },
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Save Fee',
                                style: TextStyle(color: Colors.white),
                              ),
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
    nameController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    classController.dispose();
    boardController.dispose();
    super.dispose();
  }
}

class _SizeInfo {
  final double? fontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  
  const _SizeInfo({
    this.fontSize,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}


