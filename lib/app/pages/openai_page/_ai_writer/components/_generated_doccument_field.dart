// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../widgets/widgets.dart';

class GeneratedDocumentField extends StatelessWidget {
  const GeneratedDocumentField({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _defaultTextStyle = DefaultTextStyle.of(context).style;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Document Header
        _buildDocumentHeader(context),
        SizedBox(height: responsiveValue<double>(context, xs: 16, lg: 24)),

        // Mock Document
        Text.rich(
          TextSpan(
            children: [
               TextSpan(
                text:
                    lang.makeUpA5SentenceStoryAboutSharkyAToothBrushingSharkSuperhero,
                   // 'Make up a 5-sentence story about "Sharky", a tooth-brushing shark superhero',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.55,
                ),
              ),
               TextSpan(
                text:
                    //"\n\nCertainly! To provide you with more relevant and effective UX copy for a subscription plan, I'd need some specific details. However, I can offer you a generic example. Please adapt the following based on your product or service specifics:",
                    "\n\n${lang.certainlyToProvideYouWithMoreRelevant}:",
              ),
              TextSpan(
                //text: '\n\nSubscription Plan Title: Premium Membership',
                text: '\n\n${lang.subscriptionPlanTitlePremiumMembership}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _defaultTextStyle.color,
                ),
              ),
               TextSpan(
                text:
                   // '\nUnlock a world of exclusive benefits with our Premium Membership. Enjoy limitless access, early bird privileges, and personalized insights tailored just for you.',
                    '\n${lang.unlockAWorldOfExclusiveBenefitsWithOurPremiumMembership}.',
              ),
              TextSpan(
               // text: '\n\n1. Introduction Section:',
                text: '\n\n${lang.IntroductionSection}:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _defaultTextStyle.color,
                ),
              ),
               TextSpan(
                //text: '\n\nUnlock a World of Exclusive Benefits!',
                text: '\n\n${lang.unlockAWorldOfExclusiveBenefits}!',
              ),
               TextSpan(
                text:
                    //'\n\nUpgrade to our Premium Membership for an unparalleled experience. Enjoy a host of premium features designed to elevate your [Product/Service] journey.',
                    '\n\n${lang.upgradeToOurPremiumMembershipForAnnparalleledExperience}.',
              ),
              TextSpan(
                //text: '\n\n2. Features Highlights:',
                text: '\n\n${lang.FeaturesHighlights}:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _defaultTextStyle.color,
                ),
              ),
               TextSpan(
                text:
                   // '''\nLimitless Access: Dive into unrestricted access to our full range of [Product/Service]. Early Bird Access: Be the first to experience new features, products, and updates before anyone else. Personalized Insights: Tailored recommendations and insights to enhance your [Product/Service] experience based on your preferences.''',
                    '''\n${lang.limitlessAccess}.''',
              ),
              TextSpan(
                //text: '\n\n3. Pricing Information:',
                text: '\n\n${lang.PricingInformation}:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _defaultTextStyle.color,
                ),
              ),
//               const TextSpan(
//                 text: '''\nChoose the plan that suits your needs best:
// Monthly Plan: \$9.99/month
// Annual Plan: Save 20% - \$95.88/year''',
//               ),
               TextSpan(
                text: '''\n${lang.chooseThePlanThatSuitsYourNeedsNest}:
${lang.monthlyPlan999Month}
${lang.annualPlanSave209588year}''',
              ),
              TextSpan(
                //text: '\n\n4. Call-to-Action Section:',
                text: '\n\n${lang.CallToActionSection}:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _defaultTextStyle.color,
                ),
              ),
//               const TextSpan(
//                 text: '''\nReady to elevate your experience?
// [Subscribe Now] Button''',
//               ),
               TextSpan(
                text: '''\n${lang.readyToElevateYourExperience}?
${lang.subscribeNowButton}''',
              ),
              TextSpan(
                //text: '\n\n5. Guarantee Section:',
                text: '\n\n${lang.GuaranteeSection}:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _defaultTextStyle.color,
                ),
              ),
//               const TextSpan(
//                 text: '''\nRisk-Free Satisfaction Guaranteed
// Not satisfied? We offer a 30-day money-back guarantee. No questions asked.''',
//               ),
               TextSpan(
                text: '''\n${lang.riskFreeSatisfactionGuaranteed}
${lang.notSatisfiedWeOfferA30DayMoneyBackGuaranteeNoQuestionsAsked}.''',
              ),
              TextSpan(
                //text: '\n\n6. FAQ Section:',
                text: '\n\n${lang.FAQSection}:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _defaultTextStyle.color,
                ),
              ),
//               const TextSpan(
//                 text: '''\nHave Questions? We've Got Answers.
// How do I cancel my subscription?
// Can I switch plans at any time?
// Is my payment information secure?''',
//               ),
               TextSpan(
                text: '''\n${lang.haveQuestionsWeGotAnswers}.
${lang.howDoICancelMySubscription}?
${lang.canISwitchPlansAtAnyTime}?
${lang.isMyPaymentInformationSecure}?''',
              ),
              TextSpan(
                //text: '\n\n7. Footer Section:',
                text: '\n\n${lang.FooterSection}:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _defaultTextStyle.color,
                ),
              ),
//                TextSpan(
//                 text:
//                     '''\nJoin [Your Company] Premium and experience [Product/Service] like never before. Subscribe now to unlock a new level of excellence!
// Feel free to customize this copy according to your brand voice, specific features, and pricing details.''',
//               ),
              TextSpan(
                text:
                    '''\n${lang.joinYourCompanyPremiumAndExperience}!
${lang.FeelFreeToCustomizeThisCopyAccordingToYourBrandVoice}.''',
              ),
            ],
          ),
          style: _theme.textTheme.bodyLarge?.copyWith(
            color: _theme.colorScheme.onTertiaryContainer,
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
                 // child:  Text('Save'),
                  child:  Text(lang.save),
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
}
