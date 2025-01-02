// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:dropdown_button2/dropdown_button2.dart';

// 🌎 Project imports:
import 'package:acnoo_flutter_admin_panel/generated/l10n.dart' as l;
import '../../../../core/helpers/field_styles/field_styles.dart';
import '../../../../widgets/widgets.dart';

class AICodePromptForm extends StatefulWidget {
  const AICodePromptForm({
    super.key,
    this.onFormSubmit,
  });
  final void Function()? onFormSubmit;

  @override
  State<AICodePromptForm> createState() => _AICodePromptFormState();
}

class _AICodePromptFormState extends State<AICodePromptForm> {
  List<String> programmingLanguages = [
    'Dart',
    'Python',
    'Java',
    'JavaScript',
    'C++',
    'C#',
    'Ruby',
    'Swift',
    'Kotlin',
    'Go',
    'Rust',
    'PHP',
    'TypeScript',
    'R',
    'MATLAB',
    'Objective-C',
    'Scala',
    'Perl',
    'Lua',
    'Haskell',
    'Elixir',
    'Erlang',
    'Clojure',
    'F#',
    'Shell',
    'SQL',
    'HTML',
    'CSS',
    'Visual Basic',
    'Assembly',
  ];
  List<String>get codingLevels => [
    //'Beginner',
    l.S.current.beginner,
    //'Intermediate',
    l.S.current.intermediate,
    //'Advanced',
    l.S.current.advanced,
    //'Expert',
    l.S.current.expert,
    //'Novice',
    l.S.current.novice,
    //'Junior',
    l.S.current.junior,
    //'Mid-Level',
    l.S.current.midLevel,
    //'Senior',
    l.S.current.senior,
    //'Proficient',
    l.S.current.proficient,
    //'Master',
    l.S.current.master,
    //'Lead',
    l.S.current.lead,
  ];

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Field
        TextFieldLabelWrapper(
          label: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    // text: 'Title',
                    text: lang.title,
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _theme.colorScheme.errorContainer,
                        ),
                      ),
                    ],
                  ),
                  style: _theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '0/8',
                style: _theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          inputField: TextFormField(
            decoration: InputDecoration(
              // hintText: 'Enter title',
              hintText: lang.enterTitle,
            ),
          ),
        ),
        const SizedBox.square(dimension: 24),

        // Programing Language Dropdown
        TextFieldLabelWrapper(
          label: Text.rich(
            TextSpan(
              //text: 'Programing Language',
              text: lang.programingLanguage,
              children: [
                TextSpan(
                  text: '*',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _theme.colorScheme.errorContainer,
                  ),
                ),
              ],
            ),
            style: _theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
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
                items: programmingLanguages,
              );
            },
            value: programmingLanguages.firstOrNull,
            items: programmingLanguages.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (value) {},
          ),
        ),
        const SizedBox.square(dimension: 24),

        // Coding Level Dropdown
        TextFieldLabelWrapper(
          // labelText: 'Coding Level',
          labelText: lang.codingLevel,
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
                items: codingLevels,
              );
            },
            // value: codingLevels.firstOrNull,
            items: codingLevels.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (value) {},
          ),
        ),
        const SizedBox.square(dimension: 24),

        // Title Field
        TextFieldLabelWrapper(
          label: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    //text: 'Description',
                    text: lang.description,
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _theme.colorScheme.errorContainer,
                        ),
                      ),
                    ],
                  ),
                  style: _theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '0/250',
                style: _theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          inputField: TextField(
            maxLines: 3,
            decoration: InputDecoration(
              // hintText: 'Describe what kind of code you need...',
              hintText: '${lang.describeWhatKindOfCodeYouNeed}...',
            ),
          ),
        ),

        const SizedBox.square(dimension: 24),
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              textStyle:
                  _theme.elevatedButtonTheme.style?.textStyle?.resolve({}),
            ),
            // child: const Text('Apply'),
            child: Text(lang.apply),
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
