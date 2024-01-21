import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShippmentPickUpMapScreen extends StatefulWidget {
  int type;
  ShippmentPickUpMapScreen({Key? key, required this.type}) : super(key: key);

  @override
  State<ShippmentPickUpMapScreen> createState() =>
      _ShippmentPickUpMapScreenState();
}

class _ShippmentPickUpMapScreenState extends State<ShippmentPickUpMapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(35.363149, 35.932120),
    zoom: 13,
  );
  Set<Marker> myMarker = new Set();
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  initialCameraPosition: _initialCameraPosition,
                  zoomControlsEnabled: false,
                  onTap: (tapPosition) {
                    // Get.find<PropertyController>()
                    //     .setLocation(tapPosition.latitude, tapPosition.longitude);
                    // Future.delayed(const Duration(seconds: 2), () {
                    //   Get.back();
                    // });

                    // setState(() {
                    //   myMarker = new Set();
                    //   myMarker.add(Marker(
                    //       markerId: MarkerId(tapPosition.toString()),
                    //       position: tapPosition));
                    // });
                  },
                  onCameraMove: (position) {
                    // controller.address_latitude =
                    //     (position.target.latitude.toString());
                    // controller.address_longitude =
                    //     (position.target.longitude.toString());
                    // setState(() {
                    //   myMarker = new Set();
                    //   var newposition = LatLng(position.target.latitude,
                    //       position.target.longitude);
                    //   myMarker.add(Marker(
                    //       markerId: MarkerId(newposition.toString()),
                    //       position: newposition));
                    // });
                    // Get.find<PropertyController>()
                    //     .setCurrentPosition(position);
                  },
                  markers: myMarker,
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                  compassEnabled: true,
                  rotateGesturesEnabled: false,
                  // mapType: controller.currentMapType,
                  mapToolbarEnabled: true,
                ),
                // const Icon(
                //   Icons.location_pin,
                //   size: 45,
                //   color: Colors.red,
                // )
              ],
            ),
            Positioned(
              bottom: 25.h,
              child: InkWell(
                onTap: () {
                  // print(controller.address_latitude);
                  // print(controller.address_longitude);
                  // Get.find<PropertyController>().setLocation(
                  //     double.parse(controller.address_latitude!),
                  //     double.parse(controller.address_longitude!));
                },
                child: Container(
                  height: 50.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Text(
                      "تأكيد الموقع",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 25.h,
              left: 20.w,
              child: Column(
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
