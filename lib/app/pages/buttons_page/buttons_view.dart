// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/helpers/field_styles/field_styles.dart';
import '../../core/theme/theme.dart';
import '../../widgets/widgets.dart';

class ButtonsView extends StatefulWidget {
  const ButtonsView({super.key});

  @override
  State<ButtonsView> createState() => _ButtonsViewState();
}

class _ButtonsViewState extends State<ButtonsView> {
  int _groupButtonCount = 3;
  List<GroupButtonItem> groupButtons = [];

  void _updateGroupButtonCount() {
    if (!mounted) return;

    final _screenWidth = MediaQuery.of(context).size.width;

    int newGroupButtonCount = _screenWidth <= 520
        ? _groupButtonCount
        : _screenWidth >= 521 && _screenWidth <= 991
            ? (_screenWidth / 130).toInt()
            : (_screenWidth / 2.5 / 120).toInt();

    setState(() {
      _groupButtonCount = newGroupButtonCount;
      groupButtons = List<GroupButtonItem>.generate(
        _groupButtonCount,
        (i) => GroupButtonItem(
          child: Text('${l.S.of(context).group} ${i + 1}'),
          isSelected: i == 0,
        ),
      );
    });
  }

  List<bool> verticalVariatonSelected = List.generate(3, (i) => i == 0);

  int? selectedDropdownValue;

