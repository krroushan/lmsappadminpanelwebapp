// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:country_flags/country_flags.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import 'package:acnoo_flutter_admin_panel/generated/l10n.dart' as l;
import '../../../../core/helpers/field_styles/field_styles.dart';
import '../../../../widgets/widgets.dart';

class AIVoicePromptForm extends StatefulWidget {
  const AIVoicePromptForm({
    super.key,
    this.onFormSubmit,
  });
  final void Function()? onFormSubmit;

  @override
  State<AIVoicePromptForm> createState() => _AIVoicePromptFormState();
}

class _AIVoicePromptFormState extends State<AIVoicePromptForm> {
  final supportedLanguages = {
    "English": "US",
    "Bangla": "BD",
  };

  final voices = {
    "US-Male": "English",
    "GB-Male": "English",
    "FR-Male": "French",
    "ES-Male": "Spanish",
    "DE-Male": "German",
    "IT-Male": "Italian",
    "JP-Male": "Japanese",
    "KR-Male": "Korean",
    "BR-Male": "Portuguese",
    "RU-Male": "Russian",
    "CN-Male": "Chinese",
  };

  List<String> get speakingStyle => [
    l.S.current.narration,
    //"Narration",
    l.S.current.conversational,
    //"Conversational",
    l.S.current.formal,
    //"Formal",
    l.S.current.casual,
    // "Casual",
    l.S.current.excited,
    //"Excited",
    l.S.current.calm,
    // "Calm",
    l.S.current.serious,
    //"Serious",
    l.S.current.friendly,
    //"Friendly",
    l.S.current.inspirational,
    //"Inspirational",
    l.S.current.persuasive,
    //"Persuasive",
    l.S.current.sad,
    //"Sad",
    l.S.current.joyful,
    //"Joyful",
    l.S.current.neutral,
    //"Neutral",
    l.S.current.authoritative,
    //"Authoritative",
    l.S.current.warm,
    //"Warm",
    l.S.current.playful,
    //"Playful",
    l.S.current.dramatic,
    //"Dramatic",
    l.S.current.clear,
    //"Clear",
    l.S.current.empathetic,
    //"Empathetic",
    l.S.current.instructional,
    // "Instructional"
  ];

  final downloadableFiles = [
    'mp3',
    'wav',
    'aac',
    'ogg',
    'flac',
    'm4a',
    'wma',
    'opus',
    'alac',
    'aiff',
  ];

