import 'package:flutter/material.dart';
import '../../../../../core/theme/theme.dart';
import '../calender.dart';
import '../customer.dart';
import '../sale_warehouse.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  late List<SaleProduct> _filteredData;
  final ScrollController _scrollController = ScrollController();
  final List<SaleProduct> users = AllSale.allSale;
  final int _currentPage = 0;
  final int _rowsPerPage = 10;
  final String _searchQuery = '';
  final bool _selectAll = false;
  List<SaleProduct> get _currentPageData {
    if (_searchQuery.isNotEmpty) {
      _filteredData = users
          .where(
            (data) =>
                data.product
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                data.price.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                data.subtotal.contains(
                  _searchQuery,
                ),
          )
          .toList();
    } else {
      _filteredData = List.from(users);
    }

    int start = _currentPage * _rowsPerPage;
    int end = start + _rowsPerPage;
    return _filteredData.sublist(
        start, end > _filteredData.length ? _filteredData.length : end);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final styleColums = theme.textTheme.bodyMedium?.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w400,
    );
    return SingleChildScrollView(
      child: Container(
        height: 680,
        decoration: const BoxDecoration(
            border: Border(
          bottom: BorderSide(color: AcnooAppColors.kNeutral400),
          //right: BorderSide(color: AcnooAppColors.kNeutral400),
          left: BorderSide(color: AcnooAppColors.kNeutral400),
        )),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 17, 8, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(child: Calender()),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Invoice no.', border: OutlineInputBorder()),
                  ))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Row(
                children: [
                  Expanded(child: Customer()),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(child: SaleWarehouse())
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Theme(
                data: ThemeData(
                    dividerColor: theme.colorScheme.outline,
                    dividerTheme: DividerThemeData(
                      color: theme.colorScheme.outline,
                    )),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingTextStyle: textTheme.titleMedium,
                    dataTextStyle: textTheme.bodySmall,
                    headingRowColor:
                        WidgetStateProperty.all(theme.colorScheme.surface),
                    showBottomBorder: true,
                    columns: const [
                      DataColumn(label: Text('Product')),
                      DataColumn(label: Text('Qty')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Subtotal')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: _currentPageData.map(
                      (data) {
                        return DataRow(
                          cells: [
                            DataCell(Text(
                              data.product,
                              style: styleColums,
                            )),
                            const DataCell(CounterWidget()),
                            DataCell(Text(
                              data.price,
                              style: styleColums,
                            )),
                            DataCell(Text(
                              data.subtotal,
                              style: styleColums,
                            )),
                            DataCell(CloseButton(
                              color: const Color(0xffFF0000),
                              onPressed: () {},
                            )),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Divider(
                thickness: 1,
                height: 1,
                color: theme.colorScheme.outline,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 16),
                child: Text('Total Item : 2'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Sub Total'),
                            Container(
                              height: 40,
                              color: Colors.red,
                              width: 100,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Shipping'),
                            Container(
                              height: 40,
                              color: Colors.amber,
                              width: 100,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tax'),
                            Container(
                              height: 40,
                              width: 100,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount'),
                            Container(
                              height: 40,
                              color: Colors.amber,
                              width: 100,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                constraints: BoxConstraints.loose(const Size.fromHeight(48)),
                margin: const EdgeInsets.only(top: 36),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: SizedBox.fromSize(
                        size: const Size(double.maxFinite, 43),
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AcnooAppColors.kError,
                            side: const BorderSide(
                              color: AcnooAppColors.kError,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          //child: const Text('Cancel'),
                          child: Text("cancel"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: SizedBox.fromSize(
                        size: const Size(double.maxFinite, 43),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          //child: const Text('Submit'),
                          child: Text("submit"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: SizedBox.fromSize(
                        size: const Size(double.maxFinite, 43),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          //child: const Text('Submit'),
                          child: Text("submit"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SaleProduct {
  final String product;
  final String price;
  final String subtotal;

  SaleProduct({
    required this.product,
    required this.price,
    required this.subtotal,
  });

  @override
  String toString() =>
      'DataModel(product: $product, price: $price, subtotal: $subtotal, )';
}

class AllSale {
  static List<SaleProduct> allSale = [
    SaleProduct(product: 'Cabbage', price: '\$30.00', subtotal: '\$30.00'),
    SaleProduct(product: 'Bananas', price: '\$30.00', subtotal: '\$30.00'),
  ];
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 1;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 1) {
        _counter--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: _decrementCounter,
          child: Container(
            alignment: Alignment.center,
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xff7500FD)),
            ),
            child: const Padding(
              padding: EdgeInsets.zero,
              child: Icon(
                Icons.remove,
                size: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          '$_counter',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: _incrementCounter,
          child: Container(
            alignment: Alignment.center,
            height: 20,
            width: 20, // Button width
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AcnooAppColors.kPrimary600
                // border: Border.all(color: Color(0xff7500FD)),
                ),
            child: const Padding(
              padding: EdgeInsets.zero, // Zero padding
              child: Icon(
                Icons.add,
                color: AcnooAppColors.kWhiteColor,
                size: 16, // Adjust icon size if needed
              ),
            ),
          ),
        ),
      ],
    );
  }
}
