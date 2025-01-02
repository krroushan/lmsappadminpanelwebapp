import 'package:flutter/material.dart';

import 'pages.dart';

class EmailSpamView extends StatelessWidget {
  const EmailSpamView({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmailListView(
      listType: EmailListType.spam,
      detailsRoute: '/email/spam/details',
    );
  }
}