  @override
  Widget build(BuildContext context) {
    final _lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);
    final _mqSize = MediaQuery.sizeOf(context);
    final _addHorizontalPadding = _mqSize.width >= 576;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Generative Form
        Form(
          child: ResponsiveGridRow(
            children: [
              // File Name
              ResponsiveGridCol(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 12),
                  child: TextFieldLabelWrapper(
                    // labelText: 'File Name',
                    labelText: _lang.fileName,
                    inputField: TextFormField(
                      decoration: InputDecoration(
                        // hintText: 'Enter File Name',
                        hintText: _lang.enterFileName,
                      ),
                    ),
                  ),
                ),
              ),

              // Language
              ResponsiveGridCol(
                md: 6,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    0,
                    12,
                    _addHorizontalPadding ? 12 : 0,
                    12,
                  ),
                  child: TextFieldLabelWrapper(
                    label: Text.rich(
                      TextSpan(
                        //text: 'Language',
                        text: _lang.language,
                        children: [
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: _theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      style: _theme.inputDecorationTheme.floatingLabelStyle,
                    ),
                    inputField: DropdownButtonFormField2(
                      style: _dropdownStyle.textStyle,
                      iconStyleData: _dropdownStyle.iconStyle,
                      buttonStyleData: _dropdownStyle.buttonStyle,
                      dropdownStyleData: _dropdownStyle.dropdownStyle,
                      menuItemStyleData: _dropdownStyle.menuItemStyle,
                      isExpanded: true,
                      value: supportedLanguages.entries.firstOrNull?.key,
                      items: supportedLanguages.entries
                          .map((item) => DropdownMenuItem(
                                value: item.key,
                                child: Row(
                                  children: [
                                    CountryFlag.fromCountryCode(
                                      item.value,
                                      height: 24,
                                      width: 30,
                                      shape: const RoundedRectangle(2),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(item.key),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ),

              // Voices
              ResponsiveGridCol(
                md: 6,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    _addHorizontalPadding ? 12 : 0,
                    12,
                    0,
                    12,
                  ),
                  child: TextFieldLabelWrapper(
                    // labelText: 'Voices',
                    labelText: _lang.voices,
                    inputField: DropdownButtonFormField2(
                      style: _dropdownStyle.textStyle,
                      iconStyleData: _dropdownStyle.iconStyle,
                      buttonStyleData: _dropdownStyle.buttonStyle,
                      dropdownStyleData: _dropdownStyle.dropdownStyle,
                      menuItemStyleData: _dropdownStyle.menuItemStyle,
                      isExpanded: true,
                      value: voices.entries.firstOrNull?.key,
                      items: voices.entries.map((item) {
                        final _flagCode = item.key.split('-').take(1).join();
                        return DropdownMenuItem(
                          value: item.key,
                          child: Row(
                            children: [
                              CountryFlag.fromCountryCode(
                                _flagCode,
                                height: 24,
                                width: 30,
                                shape: const RoundedRectangle(2),
                              ),
                              const SizedBox(width: 8),
                              Flexible(child: Text(item.value)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ),

              // Speaking Style
              ResponsiveGridCol(
                md: 6,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    0,
                    12,
                    _addHorizontalPadding ? 12 : 0,
                    12,
                  ),
                  child: TextFieldLabelWrapper(
                    //labelText: 'Speaking Style',
                    labelText: _lang.speakingStyle,
                    inputField: DropdownButtonFormField2(
                      style: _dropdownStyle.textStyle,
                      iconStyleData: _dropdownStyle.iconStyle,
                      buttonStyleData: _dropdownStyle.buttonStyle,
                      dropdownStyleData: _dropdownStyle.dropdownStyle,
                      menuItemStyleData: _dropdownStyle.menuItemStyle,
                      isExpanded: true,
                      value: speakingStyle.firstOrNull,
                      items: speakingStyle
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              ))
                          .toList(),
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ),

              // Pause
              ResponsiveGridCol(
                md: 6,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    _addHorizontalPadding ? 12 : 0,
                    12,
                    0,
                    12,
                  ),
                  child: TextFieldLabelWrapper(
                    // labelText: 'Pause',
                    labelText: _lang.pause,
                    inputField: DropdownButtonFormField2(
                      style: _dropdownStyle.textStyle,
                      iconStyleData: _dropdownStyle.iconStyle,
                      buttonStyleData: _dropdownStyle.buttonStyle,
                      dropdownStyleData: _dropdownStyle.dropdownStyle,
                      menuItemStyleData: _dropdownStyle.menuItemStyle,
                      isExpanded: true,
                      //hint:  Text('Select One'),
                      hint: Text(_lang.selectOne),
                      items: List.generate(
                        10,
                        (index) => DropdownMenuItem(
                          value: index,
                          child: Text('${index + 1} ${_lang.second}'),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ),

              // Download Fiels
              ResponsiveGridCol(
                md: 6,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    0,
                    12,
                    _addHorizontalPadding ? 12 : 0,
                    12,
                  ),
                  child: TextFieldLabelWrapper(
                    //labelText: 'Download Fiels',
                    labelText: _lang.downloadFiels,
                    inputField: DropdownButtonFormField2(
                      style: _dropdownStyle.textStyle,
                      iconStyleData: _dropdownStyle.iconStyle,
                      buttonStyleData: _dropdownStyle.buttonStyle,
                      dropdownStyleData: _dropdownStyle.dropdownStyle,
                      menuItemStyleData: _dropdownStyle.menuItemStyle,
                      isExpanded: true,
                      selectedItemBuilder: (ctx) {
                        return _buildDropdownSelectedItem(
                          ctx,
                          items: downloadableFiles,
                        );
                      },
                      value: downloadableFiles.first,
                      items: downloadableFiles.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ),

              // Speed
              ResponsiveGridCol(
                md: 6,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    _addHorizontalPadding ? 12 : 0,
                    12,
                    0,
                    12,
                  ),
                  child: TextFieldLabelWrapper(
                    //labelText: 'Speed',
                    labelText: _lang.speed,
                    inputField: DropdownButtonFormField2(
                      style: _dropdownStyle.textStyle,
                      iconStyleData: _dropdownStyle.iconStyle,
                      buttonStyleData: _dropdownStyle.buttonStyle,
                      dropdownStyleData: _dropdownStyle.dropdownStyle,
                      menuItemStyleData: _dropdownStyle.menuItemStyle,
                      isExpanded: true,
                      //hint: const Text('Select One'),
                      hint: Text(_lang.selectOne),
                      items: List.generate(
                        10,
                        (index) => DropdownMenuItem(
                          value: index,
                          child: Text('${index + 1} ${_lang.second}'),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ),

              // Submit Button
              ResponsiveGridCol(
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.only(top: 16, bottom: 12),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      textStyle: _theme.elevatedButtonTheme.style?.textStyle
                          ?.resolve({})?.copyWith(),
                    ),
                    //child: const Text('Generate'),
                    child: Text(_lang.generate),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDropdownSelectedItem(
    BuildContext context, {
    List<String> items = const [],
    TextStyle? style,
  }) {
    final ThemeData(:textTheme) = Theme.of(context);

    return items.map((item) {
      return Text(
        item,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style ?? textTheme.bodyLarge,
      );
    }).toList();
  }
}
