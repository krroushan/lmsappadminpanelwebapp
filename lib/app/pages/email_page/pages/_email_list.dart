// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../models/models.dart' show EmailModel, emailList;
import '../components/_components.dart';

class EmailListView extends StatefulWidget {
  const EmailListView({
    super.key,
    required this.listType,
    this.detailsRoute,
  });

  final EmailListType listType;
  final String? detailsRoute;

  @override
  State<EmailListView> createState() => _EmailListViewState();
}

class _EmailListViewState extends State<EmailListView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<int> selectedList = <int>[];

  List<EmailModel> emails = [];
  void getEmailList() {
    emails.clear();

    emails = emailList.where((element) {
      return switch (widget.listType) {
        EmailListType.starred => element.isStarred,
        _ => true,
      };
    }).toList();
    setState(() => emails);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getEmailList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _mqSize = MediaQuery.sizeOf(context);
    final _isDesktop = _mqSize.width >= 1240;
    final _isTablet = _mqSize.width >= 768 && !_isDesktop;
    final _isMobile = _mqSize.width < 768;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: _theme.colorScheme.primaryContainer,
      appBar: _buildTopbar(
        context,
        showMobileDesign: _isMobile || _isTablet,
      ),
      drawer: _isMobile || _isTablet
          ? EmailSidebarWidget(
              onSelect: () => scaffoldKey.currentState?.closeDrawer(),
            )
          : null,
      body: ListView.builder(
        itemCount: emails.length,
        itemBuilder: (ctx, idx) {
          final _email = emails[idx];

          return EmailTile(
            key: ValueKey(idx),
            email: _email,
            isSelected: selectedList.contains(idx),
            onSelect: (_) {
              selectedList.contains(idx)
                  ? selectedList.remove(idx)
                  : selectedList.add(idx);

              setState(() => selectedList);
            },
            onStarTap: () => setState(() {
              _email.isStarred = !_email.isStarred;
            }),
            onTap: () {
              ctx.push(widget.detailsRoute ?? '/404');
            },
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildTopbar(
    BuildContext context, {
    bool showMobileDesign = false,
  }) {
    final allSelected =
        emails.isNotEmpty && emails.length == selectedList.length
            ? true
            : selectedList.isNotEmpty
                ? null
                : false;

    return EmailTopbarWidget(
      height: showMobileDesign ? null : 68,
      scaffoldKey: scaffoldKey,
      isMobile: showMobileDesign,
      isAllSelected: allSelected,
      onAllSelect: (value) {
        setState(
          () {
            selectedList = (value ?? false)
                ? List<int>.generate(emails.length, (index) => index)
                : [];
          },
        );
      },
    );
  }
}

enum EmailListType { inbox, starred, sent, drafts, spam, trash }
