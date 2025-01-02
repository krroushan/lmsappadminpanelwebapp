import 'package:flutter/material.dart';

import 'pages.dart';

class EmailSentView extends StatelessWidget {
  const EmailSentView({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmailListView(
      listType: EmailListType.sent,
      detailsRoute: '/email/sent/details',
    );
  }
}
