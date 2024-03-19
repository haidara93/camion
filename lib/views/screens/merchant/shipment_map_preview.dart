import 'dart:math';

import 'package:camion/business_logic/bloc/core/draw_route_bloc.dart';
import 'package:camion/data/providers/add_shippment_provider.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class ShipmentMapPreview extends StatefulWidget {
  final LatLng pickup;
  final LatLng delivery;
  ShipmentMapPreview({
    Key? key,
    required this.pickup,
    required this.delivery,
  }) : super(key: key);

  static CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(35.363149, 35.932120),
    zoom: 9,
  );

  @override
  State<ShipmentMapPreview> createState() => _ShipmentMapPreviewState();
}

class _ShipmentMapPreviewState extends State<ShipmentMapPreview> {
  Set<Marker> myMarker = new Set();

  late GoogleMapController mapController;
  late BitmapDescriptor pickupicon;
  late BitmapDescriptor deliveryicon;

  AddShippmentProvider? addShippmentProvider;
  String _mapStyle = "";
  createMarkerIcons() async {
    pickupicon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/icons/location1.png");
    deliveryicon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/icons/location2.png");
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      addShippmentProvider =
          Provider.of<AddShippmentProvider>(context, listen: false);
      addShippmentProvider!.initMapbounds();

      createMarkerIcons();
    });
    rootBundle.loadString('assets/style/normal_style.json').then((string) {
      _mapStyle = string;
    });
    super.initState();
  }

  void getBounds(Set<Marker> markers) {
    try {
      var lngs = markers.map<double>((m) => m.position.longitude).toList();
      var lats = markers.map<double>((m) => m.position.latitude).toList();

      double topMost = lngs.reduce(max);
      double leftMost = lats.reduce(min);
      double rightMost = lats.reduce(max);
      double bottomMost = lngs.reduce(min);

      LatLngBounds _bounds = LatLngBounds(
        northeast: LatLng(rightMost, topMost),
        southwest: LatLng(leftMost, bottomMost),
      );
      print("333333");
      var cameraUpdate = CameraUpdate.newLatLngBounds(_bounds, 50.0);
      mapController.animateCamera(cameraUpdate);
    } catch (e) {
      print(e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<DrawRouteBloc>(context).add(DrawRoute());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            // title: Text(
            //   "Pick Location",
            //   style: TextStyle(
            //     // color: AppColor.lightBlue,
            //     fontSize: 19.sp,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            ),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Consumer<AddShippmentProvider>(
                  builder: (context, shippmentProvider, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    GoogleMap(
                      initialCameraPosition:
                          ShipmentMapPreview._initialCameraPosition,
                      zoomControlsEnabled: false,

                      markers: {
                        Marker(
                          markerId: const MarkerId("pickup"),
                          position: LatLng(
                              double.parse(shippmentProvider.pickup_location
                                  .split(",")[0]),
                              double.parse(shippmentProvider.pickup_location
                                  .split(",")[1])),
                          icon: pickupicon,
                        ),
                        Marker(
                          markerId: const MarkerId("delivery"),
                          position: LatLng(
                              double.parse(shippmentProvider.delivery_location
                                  .split(",")[0]),
                              double.parse(shippmentProvider.delivery_location
                                  .split(",")[1])),
                          icon: deliveryicon,
                        ),
                      },
                      myLocationEnabled: true,
                      onMapCreated: (controller) {
                        shippmentProvider.onMapCreated(controller, _mapStyle);
                        shippmentProvider.initMapbounds();
                      },
                      compassEnabled: true,
                      // rotateGesturesEnabled: false,
                      // mapType: controller.currentMapType,
                      mapToolbarEnabled: true,
                      polylines: shippmentProvider
                              .polylineCoordinates.isNotEmpty
                          ? {
                              Polyline(
                                polylineId: const PolylineId("route"),
                                points: shippmentProvider.polylineCoordinates,
                                color: AppColor.deepYellow,
                                width: 5,
                              ),
                            }
                          : {},
                    ),
                    // const Icon(
                    //   Icons.location_pin,
                    //   size: 45,
                    //   color: Colors.red,
                    // )
                  ],
                );
              }),
              // Positioned(
              //   bottom: 25.h,
              //   left: 20.w,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              // FloatingActionButton(
              //   foregroundColor: Colors.black,
              //   onPressed: () {
              //     controller.gotolocation();
              //   },
              //   child: const Icon(Icons.center_focus_strong),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // FloatingActionButton(
              //   tooltip: "تغيير نمط الخريطة",
              //   foregroundColor: Colors.black,
              //   onPressed: () {},
              //   child: controller.currentMapType == MapType.normal
              //       ? Image.asset("assets/icons/sattalite_map.png")
              //       : Image.asset("assets/icons/normal_map.png"),
              // ),
              //   ],
              // ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
