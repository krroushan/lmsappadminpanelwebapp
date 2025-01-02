// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/theme/theme.dart';
import '../../../../widgets/widgets.dart';

class GeneratedCodeField extends StatefulWidget {
  const GeneratedCodeField({super.key});

  @override
  State<GeneratedCodeField> createState() => _GeneratedCodeFieldState();
}

class _GeneratedCodeFieldState extends State<GeneratedCodeField> {
  late Future<HighlighterTheme> syntaxHighlightThemeFuture;

  Future<HighlighterTheme> handleSyntaxHighlighInit() async {
    await Highlighter.initialize(['dart', 'yaml', 'sql']);

    if (mounted) {
      final _theme = Theme.of(context);
      final _isDark = _theme.brightness == Brightness.dark;

      return _isDark
          ? HighlighterTheme.loadLightTheme()
          : HighlighterTheme.loadDarkTheme();
    }
    return HighlighterTheme.loadLightTheme();
  }

  @override
  void initState() {
    super.initState();
    syntaxHighlightThemeFuture = handleSyntaxHighlighInit();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _padding = responsiveValue<double>(context, xs: 16, lg: 24);
    final _headerPadding = responsiveValue<EdgeInsetsGeometry?>(
      context,
      xs: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      lg: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Document Header
        Container(
          padding: _headerPadding,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _theme.colorScheme.outline,
              ),
            ),
          ),
          child: _buildDocumentHeader(context),
        ),

        // Mock Document
        Padding(
          padding: EdgeInsets.all(_padding),
          child: FutureBuilder(
            future: syntaxHighlightThemeFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final highlighter = Highlighter(
                language: 'dart',
                theme: snapshot.data!,
              );

              var _formatedCode = highlighter.highlight(_code);

              return Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      //text: 'Sure! Here’s a basic code for an counter app using Dart\'s Flutter framework:',
                      text:
                          '${lang.sureHereABasicCodeForAnCounterAppUsingDartFlutterFramework}:',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    WidgetSpan(
                      child: _buildCodeBlock(
                        context,
                        formatedCode: _formatedCode,
                      ),
                    ),
                    TextSpan(
                      //text: '\nThis code uses the setState method to update `count` variable\'s state and update the UI.',
                      text:
                          '\n${lang.thisCodeUsesTheSetStateMethodToUpdateCountVariableStateAndUpdateTheUI}.',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                style: _theme.textTheme.bodyLarge,
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildDocumentHeader(BuildContext context) {
    final _screenSize = MediaQuery.sizeOf(context);
    final lang = l.S.of(context);
    return ResponsiveGridRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Document Name Field
        ResponsiveGridCol(
          md: _screenSize.width >= 1680 ? 10 : 9,
          child: TextFormField(
            decoration: InputDecoration(
              // hintText: 'Document Name',
              hintText: lang.documentName,
              suffixIcon: Container(
                margin: const EdgeInsets.all(5),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    visualDensity: const VisualDensity(vertical: -4),
                  ),
                  // child: const Text('Save'),
                  child: Text(lang.save),
                ),
              ),
            ),
          ),
        ),

        // Save As Buttons
        ResponsiveGridCol(
          md: _screenSize.width >= 1680 ? 2 : 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox.square(dimension: 24),
              Flexible(
                child: FileExportButton.excel(
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: FileExportButton.csv(
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: FileExportButton.print(
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: FileExportButton.pdf(
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: FileExportButton.copy(
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCodeBlock(
    BuildContext context, {
    required TextSpan formatedCode,
  }) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints.tightFor(width: double.maxFinite),
        decoration: BoxDecoration(
          color: _isDark ? AcnooAppColors.kDark3 : const Color(0xff171717),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text.rich(formatedCode),
      ),
    );
  }
}

const _code = '''
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int number = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hello World!')),
      body: Center(
        child: Text('Current number is: \$number'),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: ()=> setState(()=>number++ ),
        ),
    );
  }
}
''';
