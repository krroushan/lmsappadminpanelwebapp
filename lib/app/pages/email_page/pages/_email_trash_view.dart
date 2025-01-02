import 'package:flutter/material.dart';

import 'pages.dart';

class EmailTrashView extends StatelessWidget {
  const EmailTrashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmailListView(
      listType: EmailListType.trash,
      detailsRoute: '/email/trash/details',
    );
  }
}
