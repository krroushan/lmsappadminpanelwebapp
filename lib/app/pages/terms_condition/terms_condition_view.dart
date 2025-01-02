// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../widgets/shadow_container/_shadow_container.dart';

class TermsConditionView extends StatefulWidget {
  const TermsConditionView({super.key});

  @override
  State<TermsConditionView> createState() => _TermsConditionViewState();
}

class _TermsConditionViewState extends State<TermsConditionView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(_padding),
        child: ShadowContainer(
          showHeader: false,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: termsList.length,
            itemBuilder: (context, index) {
              final policy = termsList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      policy['title']!,
                      style: textTheme.titleMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      policy['description']!,
                      style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onTertiary),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

   List<Map<String, String>> get termsList => [
    {
      'title':l.S.current.agreementToTerms,
      //'Agreement to Terms',
      'description':l.S.current.byAccessingOrUsingOurWebsiteAndServices
     // "By accessing or using our website and services, you agree to be bound by these Terms and Conditions. This agreement outlines the rules and regulations governing your use of our platform, including any content, features, and services we offer. It is important that you read these terms carefully before using our services. If you do not agree with any part of these terms, you must not use our website or services. Your continued use of the platform signifies your acceptance of these terms and any future changes to them. We may update these terms from time to time, and it is your responsibility to review them periodically."
    },
    {
      'title': l.S.current.userResponsibilities,
      //'User Responsibilities',
      'description':l.S.current.asAUserOfOurPlatform,
      //'As a user of our platform, you agree to use our services responsibly and in accordance with all applicable laws and regulations. You are responsible for ensuring that any information you provide is accurate and up-to-date. Additionally, you must maintain the confidentiality of your account credentials and are solely responsible for any activities that occur under your account. You agree not to engage in any activity that could harm others or interfere with the normal operation of our services. This includes, but is not limited to, distributing harmful content or attempting to gain unauthorized access to our systems.'
    },
    {
      'title': l.S.current.prohibitedActivities,
     // 'Prohibited Activities',
      'description':l.S.current.youAreProhibitedFromEngagingInActivities,
     // "You are prohibited from engaging in activities that violate the rights of others or the integrity of our platform. This includes, but is not limited to, any form of harassment, intellectual property infringement, or dissemination of malicious software. Using our services for illegal activities, such as fraud or theft, is strictly forbidden. We reserve the right to take appropriate action, including suspending or terminating your access, if you are found to be engaging in any prohibited activities. We also retain the right to report any illegal activities to the appropriate authorities."
    },
    {
      'title': l.S.current.serviceModifications,
      //'Service Modifications',
      'description':l.S.current.weReserveTheRightToModify,
      //"We reserve the right to modify, suspend, or discontinue any part of our services at any time without prior notice. This includes making changes to the functionality, features, or availability of our platform. While we strive to keep you informed about significant changes, we cannot guarantee that all updates will be communicated in advance. It is your responsibility to regularly review our terms and service descriptions for any updates. We are not liable for any loss or damage that may result from such modifications or disruptions. Your continued use of our services following any changes signifies your acceptance of those modifications."
    },
    {
      'title':l.S.current.limitationOfLiability,
      //'Limitation of Liability',
      'description':l.S.current.ourPlatformAndServicesAreProvided,
      //'Our platform and services are provided on an "as is" and "as available" basis. We make no warranties, either express or implied, regarding the accuracy, completeness, or reliability of the content or services provided. We do not guarantee that our services will be uninterrupted or error-free. To the fullest extent permitted by law, we are not liable for any direct, indirect, incidental, or consequential damages arising from your use or inability to use our services. This includes, but is not limited to, damages for loss of data, profits, or other intangible losses. You agree that your sole remedy for dissatisfaction with our services is to stop using them.'
    },
    {
      'title': l.S.current.governingLaw,
      //'Governing Law',
      'description':l.S.current.theseTermsAndConditionsAreGoverned,
      //'These Terms and Conditions are governed by and construed in accordance with the laws of the jurisdiction in which our company is incorporated. Any disputes arising from these terms or your use of our services will be subject to the exclusive jurisdiction of the courts located in that jurisdiction. By agreeing to these terms, you consent to the personal jurisdiction and venue of these courts. This provision does not affect your statutory rights as a consumer. If any part of these terms is found to be invalid or unenforceable, the remaining provisions will continue to apply.'
    },
    {
      'title': l.S.current.changesToTheseTerms,
      //'Changes to These Terms',
      'description':l.S.current.weMayUpdateTheseTermsAndConditionsPeriodically,
      //'We may update these Terms and Conditions periodically to reflect changes in our services or legal requirements. When updates are made, we will post the revised terms on this page with a new effective date. It is your responsibility to review these terms regularly to stay informed about any changes. Continued use of our services after the posting of any changes constitutes acceptance of those changes. If you do not agree with the revised terms, you should discontinue use of our services. We encourage you to check this page frequently to ensure you are aware of the latest terms.'
    },
    {
      'title': l.S.current.contactInformation,
      //'Contact Information',
      'description':l.S.current.ifYouHaveAnyQuestionsOrConcernsRegardingTheseTermsAndConditions
     // 'If you have any questions or concerns regarding these Terms and Conditions, please do not hesitate to contact us. You can reach us through the contact information provided on our website, which includes email addresses, phone numbers, and physical addresses. We are committed to addressing your inquiries and resolving any issues you may have in a timely manner. Your feedback is important to us, and we strive to provide prompt and effective support. Please ensure that you provide accurate contact details so that we can respond to your queries appropriately.'
    },
  ];

}
