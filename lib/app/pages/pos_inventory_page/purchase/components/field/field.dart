import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../../../../generated/l10n.dart' as l;
import '../../../../../widgets/widgets.dart';
import '../purchase_field/payment.dart';

class Field extends StatefulWidget {
  const Field({super.key});

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _innerSpacing = responsiveValue<double>(
      context,
      xs: 16,
      lg: 24,
    );
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ShadowContainer(
      showHeader: false,
      contentPadding: const EdgeInsets.only(right: 5),
      child: ResponsiveGridRow(
        children: [
          ResponsiveGridCol(
            lg: 6,
            md: 6,
            child: Padding(
              padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
              child: TextFormField(
                decoration: InputDecoration(
                  //labelText: 'Receive Amount',
                  labelText: lang.receiveAmount,
                  labelStyle: textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  // hintText: 'Ex:25',
                  hintText: lang.ex25,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ),
          ResponsiveGridCol(
            lg: 6,
            md: 6,
            xs: 6,
            child: Padding(
              padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
              child: TextFormField(
                decoration: InputDecoration(
                  //labelText: 'Change Amount',
                  labelText: lang.changeAmount,
                  labelStyle: textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    //color: AcnooAppColors.kNeutral700,
                  ),
                  hintText: '0',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ),
          ResponsiveGridCol(
            lg: 6,
            md: 6,
            xs: 6,
            child: Padding(
              padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
              child: TextFormField(
                decoration: InputDecoration(
                  //labelText: 'Due Amount',
                  labelText: lang.dueAmount,
                  labelStyle: textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    //color: AcnooAppColors.kNeutral700
                  ),
                  hintText: '0',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ),
          ResponsiveGridCol(
            lg: 6,
            md: 6,
            child: Padding(
              padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
              child: const Payment(),
            ),
          ),
          ResponsiveGridCol(
            lg: 6,
            md: 6,
            child: Padding(
              padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
              child: TextFormField(
                decoration: InputDecoration(
                  //labelText: 'Note',
                  labelText: lang.note,
                  labelStyle: textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    // color: AcnooAppColors.kNeutral700
                  ),
                  //hintText: 'Ex: out of limit',
                  hintText: lang.exOutOfLimit,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ),
          ResponsiveGridCol(
            lg: 6,
            md: 6,
            child: Padding(
              padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
              child: TextFormField(
                decoration: InputDecoration(
                  //labelText: 'Transaction ID',
                  labelText: lang.transactionID,
                  labelStyle: textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    //color: AcnooAppColors.kNeutral700
                  ),
                  //hintText: 'Ex: HF5gJ7',
                  hintText: lang.exHF5gJ7,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
