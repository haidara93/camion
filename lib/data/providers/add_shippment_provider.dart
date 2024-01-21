// ignore_for_file: avoid_init_to_null, non_constant_identifier_names

import 'package:camion/data/models/co2_report.dart';
import 'package:camion/data/models/place_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class AddShippmentProvider extends ChangeNotifier {
  String _pickup_location_name = "";
  String get pickup_location_name => _pickup_location_name;

  String _delivery_location_name = "";
  String get delivery_location_name => _delivery_location_name;

  TextEditingController _pickup_controller = TextEditingController();
  TextEditingController get pickup_controller => _pickup_controller;

  TextEditingController _delivery_controller = TextEditingController();
  TextEditingController get delivery_controller => _delivery_controller;

  Position? _pickup_position = null;
  Position? get pickup_position => _pickup_position;

  Position? _delivery_position = null;
  Position? get delivery_position => _delivery_position;

  double _pickup_lat = 0.0;
  double get pickup_lat => _pickup_lat;

  double _pickup_lang = 0.0;
  double get pickup_lang => _pickup_lang;

  LatLng? _pickup_latlng = null;
  LatLng? get pickup_latlng => _pickup_latlng;

  Marker? _pickup_marker = Marker(markerId: MarkerId("pickup"));
  Marker? get pickup_marker => _pickup_marker;

  Marker? _delivery_marker = Marker(markerId: MarkerId("delivery"));
  Marker? get delivery_marker => _delivery_marker;

  LatLng? _delivery_latlng = null;
  LatLng? get delivery_latlng => _delivery_latlng;

  double _delivery_lat = 0.0;
  double get delivery_lat => _delivery_lat;

  double _delivery_lang = 0.0;
  double get delivery_lang => _delivery_lang;

  Place? _pickup_place = null;
  Place? get pickup_place => _pickup_place;

  Place? _delivery_place = null;
  Place? get delivery_place => _delivery_place;

  List<LatLng> _polylineCoordinates = [];
  List<LatLng> get polylineCoordinates => _polylineCoordinates;

  late GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;

  LatLng _center = LatLng(35.363149, 35.932120);
  LatLng get center => _center;

  double _zoom = 13.0;
  double get zoom => _zoom;

  LatLngBounds? _bounds = null;
  LatLngBounds? get bounds => _bounds;

  DateTime? _loadTime = null;
  DateTime? get loadTime => _loadTime;

  DateTime? _loadDate = null;
  DateTime? get loadDate => _loadDate;

  MapType _mapType = MapType.normal;
  MapType get mapType => _mapType;

  TextEditingController _time_controller = TextEditingController();
  TextEditingController get time_controller => _time_controller;

  TextEditingController _date_controller = TextEditingController();
  TextEditingController get date_controller => _date_controller;

  Co2Report? _co2report = null;
  Co2Report? get co2report => _co2report;
  DistanceReport? _distancereport = null;
  DistanceReport? get distancereport => _distancereport;

  void onMapCreated(GoogleMapController controller, String _mapStyle) {
    _mapController = controller;
    _mapController.setMapStyle(_mapStyle);
    notifyListeners();
  }

  initForm() {
    _pickup_location_name = "";
    _delivery_location_name = "";
    _pickup_controller = TextEditingController();
    _delivery_controller = TextEditingController();
    _pickup_position = null;
    _delivery_position = null;
    _pickup_lat = 0.0;
    _pickup_lang = 0.0;
    _pickup_latlng = null;
    _pickup_marker = Marker(markerId: MarkerId("pickup"));
    _delivery_marker = Marker(markerId: MarkerId("delivery"));
    _delivery_latlng = null;
    _delivery_lat = 0.0;
    _delivery_lang = 0.0;
    _pickup_place = null;
    _delivery_place = null;
    _polylineCoordinates = [];
    _center = LatLng(35.363149, 35.932120);
    _bounds = null;
    _loadTime = null;
    _loadDate = null;
    _mapType = MapType.normal;
    _time_controller = TextEditingController();
    _date_controller = TextEditingController();
    _co2report = null;
    notifyListeners();
  }

  setCo2Report(Co2Report report) {
    _co2report = report;
    notifyListeners();
  }

  setDistanceReport(DistanceReport report) {
    _distancereport = report;
    notifyListeners();
  }

  setMapMode(MapType type) {
    _mapType = type;
    notifyListeners();
  }

  initMapbounds() {
    print("asd");
    if (_pickup_controller.text.isNotEmpty &&
        _delivery_controller.text.isNotEmpty) {
      List<Marker> markers = [];
      markers.add(
        Marker(
          markerId: MarkerId("pickup"),
          position: LatLng(_pickup_lat, _pickup_lang),
        ),
      );
      markers.add(
        Marker(
          markerId: MarkerId("delivery"),
          position: LatLng(_delivery_lat, _delivery_lang),
        ),
      );
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
      _mapController.animateCamera(cameraUpdate);
      notifyListeners();
    }
  }

  void getBounds(List<Marker> markers) {
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
    _mapController.animateCamera(cameraUpdate);
    notifyListeners();
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w",
      PointLatLng(_pickup_lat, _pickup_lang),
      PointLatLng(_delivery_lat, _delivery_lang),
    );
    _polylineCoordinates = [];
    if (result.points.isNotEmpty) {
      result.points.forEach((element) {
        _polylineCoordinates.add(
          LatLng(
            element.latitude,
            element.longitude,
          ),
        );
      });
    }
    notifyListeners();
  }

  setPickUpPlace(Place place) {
    _pickup_place = place;
    notifyListeners();
  }

  setLoadTime(DateTime time) {
    String am = time.hour > 12 ? 'pm' : 'am';
    _time_controller.text = '${time.hour}:${time.minute} $am';
    _loadTime = time;
    notifyListeners();
  }

  setLoadDate(DateTime date) {
    List months = [
      'jan',
      'feb',
      'mar',
      'april',
      'may',
      'jun',
      'july',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec'
    ];
    var mon = date.month;
    var month = months[mon - 1];
    _date_controller.text = '${date.year}-$month-${date.day}';
    _loadDate = date;
    notifyListeners();
  }

  setDeliveryPlace(Place place) {
    _delivery_place = place;
    notifyListeners();
  }

  setPickUpPosition(Position position) {
    _pickup_position = position;
    notifyListeners();
  }

  setDeliveryPosition(Position position) {
    _delivery_position = position;
    notifyListeners();
  }

  // setPickUpLatLng(LatLng position) {
  //   _pickup_latlng = position;
  //   notifyListeners();
  // }

  // setDeliveryLatLng(LatLng position) {
  //   _delivery_latlng = position;
  //   notifyListeners();
  // }

  setPickupName(String value) {
    _pickup_location_name = value;
    notifyListeners();
  }

  setDeliveryName(String value) {
    _delivery_location_name = value;
    notifyListeners();
  }

  setPickupLatLang(double lat, double lang) {
    _pickup_lat = lat;
    _pickup_lang = lang;
    _pickup_latlng = LatLng(lat, lang);
    notifyListeners();
  }

  setDeliveryLatLang(double lat, double lang) {
    _delivery_lat = lat;
    _delivery_lang = lang;
    _delivery_latlng = LatLng(lat, lang);
    getPolyPoints();
    List<Marker> markers = [];
    markers.add(
      Marker(
        markerId: MarkerId("pickup"),
        position: LatLng(_pickup_lat, _pickup_lang),
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId("delivery"),
        position: LatLng(_delivery_lat, _delivery_lang),
      ),
    );
    getBounds(markers);
    notifyListeners();
  }

  setPickupController(TextEditingController controller) {
    _pickup_controller = controller;
    notifyListeners();
  }

  setDeliveryController(TextEditingController controller) {
    _delivery_controller = controller;
    notifyListeners();
  }
}
