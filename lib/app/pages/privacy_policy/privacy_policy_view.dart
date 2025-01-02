// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import 'package:acnoo_flutter_admin_panel/app/widgets/shadow_container/_shadow_container.dart';
import 'package:acnoo_flutter_admin_panel/generated/l10n.dart' as l;

class PrivacyPolicyView extends StatefulWidget {
  const PrivacyPolicyView({super.key});

  @override
  State<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
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
            itemCount: privacyPolicies.length,
            itemBuilder: (context, index) {
              final policy = privacyPolicies[index];
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

   List<Map<String, String>> get privacyPolicies => [
    {
      'title':
  l.S.current.Introduction,
      //'Introduction',
      'description':l.S.current.ourPrivacyPolicyProvidesAComprehensive,
          //"Our Privacy Policy provides a comprehensive overview of how we manage your information when you visit our website or use our services. It explains the types of data we collect, including personal details and usage information, and how we use this data to improve our offerings. The policy also covers the circumstances under which we may disclose your information to third parties and the measures we take to protect your privacy. We are deeply committed to ensuring that your personal data is handled with the highest level of care and security, safeguarding it against unauthorized access or misuse."
    },
    {
      'title': l.S.current.InformationCollection,
      //'Information Collection',
      'description':l.S.current.weGatherARangeOfInformationToEnhanceYourExperience,
         // 'We gather a range of information to enhance your experience on our website and services. This includes personal details that you voluntarily provide, such as your name, email address, and other contact information. Additionally, we collect usage data like your IP address, browser type, and operating system through cookies, log files, and other tracking technologies. These technologies help us understand how you interact with our site, allowing us to improve our services and deliver a more personalized experience. We ensure that all collected data is handled with strict confidentiality and security measures.'
    },
    {
      'title': l.S.current.UseofInformation,
      //'Use of Information',
      'description':l.S.current.theInformationWeCollectHelpsUsEnhanceOurServices,
          //"The information we collect helps us enhance our services and tailor your experience to your preferences. We use your data to communicate with you effectively and to personalize your interactions with our platform. Additionally, your data may be utilized for research and analytics purposes, allowing us to better understand user behavior and improve our offerings."
    },
    {
      'title': l.S.current.DataSharing,
     // 'Data Sharing',
      'description':l.S.current.weDoNotSellOrRentYourPersonalInformationToThirdParties,
         // "We do not sell or rent your personal information to third parties. However, we may share your data with trusted partners who help us operate and improve our services. These partners are carefully selected and are required to adhere to our strict privacy standards, ensuring your information remains secure and confidential."
    },
    {
      'title':l.S.current.DataSecurity,
      //'Data Security',
      'description':l.S.current.weImplementAppropriateSecurityMeasures,
          //'We implement appropriate security measures to protect your personal information from unauthorized access, alteration, or disclosure. Despite our efforts, no data transmission over the internet can be guaranteed to be completely secure.',
    },
    {
      'title':l.S.current.YourRights,
     // 'Your Rights',
      'description':l.S.current.youHaveTheRightToAccessCorrect,
         // 'You have the right to access, correct, or delete your personal information. You can also opt out of certain data collection practices. For more details on how to exercise these rights, please contact us.',
    },
    {
      'title': l.S.current.ChangestoThisPolicy,
      //'Changes to This Policy',
      'description': l.S.current.weMayUpdateThisPrivacyPolicyFromTimeToTime,
      //'We may update this Privacy Policy from time to time. Any changes will be posted on this page, and we encourage you to review it periodically.',
    },
    {
      'title': l.S.current.ContactUs,
     // 'Contact Us',
      'description': l.S.current.ifYouHaveAnyQuestionsOrConcernsAboutOurPrivacyPolicy,
      //'If you have any questions or concerns about our Privacy Policy, please contact us at [contact information].',
    },
  ];
}

