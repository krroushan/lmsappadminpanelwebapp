// all fees list view

import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../core/theme/_app_colors.dart';
import '../../widgets/widgets.dart';

class AllFeesListView extends StatefulWidget {
  const AllFeesListView({super.key});

  @override
  State<AllFeesListView> createState() => _AllFeesListViewState();
}

class _AllFeesListViewState extends State<AllFeesListView> {
  bool _isLoading = true;
  String _searchQuery = '';
  List<Map<String, dynamic>> _fees = [];

  @override
  void initState() {
    super.initState();
    _fetchFees();
  }

  Future<void> _fetchFees() async {
    // Simulating API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _fees = [
        {
          'id': '1',
          'name': 'Registration Fee',
          'amount': 500.00,
          'description': 'One-time registration fee for new students',
          'dueDate': '2024-04-30',
          'class': 'Class X',
          'board': 'CBSE',
        },
        {
          'id': '2',
          'name': 'Tuition Fee',
          'amount': 2500.00,
          'description': 'Monthly tuition fee',
          'dueDate': '2024-04-15',
          'class': 'Class XI',
          'board': 'ICSE',
        },
        {
          'id': '3',
          'name': 'Library Fee',
          'amount': 100.00,
          'description': 'Annual library maintenance fee',
          'dueDate': '2024-05-01',
          'class': 'Class XII',
          'board': 'State Board',
        },
        {
          'id': '4',
          'name': 'Laboratory Fee',
          'amount': 800.00,
          'description': 'Science lab equipment and maintenance',
          'dueDate': '2024-05-15',
          'class': 'Class IX',
          'board': 'CBSE',
        },
        {
          'id': '5',
          'name': 'Sports Fee',
          'amount': 300.00,
          'description': 'Sports equipment and facilities',
          'dueDate': '2024-04-20',
          'class': 'Class X',
          'board': 'ICSE',
        },
        {
          'id': '6',
          'name': 'Computer Lab Fee',
          'amount': 600.00,
          'description': 'Computer lab maintenance and software',
          'dueDate': '2024-05-10',
          'class': 'Class VIII',
          'board': 'CBSE',
        },
        {
          'id': '7',
          'name': 'Development Fee',
          'amount': 1500.00,
          'description': 'School infrastructure development',
          'dueDate': '2024-06-01',
          'class': 'Class VII',
          'board': 'State Board',
        },
        {
          'id': '8',
          'name': 'Examination Fee',
          'amount': 400.00,
          'description': 'Term examination fee',
          'dueDate': '2024-05-20',
          'class': 'Class VI',
          'board': 'ICSE',
        },
        {
          'id': '9',
          'name': 'Transportation Fee',
          'amount': 1200.00,
          'description': 'School bus service monthly fee',
          'dueDate': '2024-04-25',
          'class': 'Class X',
          'board': 'CBSE',
        },
        {
          'id': '10',
          'name': 'Activity Fee',
          'amount': 350.00,
          'description': 'Extra-curricular activities',
          'dueDate': '2024-05-05',
          'class': 'Class XI',
          'board': 'State Board',
        },
      ];
      _isLoading = false;
    });
  }

  void _setSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<Map<String, dynamic>> get _filteredFees {
    if (_searchQuery.isEmpty) return _fees;
    
    final query = _searchQuery.toLowerCase();
    return _fees.where((fee) {
      return fee['name'].toString().toLowerCase().contains(query) ||
          fee['description'].toString().toLowerCase().contains(query) ||
          fee['class'].toString().toLowerCase().contains(query) ||
          fee['board'].toString().toLowerCase().contains(query) ||
          fee['amount'].toString().contains(query) ||
          fee['dueDate'].toString().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Padding(
        padding: _sizeInfo.padding,
        child: ShadowContainer(
          showHeader: false,
          contentPadding: EdgeInsets.zero,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final isMobile = constraints.maxWidth < 481;
                final isTablet = constraints.maxWidth < 992 && constraints.maxWidth >= 481;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    isMobile
                        ? Padding(
                            padding: _sizeInfo.padding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Spacer(),
                                    _addFeeButton(textTheme),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                _searchFormField(textTheme: textTheme),
                              ],
                            ),
                          )
                        : Padding(
                            padding: _sizeInfo.padding,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: _searchFormField(textTheme: textTheme),
                                ),
                                Spacer(flex: isTablet || isMobile ? 1 : 2),
                                _addFeeButton(textTheme),
                              ],
                            ),
                          ),

                    // Fees list section
                    Padding(
                      padding: _sizeInfo.padding,
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _filteredFees.isEmpty
                              ? Center(
                                  child: Text(
                                    'No fees found',
                                    style: textTheme.titleMedium?.copyWith(
                                      color: AcnooAppColors.kDark3,
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isMobile ? 1 : isTablet ? 2 : 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 3,
                                  ),
                                  itemCount: _filteredFees.length,
                                  itemBuilder: (context, index) {
                                    final fee = _filteredFees[index];
                                    return FeeCard(
                                      fee: fee,
                                      onEdit: () => context.go('/dashboard/fees/edit-fee/${fee['id']}'),
                                      onDelete: () {/* Implement delete functionality */},
                                    );
                                  },
                                ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _addFeeButton(TextTheme textTheme) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () => context.go('/dashboard/fees/add-fee'),
      label: Text(
        'Add New Fee',
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      icon: const Icon(
        Icons.add_circle_outline_outlined,
        color: AcnooAppColors.kWhiteColor,
        size: 20.0,
      ),
    );
  }

  TextFormField _searchFormField({required TextTheme textTheme}) {
    final lang = l.S.of(context);
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        hintText: '${lang.search}...',
        hintStyle: textTheme.bodySmall,
        suffixIcon: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: AcnooAppColors.kPrimary700,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: const Icon(IconlyLight.search, color: AcnooAppColors.kWhiteColor),
        ),
      ),
      onChanged: _setSearchQuery,
    );
  }
}

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  
  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}

class FeeCard extends StatelessWidget {
  final Map<String, dynamic> fee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FeeCard({
    super.key,
    required this.fee,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AcnooAppColors.kWhiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: AcnooAppColors.kPrimary100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.currency_rupee, size: 30, color: AcnooAppColors.kPrimary700),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fee['name'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Due: ${fee['dueDate']} - ₹${fee['amount'].toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AcnooAppColors.kPrimary700,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${fee['class']} | ${fee['board']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AcnooAppColors.kDark3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: AcnooAppColors.kInfo),
                  onPressed: onEdit,
                  tooltip: 'Edit Fee',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AcnooAppColors.kError),
                  onPressed: onDelete,
                  tooltip: 'Delete Fee',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}