  @override
  void initState() {
    super.initState();
    groupButtons = List<GroupButtonItem>.generate(
      _groupButtonCount,
      (i) => GroupButtonItem(
        child: Text('${l.S.current.group} ${i + 1}'),
        isSelected: i == 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _updateGroupButtonCount();
    final _theme = Theme.of(context);
    final _toggleButtonStyles = AcnooToggleButtonStyles(context);
    final _dropdownStyles = AcnooDropdownStyle(context);
    final lang = l.S.of(context);
    const _buttonPadding = EdgeInsetsDirectional.symmetric(
      horizontal: 24,
      vertical: 12,
    );
    final _buttonTextStyle = _theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(8),
        child: ResponsiveGridRow(
          children: [
            // Default Button
            ResponsiveGridCol(
              lg: 6,
              child: Padding(
                padding: const EdgeInsetsDirectional.all(8),
                child: ShadowContainer(
                  // headerText: 'Default Buttons',
                  headerText: lang.defaultButtons,
                  child: Wrap(
                    children: {
                      lang.primary: {
                        // 'background': AcnooAppColors.kPrimary600,
                        // 'foreground': Colors.white,
                        'background': AcnooAppColors.kPrimary600,
                        'foreground': Colors.white,
                      },
                      lang.secondary: {
                        'background': AcnooAppColors.kSecondaryBtnColor,
                        'foreground': Colors.white,
                      },
                      lang.success: {
                        'background': AcnooAppColors.kSuccess,
                        'foreground': Colors.white,
                      },
                      lang.info: {
                        'background': AcnooAppColors.kInfo,
                        'foreground': Colors.white,
                      },
                      lang.warning: {
                        'background': AcnooAppColors.kWarning,
                        'foreground': Colors.white,
                      },
                      lang.danger: {
                        'background': AcnooAppColors.kError,
                        'foreground': Colors.white,
                      },
                      lang.dark: {
                        'background': AcnooAppColors.kNeutral900,
                        'foreground': Colors.white,
                      },
                      lang.dark: {
                        'background': Colors.transparent,
                        'foreground': _theme.colorScheme.onTertiary,
                      },
                      lang.light: {
                        'background': AcnooAppColors.kNeutral50,
                        'foreground': AcnooAppColors.kNeutral900,
                      },
                    }
                        .entries
                        .map(
                          (button) => Padding(
                            padding: const EdgeInsetsDirectional.all(4),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: button.value['background'],
                                foregroundColor: button.value['foreground'],
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                textStyle: _buttonTextStyle,
                              ),
                              child: Text(button.key),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),

            // Outline Button
            ResponsiveGridCol(
              lg: 6,
              child: ShadowContainer(
                margin: const EdgeInsetsDirectional.all(8),
                // headerText: 'Outline Buttons',
                headerText: lang.outlineButtons,
                child: Wrap(
                  children: {
                    lang.primary: {
                      'sideColor': AcnooAppColors.kPrimary600,
                      'foreground': AcnooAppColors.kPrimary600,
                    },
                    lang.secondary: {
                      'sideColor': AcnooAppColors.kSecondaryBtnColor,
                      'foreground': AcnooAppColors.kSecondaryBtnColor,
                    },
                    lang.success: {
                      'sideColor': AcnooAppColors.kSuccess,
                      'foreground': AcnooAppColors.kSuccess,
                    },
                    lang.info: {
                      'sideColor': AcnooAppColors.kInfo,
                      'foreground': AcnooAppColors.kInfo,
                    },
                    lang.warning: {
                      'sideColor': AcnooAppColors.kWarning,
                      'foreground': AcnooAppColors.kWarning,
                    },
                    lang.danger: {
                      'sideColor': AcnooAppColors.kError,
                      'foreground': AcnooAppColors.kError,
                    },
                    lang.dark: {
                      'sideColor': _theme.colorScheme.onTertiaryContainer,
                      'foreground': _theme.colorScheme.onTertiaryContainer,
                    },
                    lang.link: {
                      'sideColor': Colors.transparent,
                      'foreground': _theme.colorScheme.onTertiary,
                    },
                    lang.light: {
                      'sideColor': _theme.colorScheme.outline,
                      'foreground': _theme.colorScheme.onTertiaryContainer,
                    },
                  }
                      .entries
                      .map(
                        (button) => Padding(
                          padding: const EdgeInsetsDirectional.all(4),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: button.value['foreground'],
                              side: BorderSide(
                                color: button.value['sideColor'] ??
                                    Colors.transparent,
                              ),
                              shadowColor: Colors.transparent,
                              padding: _buttonPadding,
                              textStyle: _buttonTextStyle,
                              elevation: 0,
                            ),
                            child: Text(button.key),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            // Soft Button
            ResponsiveGridCol(
              lg: 6,
              child: ShadowContainer(
                margin: const EdgeInsetsDirectional.all(8),
                //headerText: 'Soft Buttons',
                headerText: lang.softButtons,
                child: Wrap(
                  children: {
                    lang.primary: {
                      'background': AcnooAppColors.kPrimary600,
                      'foreground': AcnooAppColors.kPrimary600,
                    },
                    lang.secondary: {
                      'background': AcnooAppColors.kSecondaryBtnColor,
                      'foreground': AcnooAppColors.kSecondaryBtnColor,
                    },
                    lang.success: {
                      'background': AcnooAppColors.kSuccess,
                      'foreground': AcnooAppColors.kSuccess,
                    },
                    lang.info: {
                      'background': AcnooAppColors.kInfo,
                      'foreground': AcnooAppColors.kInfo,
                    },
                    lang.warning: {
                      'background': AcnooAppColors.kWarning,
                      'foreground': AcnooAppColors.kWarning,
                    },
                    lang.danger: {
                      'background': AcnooAppColors.kError,
                      'foreground': AcnooAppColors.kError,
                    },
                    lang.dark: {
                      'background': _theme.brightness == Brightness.dark
                          ? const Color(0xff0F172A)
                          : const Color(0xff171717).withOpacity(0.15),
                      'foreground': _theme.colorScheme.onTertiary,
                    },
                  }
                      .entries
                      .map(
                        (button) => Padding(
                          padding: const EdgeInsetsDirectional.all(4),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: button.key == 'Dark'
                                  ? button.value['background']
                                  : button.value['background']
                                      ?.withOpacity(0.15),
                              foregroundColor: button.value['foreground'],
                              shadowColor: Colors.transparent,
                              padding: _buttonPadding,
                              textStyle: _buttonTextStyle,
                              elevation: 0,
                            ),
                            child: Text(button.key),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            // Ghost Button
            ResponsiveGridCol(
              lg: 6,
              child: ShadowContainer(
                margin: const EdgeInsetsDirectional.all(8),
                // headerText: 'Ghost Buttons',
                headerText: lang.ghostButtons,
                child: Wrap(
                  children: {
                    lang.primary: {
                      'sideColor': AcnooAppColors.kPrimary600,
                      'foreground': AcnooAppColors.kPrimary600,
                    },
                    lang.secondary: {
                      'sideColor': AcnooAppColors.kSecondaryBtnColor,
                      'foreground': AcnooAppColors.kSecondaryBtnColor,
                    },
                    lang.success: {
                      'sideColor': AcnooAppColors.kSuccess,
                      'foreground': AcnooAppColors.kSuccess,
                    },
                    lang.info: {
                      'sideColor': AcnooAppColors.kInfo,
                      'foreground': AcnooAppColors.kInfo,
                    },
                    lang.warning: {
                      'sideColor': AcnooAppColors.kWarning,
                      'foreground': AcnooAppColors.kWarning,
                    },
                    lang.danger: {
                      'sideColor': AcnooAppColors.kError,
                      'foreground': AcnooAppColors.kError,
                    },
                    lang.dark: {
                      'sideColor': _theme.colorScheme.onTertiaryContainer,
                      'foreground': _theme.colorScheme.onTertiaryContainer,
                    },
                  }
                      .entries
                      .map(
                        (button) => Padding(
                          padding: const EdgeInsetsDirectional.all(4),
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: button.value['foreground'],
                              shadowColor: Colors.transparent,
                              padding: _buttonPadding,
                              textStyle: _buttonTextStyle,
                              elevation: 0,
                            ),
                            child: Text(button.key),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            // Buttons with Label
            ResponsiveGridCol(
              lg: 6,
              child: ShadowContainer(
                margin: const EdgeInsetsDirectional.all(8),
                //headerText: 'Buttons with Label',
                headerText: lang.buttonsWithLabel,
                child: Wrap(
                  children: {
                    lang.primary: {
                      'background': AcnooAppColors.kPrimary600,
                      'foreground': Colors.white,
                    },
                    lang.secondary: {
                      'background': AcnooAppColors.kSecondaryBtnColor,
                      'foreground': Colors.white,
                    },
                    lang.success: {
                      'background': AcnooAppColors.kSuccess,
                      'foreground': Colors.white,
                    },
                    lang.info: {
                      'background': AcnooAppColors.kInfo,
                      'foreground': Colors.white,
                    },
                    lang.warning: {
                      'background': AcnooAppColors.kWarning,
                      'foreground': Colors.white,
                    },
                    lang.danger: {
                      'background': AcnooAppColors.kError,
                      'foreground': Colors.white,
                    },
                    lang.dark: {
                      'background': AcnooAppColors.kNeutral900,
                      'foreground': Colors.white,
                    },
                  }
                      .entries
                      .map(
                        (button) => Padding(
                          padding: const EdgeInsetsDirectional.all(4),
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: button.value['background'],
                              foregroundColor: button.value['foreground'],
                              shadowColor: Colors.transparent,
                              padding: _buttonPadding,
                              elevation: 0,
                              textStyle: _buttonTextStyle,
                            ),
                            icon: Icon(MdiIcons.chevronLeftCircleOutline),
                            label: Text(button.key),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            // Load More Buttons
            ResponsiveGridCol(
              lg: 6,
              child: ShadowContainer(
                margin: const EdgeInsetsDirectional.all(8),
                //headerText: 'Load More Buttons',
                headerText: lang.loadMoreButtons,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.all(4),
                      child: OutlinedButton.icon(
                        onPressed: null,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AcnooAppColors.kPrimary600,
                          disabledForegroundColor: AcnooAppColors.kPrimary600,
                          side: const BorderSide(
                            color: AcnooAppColors.kPrimary600,
                          ),
                          shadowColor: Colors.transparent,
                          padding: _buttonPadding,
                          textStyle: _buttonTextStyle,
                          elevation: 0,
                        ),
                        icon: const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            color: AcnooAppColors.kPrimary600,
                            strokeWidth: 2,
                          ),
                        ),
                        // label: const Text('Loading...'),
                        label: Text('${lang.loading}...'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.all(4),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AcnooAppColors.kSecondaryBtnColor,
                          // foregroundColor: AcnooAppColors.kBlackColor,
                          shadowColor: Colors.transparent,
                          padding: _buttonPadding,
                          elevation: 0,
                          textStyle: _buttonTextStyle,
                        ),
                        icon: const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            color: AcnooAppColors.kWhiteColor,
                            strokeWidth: 2,
                          ),
                        ),
                        // label: const Text('Loading...'),
                        label: Text('${lang.loading}...'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.all(4),
                      child: OutlinedButton(
                        onPressed: null,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AcnooAppColors.kSuccess,
                          disabledForegroundColor: AcnooAppColors.kSuccess,
                          side: const BorderSide(
                            color: AcnooAppColors.kSuccess,
                          ),
                          shadowColor: Colors.transparent,
                          padding: _buttonPadding,
                          textStyle: _buttonTextStyle,
                          elevation: 0,
                        ),
                        // child: const Text('Loading...'),
                        child: Text('${lang.loading}...'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.all(4),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AcnooAppColors.kInfo,
                          // foregroundColor: AcnooAppColors.kBlackColor,
                          shadowColor: Colors.transparent,
                          padding: _buttonPadding,
                          elevation: 0,
                          textStyle: _buttonTextStyle,
                        ),
                        iconAlignment: IconAlignment.end,
                        icon: const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            color: AcnooAppColors.kWhiteColor,
                            strokeWidth: 2,
                          ),
                        ),
                        //label: const Text('Info'),
                        label: Text(lang.info),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.all(4),
                      child: OutlinedButton.icon(
                        onPressed: null,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AcnooAppColors.kWarning,
                          disabledForegroundColor: AcnooAppColors.kWarning,
                          side: const BorderSide(
                            color: AcnooAppColors.kWarning,
                          ),
                          shadowColor: Colors.transparent,
                          padding: _buttonPadding,
                          textStyle: _buttonTextStyle,
                          elevation: 0,
                        ),
                        icon: const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            color: AcnooAppColors.kWarning,
                            strokeWidth: 2,
                          ),
                        ),
                        iconAlignment: IconAlignment.end,
                        //label: const Text('Warning'),
                        label: Text(lang.warning),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Buttons Sizes
            ResponsiveGridCol(
              lg: 6,
              child: ShadowContainer(
                margin: const EdgeInsetsDirectional.all(8),
                //headerText: 'Buttons Sizes',
                headerText: lang.buttonsSizes,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: {
                    lang.button2Xl: {
                      'background': AcnooAppColors.kPrimary600,
                      'foreground': Colors.white,
                      'padding': const EdgeInsetsDirectional.symmetric(
                        horizontal: 28,
                        vertical: 16,
                      ),
                    },
                    lang.buttonXl: {
                      'background': AcnooAppColors.kSecondaryBtnColor,
                      'foreground': Colors.white,
                      'padding': const EdgeInsetsDirectional.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    },
                    lang.buttonLg: {
                      'background': AcnooAppColors.kSuccess,
                      'foreground': Colors.white,
                      'padding': const EdgeInsetsDirectional.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                    },
                    lang.buttonMd: {
                      'background': AcnooAppColors.kInfo,
                      'foreground': Colors.white,
                      'padding': const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    },
                    lang.buttonSm: {
                      'background': AcnooAppColors.kWarning,
                      'foreground': Colors.white,
                      'padding': const EdgeInsetsDirectional.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    },
                  }
                      .entries
                      .map(
                        (button) => Padding(
                          padding: const EdgeInsetsDirectional.all(4),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  button.value['background'] as Color?,
                              foregroundColor:
                                  button.value['foreground'] as Color?,
                              shadowColor: Colors.transparent,
                              padding: button.value['padding']
                                  as EdgeInsetsDirectional?,
                              elevation: 0,
                              textStyle: _buttonTextStyle,
                            ),
                            child: Text(button.key),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            // Group Buttons
            ResponsiveGridCol(
              lg: 6,
              child: ShadowContainer(
                margin: const EdgeInsetsDirectional.all(8),
                // headerText: 'Group Buttons',
                headerText: lang.groupButtons,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(8),
                      fillColor: _toggleButtonStyles.fillColor,
                      selectedBorderColor: _toggleButtonStyles.fillColor,
                      selectedColor: _toggleButtonStyles.selectedColor,
                      color: _toggleButtonStyles.unselectedColor,
                      borderColor: _toggleButtonStyles.fillColor,
                      textStyle: _toggleButtonStyles.sizeInfo.textStyle,
                      isSelected:
                          groupButtons.map((e) => e.isSelected).toList(),
                      children: groupButtons
                          .map((e) => Padding(
                                padding: _toggleButtonStyles.sizeInfo.padding,
                                child: e.child,
                              ))
                          .toList(),
                      onPressed: (index) {
                        setState(
                          () {
                            for (var i = 0; i < groupButtons.length; i++) {
                              groupButtons[i].isSelected = i == index;
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Buttons Toolbar
            ResponsiveGridCol(
              lg: 6,
              child: ShadowContainer(
                margin: const EdgeInsetsDirectional.all(8),
                // headerText: 'Buttons Toolbar',
                headerText: lang.buttonsToolbar,
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        6,
                        (i) => Flexible(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.center,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusDirectional.horizontal(
                                  start: i != 0
                                      ? Radius.zero
                                      : const Radius.circular(8),
                                  end: i + 1 != 6
                                      ? Radius.zero
                                      : const Radius.circular(8),
                                ),
                              ),
                              backgroundColor:
                                  _theme.colorScheme.tertiaryContainer,
                              foregroundColor:
                                  _theme.colorScheme.onTertiaryContainer,
                              elevation: 0,
                            ),
                            child: Text('${i + 1}'),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        3,
                        (i) => Flexible(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusDirectional.horizontal(
                                  start: i != 0
                                      ? Radius.zero
                                      : const Radius.circular(8),
                                  end: i + 1 != 3
                                      ? Radius.zero
                                      : const Radius.circular(8),
                                ),
                              ),
                              backgroundColor:
                                  _theme.colorScheme.tertiaryContainer,
                              foregroundColor:
                                  _theme.colorScheme.onTertiaryContainer,
                              elevation: 0,
                            ),
                            child: Text('${i + 1}'),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        alignment: Alignment.center,
                        backgroundColor: _theme.colorScheme.tertiaryContainer,
                        foregroundColor: _theme.colorScheme.onTertiaryContainer,
                        elevation: 0,
                      ),
                      child: const Text('1'),
                    ),
                  ],
                ),
              ),
            ),

            // Vertical Variation
            ResponsiveGridCol(
              lg: 6,
              child: ShadowContainer(
                margin: const EdgeInsetsDirectional.all(8),
                contentPadding: const EdgeInsetsDirectional.all(18),
                //headerText: 'Vertical Variation',
                headerText: lang.verticalVariation,
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(8),
                      fillColor: _toggleButtonStyles.fillColor,
                      selectedBorderColor: _toggleButtonStyles.fillColor,
                      selectedColor: _toggleButtonStyles.selectedColor,
                      color: _toggleButtonStyles.unselectedColor,
                      borderColor: _toggleButtonStyles.fillColor,
                      textStyle: _toggleButtonStyles.sizeInfo.textStyle,
                      direction: Axis.vertical,
                      isSelected: verticalVariatonSelected,
                      children: List.generate(
                        3,
                        (i) => Padding(
                          padding: _toggleButtonStyles.sizeInfo.padding,
                          child: Text('${lang.button} ${i + 1}'),
                        ),
                      ),
                      onPressed: (index) {
                        setState(() {
                          for (var i = 0;
                              i < verticalVariatonSelected.length;
                              i++) {
                            verticalVariatonSelected[i] = i == index;
                          }
                        });
                      },
                    ),
                    Column(
                      children: List.generate(
                        3,
                        (i) => ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusDirectional.vertical(
                                top: i != 0
                                    ? Radius.zero
                                    : const Radius.circular(8),
                                bottom: i + 1 != 3
                                    ? Radius.zero
                                    : const Radius.circular(8),
                              ),
                            ),
                            minimumSize: const Size(106, 48),
                            backgroundColor:
                                _theme.colorScheme.tertiaryContainer,
                            foregroundColor:
                                _theme.colorScheme.onTertiaryContainer,
                            elevation: 0,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text('${lang.button} ${i + 1}'),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: _theme.colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _theme.colorScheme.outline,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...List.generate(
                            2,
                            (i) => Container(
                              constraints: BoxConstraints.tight(
                                const Size.square(48),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${i + 1}',
                                style: _theme.textTheme.bodyLarge?.copyWith(),
                              ),
                            ),
                          ),
                          Flexible(
                            child: DropdownButton2(
                              underline: const SizedBox.shrink(),
                              // hint: const Text('Dropdown'),
                              hint: Text(lang.dropdown),
                              style: _dropdownStyles.textStyle,
                              iconStyleData: _dropdownStyles.iconStyle,
                              dropdownStyleData: _dropdownStyles.dropdownStyle,
                              menuItemStyleData: _dropdownStyles.menuItemStyle,
                              value: selectedDropdownValue,
                              items: List.generate(
                                3,
                                (i) => DropdownMenuItem(
                                  value: i,
                                  child: Text(
                                    '${lang.item} ${i + 1}',
                                  ),
                                ),
                              ),
                              onChanged: (value) => setState(
                                () => selectedDropdownValue = value,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupButtonItem {
  final Widget child;
  bool isSelected;
  GroupButtonItem({
    required this.child,
    required this.isSelected,
  });
}
