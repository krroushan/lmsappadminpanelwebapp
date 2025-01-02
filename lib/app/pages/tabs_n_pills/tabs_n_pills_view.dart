// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/helpers/fuctions/helper_functions.dart';
import '../../core/theme/_app_colors.dart';
import '../../widgets/widgets.dart';

class TabsNPillsView extends StatelessWidget {
  const TabsNPillsView({super.key});

  @override
  Widget build(BuildContext context) {
    final _mqSize = MediaQuery.sizeOf(context);
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;

    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.fromSize(
              size: Size.fromHeight(_mqSize.height * 0.40),
              child: TabUnderline(
                theme: _theme,
                textTheme: _textTheme,
              ),
            ),
            const SizedBox(height: 24.0),
            SizedBox.fromSize(
              size: Size.fromHeight(_mqSize.height * 0.665),
              child: Theme(
                data: _theme.copyWith(
                  scrollbarTheme: _theme.scrollbarTheme.copyWith(
                    thumbVisibility: WidgetStateProperty.all(false),
                    trackVisibility: WidgetStateProperty.all(false),
                  ),
                ),
                child: TabPill(
                  theme: _theme,
                  textTheme: _textTheme,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabUnderline extends StatefulWidget {
  const TabUnderline({super.key, required this.theme, required this.textTheme});
  final ThemeData theme;
  final TextTheme textTheme;
  @override
  State<TabUnderline> createState() => _TabUnderlineState();
}

class _TabUnderlineState extends State<TabUnderline>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool showBanner = false;

  String _selectedTitle = 'Home';
  List<String> get _title => [
        //"Home",
        l.S.current.home,
        //"Details",
        l.S.current.details,
        //"Profile",
        l.S.current.profile,
        //"Settings",
        l.S.current.settings
      ];
  @override
  Widget build(BuildContext context) {
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 16,
    );
    return ShadowContainer(
      // contentPadding: EdgeInsets.zero,
      // headerPadding: EdgeInsets.zero,
      customHeader: TabBar(
        splashBorderRadius: BorderRadius.circular(12),
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.tab,
        controller: _tabController,
        indicatorColor: AcnooAppColors.kPrimary600,
        indicatorWeight: 2.0,
        dividerColor: widget.theme.colorScheme.outline,
        unselectedLabelColor: widget.theme.colorScheme.onTertiary,
        onTap: (_) => setState(
          () => _selectedTitle = _title[_],
        ),
        tabs: _title
            .map(
              (e) => Tab(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _padding / 2,
                  ),
                  child: Text(e),
                ),
              ),
            )
            .toList(),
      ),
      decoration: BoxDecoration(
          color: widget.theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TabBarData(
                  textTheme: widget.textTheme,
                  showBanner: false,
                  theme: widget.theme,
                ),
                TabBarData(
                  textTheme: widget.textTheme,
                  showBanner: false,
                  theme: widget.theme,
                ),
                TabBarData(
                  textTheme: widget.textTheme,
                  showBanner: false,
                  theme: widget.theme,
                ),
                TabBarData(
                  textTheme: widget.textTheme,
                  showBanner: false,
                  theme: widget.theme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TabPill extends StatefulWidget {
  const TabPill({
    super.key,
    required this.theme,
    required this.textTheme,
  });
  final ThemeData theme;
  final TextTheme textTheme;

  @override
  State<TabPill> createState() => _TabPillState();
}

class _TabPillState extends State<TabPill> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 16,
    );

    // ignore: unused_local_variable
    String _selectedTitle = 'Home';
    final _title = [
      //"Home",
      l.S.current.home,
      // "Details",
      l.S.current.details,
      // "Profile",
      l.S.current.profile,
      // "Settings",
      l.S.current.settings
    ];
    return ShadowContainer(
      // contentPadding: EdgeInsets.zero,
      // headerPadding: EdgeInsets.zero,
      customHeader: TabBar(
        splashBorderRadius: BorderRadius.circular(12),
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.tab,
        controller: _tabController,
        indicatorColor: AcnooAppColors.kPrimary600,
        indicatorWeight: 2.0,
        dividerColor: widget.theme.colorScheme.outline,
        unselectedLabelColor: widget.theme.colorScheme.onTertiary,
        labelStyle: widget.textTheme.bodyMedium
            ?.copyWith(color: AcnooAppColors.kWhiteColor),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: _tabController.index == 0
                ? const Radius.circular(12)
                : Radius.zero,
            topRight: _tabController.index == 3
                ? const Radius.circular(12)
                : Radius.zero,
          ),
          color: widget.theme.colorScheme.primary,
        ),
        onTap: (_) => setState(
          () => _selectedTitle = _title[_],
        ),
        tabs: _title
            .map(
              (e) => Tab(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _padding / 2,
                  ),
                  child: Text(e),
                ),
              ),
            )
            .toList(),
      ),
      decoration: BoxDecoration(
        color: widget.theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List<Widget>.generate(
                  4,
                  (index) => TabBarData(
                        textTheme: widget.textTheme,
                        showBanner: true,
                        theme: widget.theme,
                      )),
            ),
          ),
        ],
      ),
    );
  }
}

class TabBarData extends StatelessWidget {
  const TabBarData({
    super.key,
    required this.showBanner,
    required this.theme,
    required this.textTheme,
  });

  final ThemeData theme;
  final TextTheme textTheme;
  final String _bannerImg =
      'assets/images/static_images/background_images/background_image_09.jpeg';
  final bool showBanner;
  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: showBanner,
            child: Container(
              height: 273,
              width: 424,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: getImageType(
                _bannerImg,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Visibility(visible: showBanner, child: const SizedBox(height: 14.0)),
          Text('${lang.whatIsLoremIpsum}?',
              style: textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          Text(
              lang
                  .loremIpsumIsSimplyDummyTextOfThePrintingAndTypesettingIndustry2,
              //  'Lorem Ipsumis simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktoppublishing software like Aldus PageMaker including versions of Lorem Ipsum.\nContrary to popular belief, Lorem Ipsum is not simply randomtext. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor atHampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites.\nThestandard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Ciceroare also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.',
              style: textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onTertiary)),
        ],
      ),
    );
  }
}
