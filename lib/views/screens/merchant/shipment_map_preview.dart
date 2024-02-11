import 'dart:math';

import 'package:camion/data/providers/add_shippment_provider.dart';
import 'package:camion/helpers/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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

  createMarkerIcons() async {
    pickupicon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/icons/location1.png");
    deliveryicon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/icons/location2.png");
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    createMarkerIcons();
    List<Marker> markers = [];
    myMarker.add(
      Marker(
        markerId: const MarkerId("pickup"),
        icon: pickupicon,
        position: widget.pickup,
      ),
    );
    myMarker.add(
      Marker(
        markerId: const MarkerId("delivery"),
        icon: deliveryicon,
        position: widget.delivery,
      ),
    );
    getBounds(myMarker);
  }

  @override
  void initState() {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pick Location",
          style: TextStyle(
            // color: AppColor.lightBlue,
            fontSize: 19.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                  Hero(
                    tag: "shipment_map",
                    child: GoogleMap(
                      initialCameraPosition:
                          ShipmentMapPreview._initialCameraPosition,
                      zoomControlsEnabled: false,

                      markers: myMarker,
                      myLocationEnabled: true,
                      onMapCreated: _onMapCreated,
                      compassEnabled: true,
                      rotateGesturesEnabled: false,
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
                  ),
                  // const Icon(
                  //   Icons.location_pin,
                  //   size: 45,
                  //   color: Colors.red,
                  // )
                ],
              );
            }),
            Positioned(
              bottom: 25.h,
              left: 20.w,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                  //   onPressed: () => controller.changeMapType(),
                  //   child: controller.currentMapType == MapType.normal
                  //       ? Image.asset("assets/icons/sattalite_map.png")
                  //       : Image.asset("assets/icons/normal_map.png"),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
