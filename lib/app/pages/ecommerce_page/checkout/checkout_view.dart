// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:responsive_grid/responsive_grid.dart';
import '../../../../generated/l10n.dart' as l;
// 🌎 Project imports:
import '../../../core/helpers/helpers.dart';
import '../../../widgets/widgets.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final _mqSize = MediaQuery.sizeOf(context);

    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      lg: 24,
    );
    return Scaffold(
      body: SizedBox.fromSize(
        size: const Size.fromWidth(double.maxFinite),
        child: SingleChildScrollView(
          child: ShadowContainer(
            margin: EdgeInsetsDirectional.all(_padding),
            contentPadding: EdgeInsetsDirectional.all(_padding / 2.75),
            showHeader: false,
            child: ResponsiveGridRow(
              children: [
                ResponsiveGridCol(
                  lg: 8,
                  md: _mqSize.width < 992 ? 12 : 8,
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(_padding / 2.25),
                    child: const CheckoutForm(),
                  ),
                ),
                ResponsiveGridCol(
                  lg: 4,
                  md: _mqSize.width < 992 ? 12 : 4,
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(_padding / 2.25),
                    child: const CheckoutOverview(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CheckoutForm extends StatelessWidget {
  const CheckoutForm({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);

    final _dropdownStyle = AcnooDropdownStyle(context);

    final _innerSpacing = responsiveValue<double>(
      context,
      xs: 16,
      lg: 24,
    );

    return ResponsiveGridRow(
      children: [
        ResponsiveGridCol(
          child: Padding(
            padding: EdgeInsetsDirectional.all(
              _innerSpacing / 2.5,
            ),
            child: _buildGradientTop(
              context,
              child: Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: SvgPicture.asset(
                        'assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/coupon_icon.svg',
                      ),
                    ),
                    // const TextSpan(text: ' Have a coupon? '),
                    TextSpan(text: ' ${lang.haveACoupon}? '),
                    TextSpan(
                      //text: 'Click here to enter your code',
                      text: lang.clickHereToEnterYourCode,
                      style: TextStyle(color: _theme.colorScheme.primary),
                    ),
                  ],
                ),
                style: _theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),

        //----------------------Form----------------------//
        // First Name *
        ResponsiveGridCol(
          md: 6,
          child: Padding(
            padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
            child: TextFieldLabelWrapper(
              labelText: '${lang.firstName} *',
              inputField: TextFormField(
                decoration:  InputDecoration(
                  //hintText: 'Enter first name',
                  hintText: lang.enterFirstName,
                ),
              ),
            ),
          ),
        ),

        // Last Name *
        ResponsiveGridCol(
          md: 6,
          child: Padding(
            padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
            child: TextFieldLabelWrapper(
              //labelText: 'Last Name *',
              labelText: '${lang.lastName} *',
              inputField: TextFormField(
                decoration:  InputDecoration(
                  //hintText: 'Enter last name',
                  hintText: lang.enterLastName,
                ),
              ),
            ),
          ),
        ),

        // Company name (optional)
        ResponsiveGridCol(
          md: 6,
          child: Padding(
            padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
            child: TextFieldLabelWrapper(
              //labelText: 'Company name (optional)',
              labelText: lang.companyName,
              inputField: TextFormField(
                decoration:  InputDecoration(
                  //hintText: 'Enter company name',
                  hintText: lang.enterCompanyName,
                ),
              ),
            ),
          ),
        ),

        // Country / Region *
        ResponsiveGridCol(
          md: 6,
          child: Padding(
            padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
            child: TextFieldLabelWrapper(
              //  labelText: 'Country / Region *',
              labelText: '${lang.countryRegion} *',
              inputField: DropdownButtonFormField2(
                style: _dropdownStyle.textStyle,
                iconStyleData: _dropdownStyle.iconStyle,
                buttonStyleData: _dropdownStyle.buttonStyle,
                dropdownStyleData: _dropdownStyle.dropdownStyle,
                menuItemStyleData: _dropdownStyle.menuItemStyle,
                isExpanded: true,
                value: 0,
                items: [
                  'United States',
                  'Canada',
                  'Germany',
                  'Australia',
                  'Brazil',
                  'India',
                  'Japan',
                  'France',
                  'South Africa',
                  'Mexico',
                ].asMap().entries.map((country) {
                  return DropdownMenuItem(
                    value: country.key,
                    child: Text(country.value),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
            ),
          ),
        ),

        // Street Address *
        ResponsiveGridCol(
          md: 6,
          child: Padding(
            padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
            child: TextFieldLabelWrapper(
              // labelText: 'Street Address *',
              labelText: '${lang.streetAddress} *',
              inputField: TextFormField(
                decoration:  InputDecoration(
                  //hintText: 'Enter street address',
                  hintText: lang.enterStreetAddress,
                ),
              ),
            ),
          ),
        ),

        // Town / City*
        ResponsiveGridCol(
          md: 6,
          child: Padding(
            padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
            child: TextFieldLabelWrapper(
              //labelText: 'Town / City*',
              labelText: '${lang.townCity}*',
              inputField: TextFormField(
                decoration:  InputDecoration(
                  //hintText: 'Enter Town / City',
                  hintText: lang.enterTownCity,
                ),
              ),
            ),
          ),
        ),

        // State *
        ResponsiveGridCol(
          md: 6,
          child: Padding(
            padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
            child: TextFieldLabelWrapper(
              labelText: '${lang.state} *',
              inputField: TextFormField(
                decoration:  InputDecoration(
                  // hintText: 'Enter State',
                  hintText: lang.enterState,
                ),
              ),
            ),
          ),
        ),

        // ZIP Code *
        ResponsiveGridCol(
          md: 6,
          child: Padding(
            padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
            child: TextFieldLabelWrapper(
              //labelText: 'ZIP Code *',
              labelText: '${lang.ZIPCode} *',
              inputField: TextFormField(
                decoration:  InputDecoration(
                  //hintText: 'Enter ZIP Code',
                  hintText: lang.enterZIPCode,
                ),
              ),
            ),
          ),
        ),

        // Phone Number *
        ResponsiveGridCol(
          md: 6,
          child: Padding(
            padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
            child: TextFieldLabelWrapper(
              //labelText: 'Phone Number *',
              labelText: '${lang.phoneNumber} *',
              inputField: TextFormField(
                decoration:  InputDecoration(
                  // hintText: 'Enter Phone',
                  hintText: lang.enterPhone,
                ),
              ),
            ),
          ),
        ),

        // Email Address *
        ResponsiveGridCol(
          md: 6,
          child: Padding(
            padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
            child: TextFieldLabelWrapper(
              // labelText: 'Email Address *',
              labelText: '${lang.emailAddress} *',
              inputField: TextFormField(
                decoration:  InputDecoration(
                  //hintText: 'Enter Email address',
                  hintText: lang.enterEmailAddress,
                ),
              ),
            ),
          ),
        ),

        // Additional information
        ResponsiveGridCol(
          child: Padding(
            padding: EdgeInsetsDirectional.all(_innerSpacing / 2.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.additionalInformation,
                  // 'Additional information',
                  style: _theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),

                // Order notes (optional)
                TextFieldLabelWrapper(
                  //labelText: 'Order notes (optional)',
                  labelText: lang.orderNotes,
                  inputField: TextField(
                    decoration: InputDecoration(
                      //hintText: 'Notes about your order...',
                      hintText: '${lang.notesAboutYourOrder}...',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        //----------------------Form----------------------//
      ],
    );
  }
}

class CheckoutOverview extends StatelessWidget {
  const CheckoutOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);

    final _innerSpacing = responsiveValue<double>(
      context,
      xs: 16,
      lg: 24,
    );

    final _border = BorderSide(
      color: _theme.colorScheme.outline,
    );

    return Container(
      margin: EdgeInsetsDirectional.symmetric(
        vertical: _innerSpacing / 2.5,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: BorderDirectional(
          start: _border,
          end: _border,
          bottom: _border,
        ),
      ),
      child: Column(
        children: [
          // Header
          _buildGradientTop(
            context,
            child: Center(
              child: Text(
                lang.yourOrders,
                // 'Your Orders',
                style: _theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ),

          // Overview Section
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              20,
              12,
              20,
              20,
            ),
            child: Column(
              children: [
                // Overview Header
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: BorderDirectional(bottom: _border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lang.product,
                        //'Product',
                        style: _theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        lang.subtotal,
                        // 'Subtotal',
                        style: _theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Order List
                ..._orderList
                    .map((order) {
                  return _buildOrderTile(
                    context,
                    orderName: order.$1,
                    quantity: order.$2,
                    price: order.$3,
                  );
                })
                    .toList()
                    .addBetween(const SizedBox(height: 24)),
                const SizedBox(height: 24),
                Divider(color: _theme.colorScheme.outline),
                const SizedBox(height: 6),

                // Subtotal Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lang.subtotal,
                      // 'Subtotal',
                      style: _theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$143.00',
                      style: _theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Total Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lang.total,
                      // 'Total',
                      style: _theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$143.00',
                      style: _theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Place Order Button
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    //child: const Text('Place Order'),
                    child:  Text(lang.placeOrder),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTile(
      BuildContext context, {
        required String orderName,
        required int quantity,
        required num price,
      }) {
    final _theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  orderName,
                  style: _theme.textTheme.bodyMedium?.copyWith(
                    color: _theme.colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
              Text(
                "x${intl.NumberFormat.currency(
                  symbol: '',
                  decimalDigits: 0,
                ).format(quantity)}",
                style: _theme.textTheme.bodyMedium?.copyWith(
                  color: _theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 4,
          child: Text(
            intl.NumberFormat.simpleCurrency(
              decimalDigits: 2,
            ).format(price),
            style: _theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildGradientTop(
    BuildContext context, {
      required Widget child,
    }) {
  final _theme = Theme.of(context);
  return Container(
    padding: const EdgeInsetsDirectional.all(16),
    decoration: BoxDecoration(
      border: BorderDirectional(
        top: BorderSide(
          color: _theme.colorScheme.primary,
          width: 2,
        ),
      ),
      gradient: LinearGradient(
        begin: AlignmentDirectional.topCenter,
        end: AlignmentDirectional.bottomCenter,
        tileMode: TileMode.decal,
        stops: const [0.0, 0.75],
        colors: [
          _theme.colorScheme.primary.withOpacity(0.1),
          _theme.colorScheme.primary.withOpacity(0.02),
        ],
      ),
    ),
    child: child,
  );
}

List<(String, int, num)> get _orderList {
  return [
    ("Natures Deli Chicken & Rice Meatballs 100g", 2, 11.0),
    ("Natures Deli Chicken & Rice Meatballs 100g", 1, 11.0),
    ("Natures Deli Chicken & Rice Meatballs 100g", 2, 11.0),
    ("Natures Deli Chicken & Rice Meatballs 100g", 1, 11.0),
    ("Natures Deli Chicken & Rice Meatballs 100g", 1, 11.0),
  ];
}
