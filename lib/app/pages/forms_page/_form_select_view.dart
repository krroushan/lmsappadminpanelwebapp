// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/helpers/field_styles/field_styles.dart';
import '../../widgets/widgets.dart';

class FormSelectView extends StatefulWidget {
  const FormSelectView({super.key});

  @override
  State<FormSelectView> createState() => _FormSelectViewState();
}

class _FormSelectViewState extends State<FormSelectView> {
  late final scrollController = ScrollController();

  List<int?> selectedDropdownItems = [];

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);
    final _inputFieldStyle = AcnooInputFieldStyles(context);
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
            padding: EdgeInsetsDirectional.all(16),
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
          // Default Select
          ShadowContainer(
            //headerText: 'Default Select',
            headerText: lang.defaultSelect,
            child: ResponsiveGridRow(
              children: [
                // Basic Dropdown
                ResponsiveGridCol(
                  lg: _lg + 2,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      //labelText: 'Input with Placeholder',
                      labelText: lang.inputWithPlaceholder,
                      inputField: DropdownButtonFormField2(
                        menuItemStyleData: _dropdownStyle.menuItemStyle,
                        buttonStyleData: _dropdownStyle.buttonStyle,
                        iconStyleData: _dropdownStyle.iconStyle,
                        dropdownStyleData: _dropdownStyle.dropdownStyle,
                        // hint: const Text('Select you status'),
                        hint: Text(lang.selectYouStatus),
                        items: List.generate(
                          5,
                          (index) => DropdownMenuItem(
                            value: index + 1,
                            // child: Text('Status ${index + 1}'),
                            child: Text('${lang.status} ${index + 1}'),
                          ),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ),

                // Rounded Border Dropdown
                ResponsiveGridCol(
                  lg: _lg + 2,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      //labelText: 'Input with Placeholder',
                      labelText: lang.inputWithPlaceholder,
                      inputField: DropdownButtonFormField2(
                        menuItemStyleData: _dropdownStyle.menuItemStyle,
                        buttonStyleData: _dropdownStyle.buttonStyle,
                        iconStyleData: _dropdownStyle.iconStyle,
                        dropdownStyleData: _dropdownStyle.dropdownStyle,
                        //hint: const Text('Select you status'),
                        hint: Text(lang.selectYouStatus),
                        decoration: InputDecoration(
                          border: _inputFieldStyle.getRoundedBorder(),
                          enabledBorder: _inputFieldStyle.getRoundedBorder(
                            getRoundedBorderType:
                                RoundedBorderType.enabledBorder,
                          ),
                          focusedBorder: _inputFieldStyle.getRoundedBorder(
                            getRoundedBorderType:
                                RoundedBorderType.focusedBorder,
                          ),
                          errorBorder: _inputFieldStyle.getRoundedBorder(
                            getRoundedBorderType: RoundedBorderType.errorBorder,
                          ),
                          focusedErrorBorder: _inputFieldStyle.getRoundedBorder(
                            getRoundedBorderType:
                                RoundedBorderType.focusedErrorBorder,
                          ),
                          disabledBorder: _inputFieldStyle.getRoundedBorder(
                            getRoundedBorderType:
                                RoundedBorderType.disabledBorder,
                          ),
                        ),
                        items: List.generate(
                          5,
                          (index) => DropdownMenuItem(
                            value: index + 1,
                            // child: Text('Status ${index + 1}'),
                            child: Text('${lang.status} ${index + 1}'),
                          ),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ),

                // Basic Dropdown Disabled
                ResponsiveGridCol(
                  lg: _lg + 2,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      // labelText: 'Input with Placeholder',
                      labelText: lang.inputWithPlaceholder,
                      inputField: DropdownButtonFormField2(
                        menuItemStyleData: _dropdownStyle.menuItemStyle,
                        buttonStyleData: _dropdownStyle.buttonStyle,
                        iconStyleData: _dropdownStyle.iconStyle,
                        dropdownStyleData: _dropdownStyle.dropdownStyle,
                        //hint: const Text('Select you status'),
                        hint: Text(lang.selectYouStatus),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: _inputFieldStyle.disabledFieldColor,
                        ),
                        items: const [],
                      ),
                    ),
                  ),
                ),

                // Dashed Border Dropdown
                ResponsiveGridCol(
                  lg: _lg + 2,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      //labelText: 'Input with Placeholder',
                      labelText: lang.inputWithPlaceholder,
                      inputField: DropdownButtonFormField2(
                        menuItemStyleData: _dropdownStyle.menuItemStyle,
                        buttonStyleData: _dropdownStyle.buttonStyle,
                        iconStyleData: _dropdownStyle.iconStyle,
                        dropdownStyleData: _dropdownStyle.dropdownStyle,
                        //hint: const Text('Select you status'),
                        hint: Text(lang.selectYouStatus),
                        decoration: const InputDecoration(
                            // TODO: Fix Dashed Border Design later
                            ),
                        items: const [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: _sizeInfo.innerSpacing),

          // Menu Size
          ShadowContainer(
            // headerText: 'Menu Size',
            headerText: lang.menuSize,
            child: ResponsiveGridRow(
              children: [
                // Scrollable Menu
                ResponsiveGridCol(
                  lg: _lg + 2,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 100,
                        minHeight: 40,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _theme.colorScheme.outline,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _buildMenuList(
                        theme: _theme,
                        controller: scrollController,
                      ),
                    ),
                  ),
                ),

                // Unscrollable Menu
                ResponsiveGridCol(
                  lg: _lg + 2,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 100,
                        minHeight: 40,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _theme.colorScheme.outline,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Theme(
                        data: _theme.copyWith(
                          scrollbarTheme: _theme.scrollbarTheme.copyWith(
                            thumbVisibility: WidgetStateProperty.all(false),
                            trackVisibility: WidgetStateProperty.all(false),
                          ),
                        ),
                        child: _buildMenuList(
                          theme: _theme,
                          isScrollable: false,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: _sizeInfo.innerSpacing),

          // Select Size
          ShadowContainer(
            // headerText: 'Select Size',
            headerText: lang.selectSize,
            child: ResponsiveGridRow(
              children: [
                ...{
                  "${lang.input} SM": "SM",
                  "${lang.input} MD": "MD",
                  "${lang.input} LG": "LG",
                }.entries.map(
                  (prop) {
                    final double _xPadding = switch (prop.value) {
                      // "SM" => 16,
                      // "MD" => 16,
                      // "LG" => 16,
                      _ => 16,
                    };
                    final double _yPadding = switch (prop.value) {
                      "SM" => 4,
                      "MD" => 8,
                      "LG" => 12,
                      _ => 16,
                    };
                    return ResponsiveGridCol(
                      lg: _lg,
                      md: _md,
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(
                            _sizeInfo.innerSpacing / 2),
                        child: TextFieldLabelWrapper(
                          labelText: prop.key,
                          inputField: DropdownButtonFormField2(
                            menuItemStyleData: _dropdownStyle.menuItemStyle,
                            buttonStyleData: _dropdownStyle.buttonStyle,
                            iconStyleData: _dropdownStyle.iconStyle,
                            dropdownStyleData: _dropdownStyle.dropdownStyle,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsetsDirectional.symmetric(
                                horizontal: _xPadding,
                                vertical: _yPadding,
                              ),
                            ),
                            hint: Text(prop.key),
                            items: List.generate(
                              5,
                              (index) => DropdownMenuItem(
                                value: index + 1,
                                child: Text('${lang.status} ${index + 1}'),
                              ),
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    );
                  },
                ),

                //  Rounded Fields
                ...{
                  "${lang.rounded} SM": "SM",
                  "${lang.rounded} MD": "MD",
                  "${lang.rounded} LG": "LG",
                }.entries.map(
                  (prop) {
                    final double _xPadding = switch (prop.value) {
                      // "SM" => 16,
                      // "MD" => 16,
                      // "LG" => 16,
                      _ => 16,
                    };
                    final double _yPadding = switch (prop.value) {
                      "SM" => 4,
                      "MD" => 8,
                      "LG" => 12,
                      _ => 16,
                    };
                    return ResponsiveGridCol(
                      lg: _lg,
                      md: _md,
                      child: Padding(
                        padding: EdgeInsetsDirectional.all(
                            _sizeInfo.innerSpacing / 2),
                        child: TextFieldLabelWrapper(
                          labelText: prop.key,
                          inputField: DropdownButtonFormField2(
                            menuItemStyleData: _dropdownStyle.menuItemStyle,
                            buttonStyleData: _dropdownStyle.buttonStyle,
                            iconStyleData: _dropdownStyle.iconStyle,
                            dropdownStyleData: _dropdownStyle.dropdownStyle,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsetsDirectional.symmetric(
                                horizontal: _xPadding,
                                vertical: _yPadding,
                              ),
                              border: _inputFieldStyle.getRoundedBorder(),
                              enabledBorder: _inputFieldStyle.getRoundedBorder(
                                getRoundedBorderType:
                                    RoundedBorderType.enabledBorder,
                              ),
                              focusedBorder: _inputFieldStyle.getRoundedBorder(
                                getRoundedBorderType:
                                    RoundedBorderType.focusedBorder,
                              ),
                              errorBorder: _inputFieldStyle.getRoundedBorder(
                                getRoundedBorderType:
                                    RoundedBorderType.errorBorder,
                              ),
                              focusedErrorBorder:
                                  _inputFieldStyle.getRoundedBorder(
                                getRoundedBorderType:
                                    RoundedBorderType.focusedErrorBorder,
                              ),
                              disabledBorder: _inputFieldStyle.getRoundedBorder(
                                getRoundedBorderType:
                                    RoundedBorderType.disabledBorder,
                              ),
                            ),
                            hint: Text(prop.key),
                            items: List.generate(
                              5,
                              (index) => DropdownMenuItem(
                                value: index + 1,
                                child: Text('${lang.status} ${index + 1}'),
                              ),
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: _sizeInfo.innerSpacing),

          // Multiple select input
          ShadowContainer(
            //headerText: 'Multiple select input',
            headerText: lang.multipleSelectInput,
            child: ResponsiveGridRow(
              children: [
                // Multi Select Dropdown Widget
                ResponsiveGridCol(
                  lg: _lg + 2,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      //labelText: 'Default',
                      labelText: lang.Default,
                      inputField: AcnooMultiSelectDropdown(
                        menuItemStyleData:
                            _dropdownStyle.multiSelectMenuItemStyle,
                        buttonStyleData: _dropdownStyle.buttonStyle,
                        iconStyleData: _dropdownStyle.iconStyle,
                        dropdownStyleData: _dropdownStyle.dropdownStyle,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsetsDirectional.all(8),
                          //hintText: 'Select Items',
                          hintText: lang.selectItems,
                        ),
                        values: selectedDropdownItems,
                        items: List.generate(
                          50,
                          (index) => MultiSelectDropdownMenuItem(
                            value: index + 1,
                            labelText: '${lang.item} ${index + 1}',
                          ),
                        ),
                        onChanged: (_) => setState(
                          () => selectedDropdownItems = _ ?? [],
                        ),
                      ),
                    ),
                  ),
                ),

                // Multi Select Text Field
                ResponsiveGridCol(
                  lg: _lg + 2,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      //labelText: 'Input with Placeholder',
                      labelText: lang.inputWithPlaceholder,
                      inputField: AcnooMultiSelectTextField(
                        decoration: InputDecoration(
                          // hintText: 'Chose a city',
                          hintText: lang.choseACity,
                        ),
                      ),
                    ),
                  ),
                ),

                // Multi Select Dropdown Widget
                ResponsiveGridCol(
                  lg: _lg + 2,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      //labelText: 'Text inputs',
                      labelText: lang.textInputs,
                      inputField: AcnooMultiSelectDropdown(
                        menuItemStyleData:
                            _dropdownStyle.multiSelectMenuItemStyle,
                        buttonStyleData: _dropdownStyle.buttonStyle,
                        iconStyleData: _dropdownStyle.iconStyle.copyWith(
                          icon: const SizedBox.shrink(),
                        ),
                        dropdownStyleData: _dropdownStyle.dropdownStyle,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsetsDirectional.all(8),
                          // hintText: 'Select Items',
                          hintText: lang.selectItems,
                        ),
                        values: selectedDropdownItems,
                        items: List.generate(
                          50,
                          (index) => MultiSelectDropdownMenuItem(
                            value: index + 1,
                            labelText: '${lang.item} ${index + 1}',
                          ),
                        ),
                        onChanged: (_) => setState(
                          () => selectedDropdownItems = _ ?? [],
                        ),
                      ),
                    ),
                  ),
                ),

                // Multi Select Text Field
                ResponsiveGridCol(
                  lg: _lg + 2,
                  md: _md,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(_sizeInfo.innerSpacing / 2),
                    child: TextFieldLabelWrapper(
                      //labelText: 'Text inputs',
                      labelText: lang.textInputs,
                      inputField: AcnooMultiSelectTextField(
                        decoration: InputDecoration(
                          // hintText: 'Select you status',
                          hintText: lang.selectYouStatus,
                        ),
                        showButtonAction: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: _sizeInfo.innerSpacing),
        ],
      ),
    );
  }

  Widget _buildMenuList({
    required ThemeData theme,
    bool isScrollable = true,
    ScrollController? controller,
  }) {
    return ListView(
      padding: EdgeInsetsDirectional.only(
        start: 8,
        top: 8,
        end: isScrollable ? 24 : 0,
      ),
      shrinkWrap: true,
      addAutomaticKeepAlives: false,
      controller: controller,
      physics: isScrollable ? null : const NeverScrollableScrollPhysics(),
      children: [
        l.S.current.openThisSelectMenu,
        // "Open this select menu",
        //"One",
        l.S.current.one,
        //"Two",
        l.S.current.Two,
        //"Three",
        l.S.current.Three,
        //"eligendi dolore voluptate",
        l.S.current.eligendiDoloreVoluptate,
        //"natus quia aut",
        l.S.current.natusQuiaAut,
        //"aliquam sint libero",
        l.S.current.AliquamSintLibero,
        //"reiciendis rem voluptas",
        l.S.current.reiciendisRemVoluptas,
        //"repellendus eum eveniet",
        l.S.current.repellendusEumEveniet,
        //"doloribus et eos",
        l.S.current.doloribuseEtEos,
        //"illo excepturi cupiditate",
        l.S.current.illoExcepturiCupiditate,
        //"sit sit aut",
        l.S.current.sitSitAut,
        //"autem optio velit",
        l.S.current.autemOptioVelit,
        //"quia explicabo possimus",
        l.S.current.quiaExplicaboPossimus,
        //"ipsum aspernatur id",
        l.S.current.ipsumAspernaturId,
        //"et ea quis",
        l.S.current.etEaQuis,
        //"rerum sint aliquid",
        l.S.current.rerumSintAliquid,
        //"qui iste ratione",
        l.S.current.quiIsteRatione,
        //"debitis unde corrupti",
        l.S.current.debitisUndeCorrupti,
        //"quia eos eum",
        l.S.current.quiaEosEum,
        //"nihil porro est",
        l.S.current.nihilPorroEst,
        // "dolorem sunt corrupti",
        l.S.current.doloremSuntCorrupti,
        //"quia necessitatibus molestiae",
        l.S.current.quiaNecessitatibusMolestiae,
        //"qui molestiae quis",
        l.S.current.quiMolestiaeQuis,
      ].asMap().entries.map(
        (e) {
          final index = e.key;
          return Container(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 4,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: index != 0 ? null : theme.colorScheme.surface,
            ),
            child: Text(
              e.value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onTertiary,
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}

class _SizeInfo {
  final double? fonstSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.fonstSize,
    this.padding = const EdgeInsetsDirectional.all(24),
    this.innerSpacing = 24,
  });
}
