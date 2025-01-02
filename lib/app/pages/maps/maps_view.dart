// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../widgets/widgets.dart';

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _rhHomeCenterAcnoo = CameraPosition(
    target: LatLng(23.7545212, 90.389183),
    zoom: 18.7654,
  );

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _padding = responsiveValue<double>(
      context,
      xs: 16 / 2,
      sm: 16 / 2,
      md: 16 / 2,
      lg: 24 / 2,
    );

    final _mapWidget = GoogleMap(
      mapType: MapType.none,
      initialCameraPosition: _rhHomeCenterAcnoo,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_padding),
        child: ResponsiveGridRow(
          children: [
            ResponsiveGridCol(
              child: Padding(
                padding: EdgeInsets.all(_padding),
                child: ShadowContainer(
                  contentPadding: EdgeInsets.zero,
                  //headerText: 'Google Map',
                  headerText: lang.googleMap,
                  child: SizedBox(
                    height: 620,
                    width: double.maxFinite,
                    child: _mapWidget,
                  ),
                ),
              ),
            ),
            ResponsiveGridCol(
              lg: 6,
              child: Padding(
                padding: EdgeInsets.all(_padding),
                child: ShadowContainer(
                  contentPadding: EdgeInsets.zero,
                  //headerText: 'Default Map',
                  headerText: lang.defaultMap,
                  child: SizedBox(
                    height: 400,
                    child: _mapWidget,
                  ),
                ),
              ),
            ),
            ResponsiveGridCol(
              lg: 6,
              child: Padding(
                padding: EdgeInsets.all(_padding),
                child: ShadowContainer(
                  contentPadding: EdgeInsets.zero,
                  //headerText: 'Leaflet Multiple location',
                  headerText: lang.leafletMultipleLocation,
                  child: SizedBox(
                    height: 400,
                    child: _mapWidget,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
