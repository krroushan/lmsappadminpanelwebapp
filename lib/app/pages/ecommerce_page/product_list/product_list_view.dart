import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../providers/providers.dart';
import 'components/_components.dart' as comp;
import 'layouts/layouts.dart' as layout;

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  comp.ProductLayoutType currentLayout = comp.ProductLayoutType.grid;
  late final scrollController = ScrollController();
  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: Durations.medium3,
      curve: Curves.easeInToLinear,
    );
  }

  int filterId = 1;

  // Pagination Data
  int showPerPage = 10;
  int currentPage = 1;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _productListProv =
        Provider.of<ECommerceMockProductsNotifier>(context);

    final _theme = Theme.of(context);
    final _mqSize = MediaQuery.sizeOf(context);
    final _isDesktop = _mqSize.width >= 992;

    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      md: _isDesktop ? 24 : 16,
      lg: 24,
    );

    final _innerPadding = responsiveValue<EdgeInsetsGeometry?>(
      context,
      xs: EdgeInsetsDirectional.symmetric(vertical: _padding),
      md: _isDesktop
          ? EdgeInsetsDirectional.fromSTEB(_padding, _padding, 0, 0)
          : null,
    );

    return Scaffold(
      key: scaffoldKey,
      drawer: _isDesktop
          ? null
          : const Drawer(
              shape: RoundedRectangleBorder(),
              child: SingleChildScrollView(
                child: comp.FilterSidebar(),
              ),
            ),
      body: ScrollbarTheme(
        data: const ScrollbarThemeData(),
        child: SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsetsDirectional.all(_padding / 2.5),
          child: ResponsiveGridRow(
            children: [
              if (_isDesktop)
                ResponsiveGridCol(
                  lg: 3,
                  md: _mqSize.width < 992 ? null : 3,
                  child: Container(
                    margin: EdgeInsetsDirectional.only(
                      start: _padding / 2.5,
                      bottom: _padding / 2.5,
                      top: _padding / 2.5,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadiusDirectional.only(
                        topStart: Radius.circular(4),
                        bottomStart: Radius.circular(4),
                        bottomEnd: Radius.circular(4),
                      ),
                      border: currentLayout != comp.ProductLayoutType.border
                          ? null
                          : Border.all(color: _theme.colorScheme.outline),
                    ),
                    child: const comp.FilterSidebar(),
                  ),
                ),

              // Product List
              ResponsiveGridCol(
                lg: 9,
                md: _mqSize.width < 992 ? null : 9,
                child: Padding(
                  padding: _isDesktop
                      ? EdgeInsetsDirectional.fromSTEB(
                          0,
                          0,
                          _padding / 2.5,
                          _padding / 2.5,
                        )
                      : EdgeInsets.all(_padding / 2.5),
                  child: Column(
                    children: [
                      SizedBox(height: _padding / 2.5),
                      comp.Topbar(
                        scaffoldKey: scaffoldKey,
                        showDesktop: _isDesktop,
                        selectedLayout: currentLayout,
                        onLayoutSelect: (value) => setState(
                          () => currentLayout = value,
                        ),
                        perPage: showPerPage,
                        onPerpageChange: (v) {
                          if (currentPage > comp.PaginationWidget.pageCount) {
                            setState(
                              () =>
                                  currentPage = comp.PaginationWidget.pageCount,
                            );
                          }
                          _productListProv.loadProductsForPage(
                            currentPage,
                            v!,
                          );
                          setState(() => showPerPage = v);
                        },
                        filterId: filterId,
                        onFilterChange: (v) => setState(() => filterId = v!),
                      ),

                      // Products
                      switch (currentLayout) {
                        comp.ProductLayoutType.grid ||
                        comp.ProductLayoutType.border =>
                          layout.ProductsGridLayout(
                            showBorder:
                                currentLayout == comp.ProductLayoutType.border,
                            padding: _innerPadding,
                          ),
                        comp.ProductLayoutType.tile =>
                          layout.ProductsListLayout(
                            padding: _innerPadding,
                          ),
                      },
                      const SizedBox(height: 24),

                      // Pagination
                      SizedBox(
                        width: double.maxFinite,
                        child: Align(
                          child: comp.PaginationWidget(
                            currentPage: currentPage,
                            totalItem: _productListProv.totalProducts,
                            perPage: showPerPage,
                            onPagePress: (page) => _handlePageChange(
                              page,
                              _productListProv,
                            ),
                            onNextPressed: (page) => _handlePageChange(
                              page,
                              _productListProv,
                            ),
                            onPreviousPressed: (page) => _handlePageChange(
                              page,
                              _productListProv,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePageChange(int page, ECommerceMockProductsNotifier notifier) {
    notifier.loadProductsForPage(page, showPerPage);
    setState(() => currentPage = page);
    scrollToTop();
  }
}
