import 'dart:convert';

import 'package:camion/data/providers/add_shippment_provider.dart';
import 'package:camion/views/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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

  bool pickupLoading = false;
  bool deliveryLoading = false;
  AddShippmentProvider? addShippmentProvider;

  LatLng? selectedPosition;
  late BitmapDescriptor pickupicon;
  late BitmapDescriptor deliveryicon;

  createMarkerIcons() async {
    pickupicon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(30, 50)),
        "assets/icons/location1.png");
    deliveryicon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/icons/location2.png");
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      addShippmentProvider =
          Provider.of<AddShippmentProvider>(context, listen: false);
      addShippmentProvider!.initMapbounds();
      createMarkerIcons();
    });
    super.initState();
  }

  Future<void> _getAddressForPickupFromLatLng(LatLng position) async {
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      addShippmentProvider!.setPickupName(
          result["results"][0]["address_components"][1]["long_name"]);
      addShippmentProvider!.pickup_controller.text =
          result["results"][0]["address_components"][1]["long_name"];
    }
    setState(() {
      pickupLoading = false;
    });
    Navigator.pop(context);
  }

  Future<void> _getAddressForDeliveryFromLatLng(LatLng position) async {
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      addShippmentProvider!.setDeliveryName(
          result["results"][0]["address_components"][1]["long_name"]);
      addShippmentProvider!.delivery_controller.text =
          result["results"][0]["address_components"][1]["long_name"];
    }
    setState(() {
      pickupLoading = false;
    });
    Navigator.pop(context);
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
                    //   selectedPosition = tapPosition;
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
                    setState(() {
                      selectedPosition = LatLng(
                          position.target.latitude, position.target.longitude);
                      myMarker = new Set();
                      var newposition = LatLng(
                          position.target.latitude, position.target.longitude);
                      myMarker.add(Marker(
                          markerId: MarkerId(newposition.toString()),
                          position: newposition,
                          icon: widget.type == 0 ? pickupicon : deliveryicon));
                    });
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
            selectedPosition != null
                ? Positioned(
                    bottom: 25.h,
                    child: pickupLoading
                        ? Container(
                            height: 50.h,
                            width: 150.w,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Center(
                              child: LoadingIndicator(),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                pickupLoading = true;
                              });
                              // print(controller.address_latitude);
                              // print(controller.address_longitude);
                              // Get.find<PropertyController>().setLocation(
                              //     double.parse(controller.address_latitude!),
                              //     double.parse(controller.address_longitude!));
                              if (widget.type == 0) {
                                addShippmentProvider!.setPickupLatLang(
                                    selectedPosition!.latitude,
                                    selectedPosition!.longitude);

                                _getAddressForPickupFromLatLng(
                                    selectedPosition!);
                              } else if (widget.type == 1) {
                                addShippmentProvider!.setDeliveryLatLang(
                                    selectedPosition!.latitude,
                                    selectedPosition!.longitude);

                                _getAddressForDeliveryFromLatLng(
                                    selectedPosition!);
                              }
                            },
                            child: Container(
                              height: 50.h,
                              width: 150.w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              child: const Center(
                                child: Text(
                                  "confirm",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  )
                : const SizedBox.shrink(),
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
