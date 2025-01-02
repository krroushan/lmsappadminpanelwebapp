// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:country_flags/country_flags.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/helpers/field_styles/field_styles.dart';
import '../../../../core/theme/theme.dart';
import '../../../../widgets/widgets.dart';

class AIWriterPromptForm extends StatefulWidget {
  const AIWriterPromptForm({
    super.key,
    this.onFormSubmit,
  });
  final void Function()? onFormSubmit;

  @override
  State<AIWriterPromptForm> createState() => _AIWriterPromptFormState();
}

class _AIWriterPromptFormState extends State<AIWriterPromptForm> {
  List<String> get _templates => [
    // "Blog Post Writing",
    // "Product Descriptions",
    // "Social Media Captions",
    // "Email Newsletters",
    // "SEO Meta Descriptions",
    // "Ad Copy",
    // "Landing Page Copy",
    // "Press Releases",
    // "Whitepapers",
    // "Case Studies",
    // "Video Scripts",
    // "E-commerce Product Listings",
    // "Website Content",
    // "Technical Documentation",
    // "Creative Writing (e.g., Short Stories)",
    // "Brand Storytelling",
    // "Resume and Cover Letters",
    // "App Store Descriptions",
    // "E-book Writing",
    // "Customer Testimonials",
    // "Sales Copy",
    // "How-to Guides",
    // "FAQs Writing",
    // "Job Descriptions",
    // "Business Proposals",
    // "Cold Email Outreach",
    // "Speech Writing",
    // "Interview Question Writing",
    // "Review Responses",
    // "Event Invitations"
    l.S.current.BlogPostWriting,
    l.S.current.ProductDescriptions,
    l.S.current.SocialMediaCaptions,
    l.S.current.EmailNewsletters,
    l.S.current.SEOMetaDescriptions,
    l.S.current.AdCopy,
    l.S.current.LandingPageCopy,
    l.S.current.PressReleases,
    l.S.current.Whitepapers,
    l.S.current.CaseStudies,
    l.S.current.VideoScripts,
    l.S.current.EcommerceProductListings,
    l.S.current.WebsiteContent,
    l.S.current.TechnicalDocumentation,
    l.S.current.CreativeWritingShortStories,
    l.S.current.BrandStorytelling,
    l.S.current.ResumeandCoverLetters,
    l.S.current.AppStoreDescriptions,
    l.S.current.EbookWriting,
    l.S.current.CustomerTestimonials,
    l.S.current.SalesCopy,
    l.S.current.HowtoGuides,
    l.S.current.FAQsWriting,
    l.S.current.JobDescriptions,
    l.S.current.BusinessProposals,
    l.S.current.ColdEmailOutreach,
    l.S.current.SpeechWriting,
    l.S.current.InterviewQuestionWriting,
    l.S.current.ReviewResponses,
    l.S.current.EventInvitations
  ];
  final supportedLanguages = {
    "English": "US",
    "Bangla": "BD",
  };

  List<String> get _creativityLevels => [
    //"Casual",
    l.S.current.Casual,
    //"Professional",
    l.S.current.Professional,
    //"Witty",
    l.S.current.Witty,
    //"Friendly",
    l.S.current.friendly,
    //"Conversational",
    l.S.current.Conversational,
    //"Inspirational",
    l.S.current.Inspirational,
    // "Formal",
    l.S.current.formal,
    //"Persuasive",
    l.S.current.Persuasive,
    //"Humorous",
    l.S.current.Humorous,
    // "Empathetic",
    l.S.current.Empathetic,
    //"Imaginative",
    l.S.current.Imaginative,
    //"Sophisticated",
    l.S.current.Sophisticated,
    //"Direct",
    l.S.current.Direct,
    //"Playful",
    l.S.current.Playful,
    // "Energetic",
    l.S.current.Energetic,
    // "Optimistic",
    l.S.current.Optimistic,
    //"Reflective",
    l.S.current.Reflective,
    //"Authoritative",
    l.S.current.Authoritative,
    // "Adventurous",
    l.S.current.Adventurous,
    //"Quirky",
    l.S.current.Quirky,
  ];

