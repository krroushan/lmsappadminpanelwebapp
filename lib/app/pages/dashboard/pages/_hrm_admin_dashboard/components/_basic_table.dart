import 'package:flutter/material.dart';

class BasicTable extends StatefulWidget {
  const BasicTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  final List<DataColumn> columns;
  final List<DataRow> rows;

  @override
  State<BasicTable> createState() => _BasicTableState();
}

class _BasicTableState extends State<BasicTable> {
  late final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          controller: scrollController,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsetsDirectional.only(bottom: 16),
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: Theme(
                      data: _theme.copyWith(
                        dividerTheme: _theme.dividerTheme.copyWith(
                          color: _theme.colorScheme.outline,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: DataTable(
                          headingTextStyle:
                              _theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          headingRowColor: WidgetStateProperty.all<Color?>(
                            _theme.colorScheme.tertiaryContainer,
                          ),
                          dividerThickness: 0,
                          border: const TableBorder(
                            horizontalInside: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          columns: widget.columns,
                          rows: widget.rows,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
