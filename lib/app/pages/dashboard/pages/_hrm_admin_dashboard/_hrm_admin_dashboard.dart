// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:magicoon_icons/MagicoonIcons_icons.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/theme/theme.dart';
import '../../../../widgets/widgets.dart';
import 'components/_components.dart' as comp;

class HRMAdminDashboard extends StatelessWidget {
  const HRMAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final _mqSize = MediaQuery.sizeOf(context);
    final lang = l.S.of(context);
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      lg: 24,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(_padding / 2.5),
        child: Column(
          children: [
            // Overview Tiles
            ResponsiveGridRow(
              children: List.generate(
                _overviewCard.length,
                (index) {
                  final _overview = _overviewCard[index];
                  return ResponsiveGridCol(
                    lg: 3,
                    md: 6,
                    child: Padding(
                      padding: EdgeInsetsDirectional.all(_padding / 2.5),
                      child: OverviewCardWidget2(
                        containerColor: _overview.$4.withOpacity(0.25),
                        containerIcon: Icon(
                          _overview.$5,
                          color: _overview.$4,
                        ),
                        title: _overview.$1.toString(),
                        subTitle: _overview.$2,
                        text: _overview.$3,
                        bottomIcon: Icon(
                          index % 2 == 0
                              ? Icons.arrow_downward_outlined
                              : Icons.arrow_upward_outlined,
                          color: index % 2 == 0
                              ? AcnooAppColors.kError
                              : AcnooAppColors.kSuccess,
                          size: 16,
                        ),
                        progressColor: _overview.$4,
                        progressBackgroundColor: _overview.$4.withOpacity(0.25),
                        percentValue: 0.20 * (index + 1),
                      ),
                    ),
                  );
                },
              ),
            ),

            ResponsiveGridRow(
              children: [
                // Left Side Contents
                ResponsiveGridCol(
                  lg: _mqSize.width < 1700 ? 7 : 8,
                  child: ResponsiveGridRow(
                    children: [
                      // Sales Report
                      ResponsiveGridCol(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                            height: 460,
                          ),
                          child: ShadowContainer(
                            margin: EdgeInsetsDirectional.all(_padding / 2.5),
                            contentPadding:
                                const EdgeInsetsDirectional.fromSTEB(
                              16,
                              28,
                              16,
                              20,
                            ),
                           // headerText: 'Salary Report',
                            headerText:lang.salaryReport,
                            trailing: const FilterDropdownButton(),
                            child: const comp.SalaryReportLineChart(),
                          ),
                        ),
                      ),

                      // Leave Request Table
                      ResponsiveGridCol(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                            height: 380,
                          ),
                          child: ShadowContainer(
                            margin: EdgeInsetsDirectional.all(_padding / 2.5),
                            contentPadding: EdgeInsetsDirectional.zero,
                            //headerText: 'Leave Request',
                            headerText: lang.leaveRequest,
                            child: const comp.LeaveRequestTable(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Side Contents
                ResponsiveGridCol(
                  lg: _mqSize.width < 1700 ? 5 : 4,
                  child: ResponsiveGridRow(
                    children: [
                      // Upcoming Birthday'
                      ResponsiveGridCol(
                        lg: 12,
                        md: _mqSize.width < 768 ? 12 : 6,
                        child: ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                            height: responsiveValue<double?>(
                              context,
                              xs: 350,
                              lg: 277.5,
                            ),
                          ),
                          child: ShadowContainer(
                            margin: EdgeInsetsDirectional.all(_padding / 2.5),
                            contentPadding: EdgeInsetsDirectional.zero,
                            //headerText: 'Upcoming Birthday',
                            headerText: lang.upcomingBirthday,
                            child: comp.BasicTable(
                              columns: [
                                // "Employee ID",
                                // "Employee Name",
                                // "Birthday Date",
                                lang.employeeId,
                                lang.employeeName,
                                lang.birthdayDate,
                              ].map((c) => DataColumn(label: Text(c))).toList(),
                              rows: List.generate(
                                5,
                                (index) {
                                  return const DataRow(
                                    cells: [
                                      DataCell(Text('#1256114')),
                                      DataCell(Text('Leslie Alexander')),
                                      DataCell(Text('26 Jun 2002')),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Exit Employee
                      ResponsiveGridCol(
                        lg: 12,
                        md: _mqSize.width < 768 ? 12 : 6,
                        child: ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                            height: responsiveValue<double?>(
                              context,
                              xs: 350,
                              lg: 277.5,
                            ),
                          ),
                          child: ShadowContainer(
                            margin: EdgeInsetsDirectional.all(_padding / 2.5),
                            contentPadding: EdgeInsetsDirectional.zero,
                           // headerText: 'Exit Employee',
                            headerText: lang.exitEmployee,
                            child: comp.BasicTable(
                              columns: [
                                // "Employee ID",
                                // "Employee Name",
                                // "Date",
                                lang.employeeId,
                                lang.employeeName,
                                lang.date,
                              ].map((c) => DataColumn(label: Text(c))).toList(),
                              rows: List.generate(
                                5,
                                (index) {
                                  return const DataRow(
                                    cells: [
                                      DataCell(Text('#1256114')),
                                      DataCell(Text('Leslie Alexander')),
                                      DataCell(Text('26 Jun 2002')),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Employee Attendance
                      ResponsiveGridCol(
                        md: 12,
                        child: ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                            height: responsiveValue<double?>(
                              context,
                              xs: 350,
                              lg: 285,
                            ),
                          ),
                          child: ShadowContainer(
                            margin: EdgeInsetsDirectional.all(_padding / 2.5),
                            contentPadding: EdgeInsetsDirectional.zero,
                            //headerText: 'Employee Attendance',
                            headerText: lang.employeeAttendance,
                            child: const Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: comp.EmployeeAttendancePiChart(),
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
    );
  }
}

List<(num, String, String, Color, IconData)> get _overviewCard {
  return [
    (
      20,
      // "Total Employees",
      l.S.current.totalEmployees,
      //"18 Today Present",
   " 18 ${l.S.current.todayPresent}",
      const Color(0xff009F5E),
      MagicoonIcons.users_group1,
    ),
    (
      10000,
      // "This Month Leave Request",
      l.S.current.thisMonthLeaveRequest,
      //"12 Since Last Month Leave Request",
   "12 ${l.S.current.sinceLastMonthLeaveRequest}",
      const Color(0xff0D9AFF),
      MagicoonIcons.user_minus2,
    ),
    (
      20,
      // "This Month Salary",
      l.S.current.thisMonthSalary,
      //"\$8,000 Since Last Month Salary",
      "\$8,000 ${l.S.current.sinceLastMonthSalary}",
      const Color(0xff8B4DFF),
      MagicoonIcons.sack_dollar2,
    ),
    (
      8000,
      // "This Month Expenses",
      l.S.current.thisMonthExpenses,
      "\$10,000 ${l.S.current.sinceLastMonthExpenses}",
      const Color(0xffE13F3D),
      MagicoonIcons.money_bills,
    ),
  ];
}
