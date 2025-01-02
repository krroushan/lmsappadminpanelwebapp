import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

//import '../../../../core/helpers/field_styles/_dropdown_styles.dart';
import '../../../../widgets/widgets.dart';

// ignore: must_be_immutable
class Field extends StatelessWidget {
  Field({super.key});
  final List<String> countryNames = [
    'United States',
    'Canada',
    'United Kingdom',
    'Germany',
    'India',
    'Australia',
    'China',
    'Brazil',
    'Japan',
    'South Korea'
  ];
  String? selectedCountry;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    // final _dropdownStyle = AcnooDropdownStyle(context);

    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      lg: 24,
    );
    return Column(
      children: [
        ResponsiveGridRow(children: [
          ResponsiveGridCol(
              lg: 5,
              md: 5,
              child: Padding(
                padding: EdgeInsets.all(_padding / 2.5),
                child: TextFieldLabelWrapper(
                    labelText: 'First Name *',
                    labelStyle: _theme.textTheme.titleSmall
                        ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                    inputField: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter first name ',
                        hintStyle: _theme.textTheme.titleSmall?.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        border: const OutlineInputBorder(),
                      ),
                    )),
              )),
          ResponsiveGridCol(
              lg: 5,
              md: 5,
              child: Padding(
                padding: EdgeInsets.all(_padding / 2.5),
                child: TextFieldLabelWrapper(
                    labelText: 'Last Name *',
                    labelStyle: _theme.textTheme.titleSmall
                        ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                    inputField: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter last name',
                        hintStyle: _theme.textTheme.titleSmall?.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        border: const OutlineInputBorder(),
                      ),
                    )),
              )),
          ResponsiveGridCol(
              lg: 5,
              md: 5,
              child: Padding(
                padding: EdgeInsets.all(_padding / 2.5),
                child: TextFieldLabelWrapper(
                    labelText: 'Company name (optional)',
                    labelStyle: _theme.textTheme.titleSmall
                        ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                    inputField: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter Company name ',
                        hintStyle: _theme.textTheme.titleSmall?.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        border: const OutlineInputBorder(),
                      ),
                    )),
              )),
          ResponsiveGridCol(
              lg: 5,
              md: 5,
              child: Padding(
                padding: EdgeInsets.all(_padding / 2.5),
                child: TextFieldLabelWrapper(
                  labelText: 'Country / Region *',
                  labelStyle: _theme.textTheme.titleSmall
                      ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                  inputField: DropdownButtonFormField2<String>(
                    decoration: InputDecoration(
                      //filled: true, // This enables the fill color ds
                      //fillColor: Colors.lightBlue[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        //horizontal: 16
                      ),
                    ),
                    isExpanded: true,
                    hint: const Text('Select Country'),
                    value: selectedCountry,
                    items: countryNames.map((String country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(
                          country,
                          overflow: TextOverflow.ellipsis,
                          style: _theme.textTheme.titleSmall?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff171717)),
                          //#171717
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {},
                  ),
                ),
              )),
          ResponsiveGridCol(
              lg: 5,
              md: 5,
              child: Padding(
                padding: EdgeInsets.all(_padding / 2.5),
                child: TextFieldLabelWrapper(
                    labelText: 'Street Address *',
                    labelStyle: _theme.textTheme.titleSmall
                        ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                    inputField: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter street address',
                        hintStyle: _theme.textTheme.titleSmall?.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        border: const OutlineInputBorder(),
                      ),
                    )),
              )),
          ResponsiveGridCol(
              lg: 5,
              md: 5,
              child: Padding(
                padding: EdgeInsets.all(_padding / 2.5),
                child: TextFieldLabelWrapper(
                    labelText: 'Town / City*',
                    labelStyle: _theme.textTheme.titleSmall
                        ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                    inputField: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter Town / City',
                        hintStyle: _theme.textTheme.titleSmall?.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        border: const OutlineInputBorder(),
                      ),
                    )),
              )),
          ResponsiveGridCol(
              lg: 5,
              md: 5,
              child: Padding(
                padding: EdgeInsets.all(_padding / 2.5),
                child: TextFieldLabelWrapper(
                    labelText: 'State *',
                    labelStyle: _theme.textTheme.titleSmall
                        ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                    inputField: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter State',
                        hintStyle: _theme.textTheme.titleSmall?.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        border: const OutlineInputBorder(),
                      ),
                    )),
              )),
          ResponsiveGridCol(
              lg: 5,
              md: 5,
              child: Padding(
                padding: EdgeInsets.all(_padding / 2.5),
                child: TextFieldLabelWrapper(
                    labelText: 'ZIP Code *',
                    labelStyle: _theme.textTheme.titleSmall
                        ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                    inputField: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter ZIP Code ',
                        hintStyle: _theme.textTheme.titleSmall?.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        border: const OutlineInputBorder(),
                      ),
                    )),
              )),
          ResponsiveGridCol(
              lg: 5,
              md: 5,
              child: Padding(
                padding: EdgeInsets.all(_padding / 2.5),
                child: TextFieldLabelWrapper(
                    labelText: 'Phone Number *',
                    labelStyle: _theme.textTheme.titleSmall
                        ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                    inputField: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter Phone ',
                        hintStyle: _theme.textTheme.titleSmall?.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        border: const OutlineInputBorder(),
                      ),
                    )),
              )),
          ResponsiveGridCol(
              lg: 5,
              md: 5,
              child: Padding(
                padding: EdgeInsets.all(_padding / 2.5),
                child: TextFieldLabelWrapper(
                    labelText: 'Email Address *',
                    labelStyle: _theme.textTheme.titleSmall
                        ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                    inputField: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter Email address',
                        hintStyle: _theme.textTheme.titleSmall?.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w400),
                        border: const OutlineInputBorder(),
                      ),
                    )),
              )),
          ResponsiveGridCol(
              lg: 10,
              md: 10,
              child: Padding(
                padding: EdgeInsets.all(_padding / 2.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Additional information',
                      style: _theme.textTheme.titleSmall
                          ?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFieldLabelWrapper(
                        labelText: 'Order notes (optional)',
                        labelStyle: _theme.textTheme.titleSmall?.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w500),
                        inputField: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'notes about your order...',
                              hintStyle: _theme.textTheme.titleSmall?.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                              border: const OutlineInputBorder()),
                        ))
                  ],
                ),
              ))
        ]),
      ],
    );
  }
}
