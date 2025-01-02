import 'package:flutter/material.dart';

import 'pages.dart';

class EmailStarredView extends StatelessWidget {
  const EmailStarredView({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmailListView(
      listType: EmailListType.starred,
      detailsRoute: '/email/starred/details',
    );
  }
}
