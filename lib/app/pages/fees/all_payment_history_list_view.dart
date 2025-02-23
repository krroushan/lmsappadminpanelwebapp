//  all payment history list view

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:iconly/iconly.dart';

// 🌎 Project imports:
import '../../widgets/widgets.dart';
import '../../core/theme/_app_colors.dart';

class AllPaymentHistoryListView extends StatefulWidget {
  const AllPaymentHistoryListView({super.key});

  @override
  State<AllPaymentHistoryListView> createState() => _AllPaymentHistoryListViewState();
}

class _AllPaymentHistoryListViewState extends State<AllPaymentHistoryListView> {
  bool _isLoading = true;
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _rowsPerPage = 10;
  int _totalPages = 0;
  List<Map<String, dynamic>> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _fetchPaymentHistory();
    _filteredData = _generateDummyData();
  }

  Future<void> _fetchPaymentHistory() async {
    // TODO: Implement API call to fetch payment history
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    setState(() => _isLoading = false);
  }

  List<Map<String, dynamic>> _generateDummyData() {
    final List<Map<String, dynamic>> dummyData = [
      {
        'txnId': '#TXN123456',
        'date': '20 Mar 2024',
        'time': '10:30 AM',
        'name': 'John Doe',
        'feeType': 'Tuition Fee',
        'amount': '₹5,000.00',
        'status': 'Paid',
      },
      {
        'txnId': '#TXN123457',
        'date': '19 Mar 2024',
        'time': '02:15 PM',
        'name': 'Jane Smith',
        'feeType': 'Library Fee',
        'amount': '₹1,500.00',
        'status': 'Pending',
      },
      {
        'txnId': '#TXN123458',
        'date': '18 Mar 2024',
        'time': '11:45 AM',
        'name': 'Mike Johnson',
        'feeType': 'Exam Fee',
        'amount': '₹2,500.00',
        'status': 'Paid',
      },
      {
        'txnId': '#TXN123459',
        'date': '18 Mar 2024',
        'time': '09:20 AM',
        'name': 'Sarah Williams',
        'feeType': 'Sports Fee',
        'amount': '₹3,000.00',
        'status': 'Paid',
      },
      {
        'txnId': '#TXN123460',
        'date': '17 Mar 2024',
        'time': '03:45 PM',
        'name': 'David Brown',
        'feeType': 'Laboratory Fee',
        'amount': '₹2,000.00',
        'status': 'Pending',
      },
      {
        'txnId': '#TXN123461',
        'date': '17 Mar 2024',
        'time': '01:30 PM',
        'name': 'Emily Davis',
        'feeType': 'Annual Fee',
        'amount': '₹10,000.00',
        'status': 'Paid',
      },
      {
        'txnId': '#TXN123462',
        'date': '16 Mar 2024',
        'time': '11:00 AM',
        'name': 'Michael Wilson',
        'feeType': 'Transport Fee',
        'amount': '₹1,800.00',
        'status': 'Pending',
      },
      {
        'txnId': '#TXN123463',
        'date': '16 Mar 2024',
        'time': '10:15 AM',
        'name': 'Lisa Anderson',
        'feeType': 'Tuition Fee',
        'amount': '₹5,000.00',
        'status': 'Paid',
      },
      {
        'txnId': '#TXN123464',
        'date': '15 Mar 2024',
        'time': '04:30 PM',
        'name': 'Robert Taylor',
        'feeType': 'Computer Fee',
        'amount': '₹2,500.00',
        'status': 'Paid',
      },
      {
        'txnId': '#TXN123465',
        'date': '15 Mar 2024',
        'time': '02:00 PM',
        'name': 'Emma Martinez',
        'feeType': 'Activity Fee',
        'amount': '₹1,200.00',
        'status': 'Pending',
      },
    ];

    return dummyData;
  }

  void _filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = _generateDummyData();
      } else {
        _filteredData = _generateDummyData().where((data) {
          // Only search by transaction ID and student name
          return data['txnId'].toString().toLowerCase().contains(query.toLowerCase()) ||
              data['name'].toString().toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: sizeInfo.padding,
        child: ShadowContainer(
          showHeader: false,
          contentPadding: EdgeInsets.zero,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 481;
                final isTablet = constraints.maxWidth < 992 && constraints.maxWidth >= 481;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar section
                    Padding(
                      padding: sizeInfo.padding,
                      child: TextFormField(
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Search payments...',
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: AcnooAppColors.kPrimary700,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: const Icon(IconlyLight.search, color: AcnooAppColors.kWhiteColor),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() => _searchQuery = value);
                          _filterData(value);
                        },
                      ),
                    ),

                    // Payment history table
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            child: paymentHistoryTable(context),
                          ),

                    // Pagination
                    if (!isMobile && !isTablet)
                      Padding(
                        padding: sizeInfo.padding,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Showing 1 to 10 of 100 entries'),
                            DataTablePaginator(
                              currentPage: _currentPage + 1,
                              totalPages: _totalPages,
                              onPreviousTap: () {
                                if (_currentPage > 0) {
                                  setState(() => _currentPage--);
                                }
                              },
                              onNextTap: () {
                                setState(() => _currentPage++);
                              },
                            ),
                          ],
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

  Widget paymentHistoryTable(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Theme.of(context).colorScheme.outline,
        dataTableTheme: DataTableTheme.of(context).copyWith(
          headingRowColor: MaterialStateColor.resolveWith(
            (states) => AcnooAppColors.kPrimary50,
          ),
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AcnooAppColors.kPrimary900,
          ),
          dataRowMaxHeight: 65,
          dataRowMinHeight: 65,
          horizontalMargin: 24,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 350, // Accounting for padding
          ),
          child: DataTable(
            columnSpacing: 24,
            horizontalMargin: 24,
            columns: _buildColumns(MediaQuery.of(context).size.width),
            dataRowMaxHeight: 65,
            dataRowMinHeight: 65,
            rows: _generateDummyRows(),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(double availableWidth) {
    // Remove the fixed width constraints from header labels
    return [
      const DataColumn(
        label: Text(
          'Txn ID',
          style: TextStyle(overflow: TextOverflow.ellipsis),
        ),
      ),
      const DataColumn(
        label: Text(
          'Paid Date',
          style: TextStyle(overflow: TextOverflow.ellipsis),
        ),
      ),
      const DataColumn(
        label: Text(
          'Student Name',
          style: TextStyle(overflow: TextOverflow.ellipsis),
        ),
      ),
      const DataColumn(
        label: Text(
          'Fee Type',
          style: TextStyle(overflow: TextOverflow.ellipsis),
        ),
      ),
      const DataColumn(
        label: Text(
          'Amount',
          style: TextStyle(overflow: TextOverflow.ellipsis),
        ),
      ),
      const DataColumn(
        label: Text(
          'Status',
          style: TextStyle(overflow: TextOverflow.ellipsis),
        ),
      ),
      const DataColumn(
        label: Text(
          'Actions',
          style: TextStyle(overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
  }

  List<DataRow> _generateDummyRows() {
    return _filteredData.map((data) => _buildDataRow(data)).toList();
  }

  DataRow _buildDataRow(Map<String, dynamic> data) {
    final bool isPaid = data['status'] == 'Paid';
    final Color statusColor = isPaid ? AcnooAppColors.kSuccess : AcnooAppColors.kWarning;

    return DataRow(cells: [
      DataCell(
        Text(
          data['txnId'],
          style: const TextStyle(
            color: AcnooAppColors.kPrimary700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      DataCell(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['date'],
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              data['time'],
              style: const TextStyle(
                fontSize: 12,
                color: AcnooAppColors.kDark3,
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Text(
          data['name'],
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      DataCell(
        Text(
          data['feeType'],
          style: const TextStyle(
            color: AcnooAppColors.kDark2,
          ),
        ),
      ),
      DataCell(
        Text(
          data['amount'],
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: statusColor,
          ),
        ),
      ),
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: statusColor.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                data['status'],
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: 'View Details',
              child: IconButton(
                icon: const Icon(Icons.visibility),
                color: AcnooAppColors.kPrimary600,
                onPressed: () {/* TODO: Implement view details */},
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Print Receipt',
              child: IconButton(
                icon: const Icon(Icons.receipt_long),
                color: AcnooAppColors.kInfo,
                onPressed: () {/* TODO: Implement print receipt */},
              ),
            ),
          ],
        ),
      ),
    ]);
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


