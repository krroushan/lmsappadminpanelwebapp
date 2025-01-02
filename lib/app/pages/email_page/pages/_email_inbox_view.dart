import 'package:flutter/material.dart';

import 'pages.dart';

class EmailInboxView extends StatelessWidget {
  const EmailInboxView({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmailListView(
      listType: EmailListType.inbox,
      detailsRoute: '/email/inbox/details',
    );
  }
}
