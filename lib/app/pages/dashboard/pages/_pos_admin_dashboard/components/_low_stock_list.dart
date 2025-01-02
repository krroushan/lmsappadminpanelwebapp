// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../../generated/l10n.dart' as l;
import '../../../../../core/theme/theme.dart';

class LowStockListWidget extends StatefulWidget {
  const LowStockListWidget({super.key});

  @override
  State<LowStockListWidget> createState() => _LowStockListWidgetState();
}

class _LowStockListWidgetState extends State<LowStockListWidget> {
  late final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Scrollbar(
      controller: _scrollController,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 16, 20, 16),
        itemCount: _list.length * 2,
        itemBuilder: (context, index) {
          final _item =
              [..._list.entries, ..._list.entries.toList().reversed][index];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  _item.key,
                  style: _theme.textTheme.bodyMedium?.copyWith(),
                ),
              ),
              Text(
                _item.value,
                style: _theme.textTheme.bodyMedium?.copyWith(
                  color: AcnooAppColors.kWarning,
                ),
              ),
            ],
          );
        },
        separatorBuilder: (c, i) => const SizedBox(height: 14),
      ),
    );
  }
}

Map<String, String> get _list => {
      //"Apple": "5 Kg",
      l.S.current.apple: "5 Kg",
      //"Bananas": "8 Pcs",
      l.S.current.bananas: "8 Pcs",
      // "Fresh Soyabean Oil ": "15 Ltr",
      l.S.current.freshSoyabeanOil: "15 Ltr",
      // "Cabbage": "5 Kg",
      l.S.current.cabbage: "5 Kg",
      //"Rice": "5 Kg",
      l.S.current.rice: "5 Kg",
      //"Fresh Fruits": "5 Kg",
      l.S.current.freshFruits: "5 Kg",
      //"Beef Meat": "5 Kg",
      l.S.current.beefMeat: "5 Kg",
      //"Beetroot": "5 Kg",
      l.S.current.beetroot: "5 Kg",
      //"Potato": "5 Kg",
      l.S.current.potato: "5 Kg",
    };