  List<String> get _toneOfVoiceOptions => [
    //"Friendly",
    l.S.current.friendly,
    //"Professional",
    l.S.current.Professional,
    //"Serious",
    l.S.current.Serious,
    //"Playful",
    l.S.current.Playful,
    //"Confident",
    l.S.current.Confident,
    //"Respectful",
    l.S.current.Respectful,
    //"Empathetic",
    l.S.current.Empathetic,
    //"Bold",
    l.S.current.Bold,
    //"Calm",
    l.S.current.Calm,
    //"Excited",
    l.S.current.Excited,
    //"Persuasive",
    l.S.current.Persuasive,
    // "Caring",
    l.S.current.Caring,
    // "Neutral",
    l.S.current.Neutral,
    //"Optimistic",
    l.S.current.Optimistic,
    //"Inspirational",
    l.S.current.Inspirational,
    // "Sophisticated",
    l.S.current.Sophisticated,
    //"Casual",
    l.S.current.Casual,
    //"Formal",
    l.S.current.Formal,
    //"Humorous",
    l.S.current.Humorous,
    //"Thoughtful",
    l.S.current.Thoughtful,
  ];

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);
    final _mqSize = MediaQuery.sizeOf(context);
    final _addHorizontalPadding = _mqSize.width >= 576;
    final lang = l.S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Generative Form
        ExpansionWidget.autoSaveState(
          initiallyExpanded: true,
          titleBuilder: (aV, eV, iE, tF) => _buildFilterExpansionTile(
            context,
            isExpanded: iE,
            onTap: () => tF(animated: true),
          ),
          content: Form(
            child: ResponsiveGridRow(
              children: [
                // Keywords Field
                ResponsiveGridCol(
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.only(top: 16, bottom: 12),
                    child: TextFieldLabelWrapper(
                      label: Row(
                        children: [
                          Expanded(
                            child: Text(
                              lang.keywordsSeparateWithComma,
                              // 'Keywords (Separate with comma)',
                              style: _theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '0/8',
                            style: _theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      inputField: TextFormField(
                        decoration: InputDecoration(
                          //hintText: 'e.g. maantheme, acnoo',
                          hintText: lang.egMaanthemeAcnoo,
                        ),
                      ),
                    ),
                  ),
                ),

                // Template
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
                      //labelText: 'Template',
                      labelText: lang.template,
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
                            items: _templates,
                          );
                        },
                        value: _templates.firstOrNull,
                        items: _templates.map((item) {
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

                // Language
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
                      //labelText: 'Language',
                      labelText: lang.language,
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
                                      Flexible(
                                        child: Text(
                                          item.key,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textDirection: TextDirection.ltr,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ),

                // Maximum Length
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
                      // labelText: 'Maximum Length',
                      labelText: lang.maximumLength,
                      inputField: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: '500'),
                      ),
                    ),
                  ),
                ),

                // Number of Results
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
                      // labelText: 'Number of Results',
                      labelText: lang.numberOfResults,
                      inputField: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: '2'),
                      ),
                    ),
                  ),
                ),

                // Creativity
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
                      //labelText: 'Creativity',
                      labelText: lang.creativity,
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
                            items: _creativityLevels,
                          );
                        },
                        value: _creativityLevels.first,
                        items: _creativityLevels.map((item) {
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

                // Tone of Voice
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
                      //labelText: 'Tone of Voice',
                      labelText: lang.toneOfVoice,
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
                            items: _toneOfVoiceOptions,
                          );
                        },
                        value: _toneOfVoiceOptions.first,
                        items: _toneOfVoiceOptions.map((item) {
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
                      // child: const Text('Apply'),
                      child: Text(lang.apply),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox.square(dimension: 12),

        // Blog Writing  Suggestion
        Text(
          lang.blogWritingSuggestion,
          //'Blog Writing  Suggestion',
          style: _theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox.square(dimension: 16),

        ...[
          lang.writeAText,
          //"Write a Text",
          lang.compareBusinessStrategies,
          //"Compare business strategies",
          lang.createAPersonalContentForMe,
          //"Create a personal content for me",
        ].map((item) {
          return Container(
            width: double.maxFinite,
            padding: const EdgeInsetsDirectional.only(bottom: 16),
            child: _buildSuggestionTile(context, title: item),
          );
        })
      ],
    );
  }

  Widget _buildFilterExpansionTile(
    BuildContext context, {
    bool isExpanded = false,
    void Function()? onTap,
  }) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 10, 10),
        decoration: BoxDecoration(
          color: _isDark
              ? AcnooAppColors.kDark3
              : AcnooAppColors.kPrimary200.withOpacity(0.50),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                lang.filter,
                //'Filter',
                style: _theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              isExpanded ? MdiIcons.chevronUp : MdiIcons.chevronDown,
              color: _theme.checkboxTheme.side?.color,
            ),
          ],
        ),
      ),
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

  Widget _buildSuggestionTile(
    BuildContext context, {
    required String title,
  }) {
    final _theme = Theme.of(context);
    final _isRtl = Directionality.of(context) == TextDirection.rtl;

    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: _theme.colorScheme.outline),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 10, 12),
        foregroundColor: _theme.colorScheme.onTertiaryContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(title)),
          Icon(
            _isRtl ? MdiIcons.chevronLeft : MdiIcons.chevronRight,
            color: _theme.colorScheme.onTertiaryContainer,
          ),
        ],
      ),
    );
  }
}
