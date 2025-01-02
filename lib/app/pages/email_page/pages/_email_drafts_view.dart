import 'package:flutter/material.dart';

import 'pages.dart';

class EmailDraftsView extends StatelessWidget {
  const EmailDraftsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmailListView(
      listType: EmailListType.drafts,
      detailsRoute: '/email/drafts/details',
    );
  }
}
