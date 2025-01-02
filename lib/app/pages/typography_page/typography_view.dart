// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/theme/theme.dart';
import '../../widgets/widgets.dart';

class TypographyView extends StatelessWidget {
  const TypographyView({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    // Define common heading styles
    const commonHeadings = {
      "Heading 1": TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      "Heading 2": TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      "Heading 3": TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        height: 1.22,
      ),
      "Heading 4": TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 1.26,
      ),
      "Heading 5": TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.33,
      ),
      "Heading 6": TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
      ),
    };
    const headingColors = {
      "Heading 1": Color(0xff7500FD),
      "Heading 2": Color(0xff00B243),
      "Heading 3": Color(0xff1D4ED8),
      "Heading 4": Color(0xffFF487E),
      "Heading 5": Color(0xffFD00E4),
      "Heading 6": Color(0xffFD7F0B),
    };

    // Data for table rows
    final List<Map<String, dynamic>> textData = [
      {
        "type": l.S.current.title,
        "text":l.S.current.thisIsTitleLoremIpsumIsSimplyDummy,
           // "This is title Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry.",
        "fontSize": responsiveValue<double>(context, xs: 18, md: 20),
      },
      {
        "type": l.S.current.subTitle,
        "text":l.S.current.thisIsTitleLoremIpsumIsSimplyDummy,
           // "This is sub title Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry.",
        "fontSize": responsiveValue<double>(context, xs: 16, md: 18),
      },
      {
        "type": l.S.current.bodyText,
        "text":l.S.current.thisIsTitleLoremIpsumIsSimplyDummy,
            //"This is body text Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry.",
        "fontSize": responsiveValue<double>(context, xs: 14, md: 16),
      },
      {
        "type": l.S.current.smallText,
        "text":l.S.current.thisIsTitleLoremIpsumIsSimplyDummy,
            //"This is small text Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry.",
        "fontSize": responsiveValue<double>(context, xs: 12, md: 14),
      },
    ];

    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 576,
          value: _SizeInfo(
            groupNameFontSize: 16,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
            headingWidgets: commonHeadings,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            groupNameFontSize: 24,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
            headingWidgets: commonHeadings,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(
        groupNameFontSize: 26,
        padding: EdgeInsets.all(24),
        innerSpacing: 24,
        headingWidgets: {
          "Heading 1": TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
          "Heading 2": TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
          "Heading 3": TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            height: 1.22,
          ),
          "Heading 4": TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            height: 1.26,
          ),
          "Heading 5": TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            height: 1.33,
          ),
          "Heading 6": TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        },
      ),
    ).value;

    final _inlineTextStyle = _theme.textTheme.bodyLarge?.copyWith(
      color: _theme.colorScheme.onTertiary,
      fontSize: responsiveValue<double?>(
        context,
        lg: 16,
        md: 14,
        sm: 14,
        xl: 14,
        xs: 12,
      ),
    );

    final _textsSectionStyle = _theme.textTheme.bodyLarge;
    //final lang = l.S.of(context);
    return SingleChildScrollView(
      padding: _sizeInfo.padding / 2.5,
      child: ResponsiveGridRow(
        children: [
          // Heading
          ResponsiveGridCol(
            lg: 6,
            md: 6,
            child: Padding(
              padding: _sizeInfo.padding / 2.5,
              child: ShadowContainer(
                //headerText: 'Heading',
                headerText: lang.heading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _sizeInfo.headingWidgets.entries
                      .map(
                        (item) => Text(
                          item.key,
                          style: _theme.textTheme.headlineLarge?.merge(
                            item.value,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),

          // Heading Colors
          ResponsiveGridCol(
            lg: 6,
            md: 6,
            child: Padding(
              padding: _sizeInfo.padding / 2.5,
              child: ShadowContainer(
                //headerText: 'Heading Colors',
                headerText: lang.headingColors,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _sizeInfo.headingWidgets.entries
                      .map(
                        (item) => Text(
                          item.key,
                          style: _theme.textTheme.headlineLarge
                              ?.merge(item.value)
                              .copyWith(color: headingColors[item.key]),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),

          // Texts
          ResponsiveGridCol(
            child: Padding(
              padding: _sizeInfo.padding / 2.5,
              child: ShadowContainer(
                contentPadding: EdgeInsets.zero,
                //headerText: 'Texts',
                headerText: lang.texts,
                child: Column(
                  children: [
                    _buildTextRow(
                      context,
                     // key: 'Type',
                      key: lang.type,
                     // value: 'Text',
                      value: lang.text,
                      isHeaderRow: true,
                      keyStyle: _textsSectionStyle?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: responsiveValue<double>(
                          context,
                          xs: 14,
                          md: 16,
                        ),
                      ),
                      valueStyle: _textsSectionStyle?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: responsiveValue<double>(
                          context,
                          xs: 14,
                          md: 16,
                        ),
                      ),
                    ),
                    ...List.generate(textData.length, (index) {
                      final _item = textData[index];

                      return _buildTextRow(
                        context,
                        key: _item['type'] ?? '',
                        value: _item['text'] ?? '',
                        isLastRow: index + 1 == textData.length,
                        keyStyle: _textsSectionStyle?.copyWith(
                          fontSize: _item['fontSize'] as double?,
                        ),
                        valueStyle: _textsSectionStyle?.copyWith(
                          fontSize: _item['fontSize'] as double?,
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
          ),

          // Inine Text Elements
          ResponsiveGridCol(
            child: Padding(
              padding: _sizeInfo.padding / 2.5,
              child: ShadowContainer(
                // headerText: 'Inine Text Elements',
                headerText: lang.inineTextElements,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Inline Highlight text
                    Text.rich(
                      TextSpan(
                        //text: 'You can use the mark tag to',
                        text: lang.youCanUseTheMarkTagTo,
                        children: [
                          TextSpan(
                            //text: ' highlight ',
                            text: lang.highlight,
                            style: _inlineTextStyle?.copyWith(
                              color: AcnooAppColors.kWarning,
                              backgroundColor: AcnooAppColors.kWarning20Op,
                            ),
                          ),
                          // const TextSpan(text: 'text'),
                          TextSpan(text: lang.text),
                        ],
                      ),
                      style: _inlineTextStyle,
                    ),
                    SizedBox(height: _sizeInfo.innerSpacing / 2),

                    // Line-through text
                    Text(
                      lang.thisIsAParagraphItStandsOutFromRegularDeleteText,
                      //'This is a paragraph. it stands out from regular Delete text',
                      style: _inlineTextStyle?.copyWith(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(height: _sizeInfo.innerSpacing / 2),

                    // Line-through long
                    Text(
                      //'This line of text is meant to be treated as no longer accurate.',
                      lang.thisLineOfTextIsMeantToBeTreatedAsNoLongerAccurate,
                      style: _inlineTextStyle?.copyWith(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(height: _sizeInfo.innerSpacing / 2),

                    // Underline
                    Text(
                      lang.thisLineOfTextWillRenderAsUnderlined,
                      //'This line of text will render as underlined',
                      style: _inlineTextStyle?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(height: _sizeInfo.innerSpacing / 2),

                    // Underline long
                    Text(
                      // 'This line of text is meant to be treated as an addition to the document.',
                      lang.thisLineOfTextIsMeantToBeTreatedAsAnAdditionToTheDocument,

                      style: _inlineTextStyle?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SizedBox(height: _sizeInfo.innerSpacing / 2),

                    // Regular Text
                    Text(
                      //'This is a paragraph. it stands out from regular text.',
                      lang.thisIsAParagraphItStandsOutFromRegularText,
                      style: _inlineTextStyle,
                    ),
                    SizedBox(height: _sizeInfo.innerSpacing / 2),

                    // Bold Text
                    Text(
                      lang.thisLineRenderedAsBoldText,
                      //'This line rendered as bold text.',
                      style: _inlineTextStyle?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: _sizeInfo.innerSpacing / 2),

                    // italic Text
                    Text(
                      lang.thisLineRenderedAsItalicizedText,
                      //'This line rendered as italicized text.',
                      style: _inlineTextStyle?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: _sizeInfo.innerSpacing / 2),

                    // italic Text
                    Text(
                      lang.thisLineRenderedAsItalicizedText,
                      //'This line rendered as italicized text.',
                      style: _inlineTextStyle?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextRow(
    BuildContext context, {
    required String key,
    required String value,
    TextStyle? keyStyle,
    TextStyle? valueStyle,
    bool isHeaderRow = false,
    bool isLastRow = false,
  }) {
    final _theme = Theme.of(context);
    final _itemPadding = responsiveValue<EdgeInsetsGeometry>(
      context,
      xs: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 16,
      ),
      md: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: isHeaderRow ? _theme.colorScheme.tertiaryContainer : null,
        border: Border(
          top: isHeaderRow
              ? BorderSide(
                  color: _theme.colorScheme.outline,
                )
              : BorderSide.none,
          bottom: isHeaderRow || !isLastRow
              ? BorderSide(
                  color: _theme.colorScheme.outline,
                )
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: _itemPadding,
            constraints: BoxConstraints(
              minWidth: responsiveValue<double>(
                context,
                xs: 90,
                sm: 100,
                md: 120,
                lg: 250,
              ),
            ),
            child: Text(key, style: keyStyle),
          ),
          Expanded(
            child: Padding(
              padding: _itemPadding,
              child: Text(value, style: valueStyle),
            ),
          ),
        ],
      ),
    );
  }
}

class _SizeInfo {
  final double groupNameFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  final Map<String, TextStyle> headingWidgets;

  const _SizeInfo({
    required this.groupNameFontSize,
    required this.padding,
    required this.innerSpacing,
    required this.headingWidgets,
  });
}
