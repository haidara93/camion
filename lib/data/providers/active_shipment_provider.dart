import 'package:camion/data/models/kshipment_model.dart';
import 'package:camion/data/models/shipment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class ActiveShippmentProvider extends ChangeNotifier {
  List<GoogleMapController?> _maps = [];
  List<GoogleMapController?> get maps => _maps;

  List<List<LatLng>> _polylineCoordinates = [];
  List<List<LatLng>> get polylineCoordinates => _polylineCoordinates;

  List<LatLng> _truckpolylineCoordinates = [];
  List<LatLng> get truckpolylineCoordinates => _truckpolylineCoordinates;

  List<bool> _finished = [];
  List<bool> get finished => _finished;

  String _mapStyle = "";
  init() {
    rootBundle.loadString('assets/style/map_style.json').then((string) {
      _mapStyle = string;
    });
  }

  void onMapCreated(
      GoogleMapController controller, String _mapStyle, int index) {
    _maps.add(null);
    _maps[index] = controller;
    _maps[index]!.setMapStyle(_mapStyle);
    notifyListeners();
  }

  void getTruckPolylineCoordinates(LatLng position1, LatLng position2) async {
    List<LatLng> _polyline = [];
    PolylinePoints polylinePoints = PolylinePoints();
    _polyline = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w",
      PointLatLng(position1.latitude, position1.longitude),
      PointLatLng(position2.latitude, position2.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((element) {
        _polyline.add(
          LatLng(
            element.latitude,
            element.longitude,
          ),
        );
      });
    }
    print("1111111111111111111111111111");
    notifyListeners();
  }

  getpolylineCoordinates(List<KShipment> shipments) async {
    List<LatLng> _polyline = [];
    _polylineCoordinates = [];
    for (var i = 0; i < shipments.length; i++) {
      _finished.add(false);
      PolylinePoints polylinePoints = PolylinePoints();

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w",
        PointLatLng(
            double.parse(shipments[i]
                .pathPoints!
                .singleWhere((element) => element.pointType == "P")
                .location!
                .split(",")[0]),
            double.parse(shipments[i]
                .pathPoints!
                .singleWhere((element) => element.pointType == "P")
                .location!
                .split(",")[1])),
        PointLatLng(
            double.parse(shipments[i]
                .pathPoints!
                .singleWhere((element) => element.pointType == "D")
                .location!
                .split(",")[0]),
            double.parse(shipments[i]
                .pathPoints!
                .singleWhere((element) => element.pointType == "D")
                .location!
                .split(",")[1])),
      );
      _polyline = [];
      if (result.points.isNotEmpty) {
        result.points.forEach((element) {
          _polyline.add(
            LatLng(
              element.latitude,
              element.longitude,
            ),
          );
        });
      }
      _finished[i] = true;
      _polylineCoordinates.add(_polyline);
      notifyListeners();
      List<Marker> markers = [];
      markers.add(
        Marker(
          markerId: MarkerId("pickup"),
          position: LatLng(
              double.parse(shipments[i]
                  .pathPoints!
                  .singleWhere((element) => element.pointType == "P")
                  .location!
                  .split(",")[0]),
              double.parse(shipments[i]
                  .pathPoints!
                  .singleWhere((element) => element.pointType == "P")
                  .location!
                  .split(",")[1])),
        ),
      );
      markers.add(
        Marker(
          markerId: MarkerId("delivery"),
          position: LatLng(
              double.parse(shipments[i]
                  .pathPoints!
                  .singleWhere((element) => element.pointType == "D")
                  .location!
                  .split(",")[0]),
              double.parse(shipments[i]
                  .pathPoints!
                  .singleWhere((element) => element.pointType == "D")
                  .location!
                  .split(",")[1])),
        ),
      );
      getBounds(markers, _maps[i]!);
      print("get route for ${shipments[i]}");

      notifyListeners();
    }
    notifyListeners();
  }

  void getBounds(List<Marker> markers, GoogleMapController mapcontroller) {
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
    var cameraUpdate = CameraUpdate.newLatLngBounds(_bounds, 50.0);
    mapcontroller.animateCamera(cameraUpdate);
    notifyListeners();
  }
}
