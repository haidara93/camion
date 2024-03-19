// ignore_for_file: avoid_init_to_null, non_constant_identifier_names

import 'dart:convert';

import 'package:camion/data/models/co2_report.dart';
import 'package:camion/data/models/commodity_category_model.dart';
import 'package:camion/data/models/place_model.dart';
import 'package:camion/data/models/truck_model.dart';
import 'package:camion/data/models/truck_type_model.dart';
import 'package:camion/data/services/places_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

class AddShippmentProvider extends ChangeNotifier {
  String _selectedRadioTile = "I";
  String get selectedRadioTile => _selectedRadioTile;
  bool _selectedRadioTileError = false;
  bool get selectedRadioTileError => _selectedRadioTileError;

  List<TextEditingController> _commodityWeight_controllers = [];
  List<TextEditingController> get commodityWeight_controllers =>
      _commodityWeight_controllers;

  List<TextEditingController?> _commodityCategory_controller = [];
  List<TextEditingController?> get commodityCategory_controller =>
      _commodityCategory_controller;

  List<int> _commodityCategories = [];
  List<int> get commodityCategories => _commodityCategories;

  List<KCommodityCategory?> _commodityCategoriesObjects = [];
  List<KCommodityCategory?> get commodityCategoriesObjects =>
      _commodityCategoriesObjects;

  List<GlobalKey<FormState>> _addShipmentformKey = [GlobalKey<FormState>()];
  List<GlobalKey<FormState>> get addShipmentformKey => _addShipmentformKey;

  TextEditingController _pickup_controller = TextEditingController();
  TextEditingController get pickup_controller => _pickup_controller;

  List<TextEditingController> _stoppoints_controller = [];
  List<TextEditingController> get stoppoints_controller =>
      _stoppoints_controller;

  TextEditingController _delivery_controller = TextEditingController();
  TextEditingController get delivery_controller => _delivery_controller;

  String _pickup_location = "";
  String get pickup_location => _pickup_location;

  String _delivery_location = "";
  String get delivery_location => _delivery_location;

  List<String> _stoppoints_location = [];
  List<String> get stoppoints_location => _stoppoints_location;

  LatLng? _pickup_latlng = null;
  LatLng? get pickup_latlng => _pickup_latlng;

  List<LatLng?> _stoppoints_latlng = [];
  List<LatLng?> get stoppoints_latlng => _stoppoints_latlng;

  LatLng? _delivery_latlng = null;
  LatLng? get delivery_latlng => _delivery_latlng;

  Marker? _pickup_marker = Marker(markerId: MarkerId("pickup"));
  Marker? get pickup_marker => _pickup_marker;

  List<Marker?> _stop_marker = [];
  List<Marker?> get stop_marker => _stop_marker;

  Marker? _delivery_marker = Marker(markerId: MarkerId("delivery"));
  Marker? get delivery_marker => _delivery_marker;

  Position? _pickup_position = null;
  Position? get pickup_position => _pickup_position;

  List<Position?> _stoppoints_position = [];
  List<Position?> get stoppoints_position => _stoppoints_position;

  Position? _delivery_position = null;
  Position? get delivery_position => _delivery_position;

  Place? _pickup_place = null;
  Place? get pickup_place => _pickup_place;

  List<Place?> _stoppoints_place = [];
  List<Place?> get stoppoints_place => _stoppoints_place;

  Place? _delivery_place = null;
  Place? get delivery_place => _delivery_place;

  int _count = 0;
  int get count => _count;

  TruckType? _truckType = null;
  TruckType? get truckType => _truckType;

  bool _truckselected = false;
  bool get truckselected => _truckselected;

  KTruck? _truck = null;
  KTruck? get truck => _truck;

  bool _truckError = false;
  bool get truckError => _truckError;

  bool _pathError = false;
  bool get pathError => _pathError;

  bool _dateError = false;
  bool get dateError => _dateError;

  bool _pickupLoading = false;
  bool get pickupLoading => _pickupLoading;

  bool _deliveryLoading = false;
  bool get deliveryLoading => _deliveryLoading;

  List<bool> _stoppointsLoading = [false];
  List<bool> get stoppointsLoading => _stoppointsLoading;

  bool _pickupPosition = false;
  bool get pickupPosition => _pickupPosition;

  bool _deliveryPosition = false;
  bool get deliveryPosition => _deliveryPosition;

  List<bool> _stoppointsPosition = [false];
  List<bool> get stoppointsPosition => _stoppointsPosition;

  List<LatLng> _polylineCoordinates = [];
  List<LatLng> get polylineCoordinates => _polylineCoordinates;

  late GoogleMapController _mapController2;
  GoogleMapController get mapController2 => _mapController2;

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

  bool _isThereARoute = true;
  bool get isThereARoute => _isThereARoute;

  bool _isThereARouteError = false;
  bool get isThereARouteError => _isThereARouteError;

  bool _thereARoute = true;
  bool get thereARoute => _thereARoute;

  int _totalPassFeeValue = 0;
  int get totalPassFeeValue => _totalPassFeeValue;

  int _totalCosts = 0;
  int get totalCosts => _totalCosts;

  bool _isSearch = false;
  bool get isSearch => _isSearch;

  void setIsSearch(bool value) {
    _isSearch = value;
    notifyListeners();
  }

  void onMapCreated(GoogleMapController controller, String style) {
    _mapController = controller;
    _mapController.setMapStyle(style);
    notifyListeners();
  }

  void onMap2Created(GoogleMapController controller, String style) {
    _mapController2 = controller;
    _mapController2.setMapStyle(style);
    notifyListeners();
  }

  void setMapStyle(String style) async {
    await _mapController
        .setMapStyle(style)
        .onError((error, stackTrace) => print(error));
    notifyListeners();
  }

  void setMap2Style(String style) async {
    await _mapController2
        .setMapStyle(style)
        .onError((error, stackTrace) => print(error));
    notifyListeners();
  }

  void dispose() {
    _mapController.dispose();
    _mapController2.dispose();
  }

  void calculateCosts() {
    _totalPassFeeValue = 0;
    _totalCosts = 0;
    for (var i = 0; i < _commodityCategories!.length; i++) {
      if (_commodityCategoriesObjects[i] != null &&
          _commodityWeight_controllers[i].text.isNotEmpty) {
        var newprice = (_commodityCategoriesObjects[i]!.price! /
                _commodityCategoriesObjects[i]!.weight!) *
            int.parse(_commodityWeight_controllers[i].text);

        _totalPassFeeValue += newprice.toInt();
      }
    }
    _totalCosts += _totalPassFeeValue;
    _totalCosts += 1000000;
    if (_truck != null) {
      _totalCosts += _truck!.fees!;
    }
    _totalCosts;
    notifyListeners();
  }

  void initShipment() {
    if (_commodityCategories.isEmpty) {
      _truckselected = false;
      _totalPassFeeValue = 0;
      _totalCosts = 0;

      TextEditingController commodityWeightController = TextEditingController();
      TextEditingController commodityCatController = TextEditingController();
      _commodityWeight_controllers.add(commodityWeightController);
      _commodityCategory_controller.add(commodityCatController);
      _commodityCategories.add(0);
      _commodityCategoriesObjects.add(null);

      _count++;

      notifyListeners();
    }
  }

  initForm() {
    _totalPassFeeValue = 0;
    _totalCosts = 0;

    _selectedRadioTile = "I";
    _selectedRadioTileError = false;
    _commodityWeight_controllers = [];
    _commodityCategory_controller = [];
    _commodityCategories = [];
    _commodityCategoriesObjects = [];
    _addShipmentformKey = [GlobalKey<FormState>()];
    _pickup_controller = TextEditingController();
    _stoppoints_controller = [];
    _delivery_controller = TextEditingController();
    _pickup_location = "";
    _delivery_location = "";
    _stoppoints_location = [];
    _pickup_latlng = null;
    _stoppoints_latlng = [];
    _delivery_latlng = null;
    _pickup_marker = Marker(markerId: MarkerId("pickup"));
    _stop_marker = [];
    _delivery_marker = Marker(markerId: MarkerId("delivery"));
    _pickup_position = null;
    _stoppoints_position = [];
    _delivery_position = null;
    _pickup_place = null;
    _stoppoints_place = [];
    _delivery_place = null;
    _count = 0;
    _truckType = null;
    _truckselected = false;
    _truck = null;
    _truckError = false;
    _pathError = false;
    _dateError = false;
    _pickupLoading = false;
    _deliveryLoading = false;
    _stoppointsLoading = [false];
    _pickupPosition = false;
    _deliveryPosition = false;
    _stoppointsPosition = [false];
    _polylineCoordinates = [];
    _center = LatLng(35.363149, 35.932120);
    _zoom = 13.0;
    _bounds = null;
    notifyListeners();
  }

  setSelectedRadioTile(String val) {
    _selectedRadioTile = val;
    _selectedRadioTileError = false;
    notifyListeners();
  }

  setCommodityCategory(KCommodityCategory val, int index) {
    _commodityCategory_controller[index]!.text = val.nameAr!;
    _commodityCategories[index] = val.id!;
    _commodityCategoriesObjects[index] = val;
    notifyListeners();
  }

  setSelectedRadioError(bool val) {
    _selectedRadioTileError = val;
    notifyListeners();
  }

  setCo2Report(Co2Report report) {
    _co2report = report;
    notifyListeners();
  }

  setTruckError(bool value) {
    _truckError = value;
    notifyListeners();
  }

  setPathError(bool value) {
    _pathError = value;
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

  setTruckType(TruckType type) {
    _truckType = type;
    notifyListeners();
  }

  setTruck(KTruck truck) {
    _truck = truck;
    _truckselected = true;
    notifyListeners();
  }

  initMapbounds() {
    if (_pickup_controller.text.isNotEmpty &&
        _delivery_controller.text.isNotEmpty) {
      List<Marker> markers = [];
      var pickuplocation = _pickup_location.split(",");
      markers.add(
        Marker(
          markerId: MarkerId("pickup"),
          position: LatLng(
              double.parse(pickuplocation[0]), double.parse(pickuplocation[1])),
        ),
      );

      var deliverylocation = _delivery_location.split(",");

      markers.add(
        Marker(
          markerId: MarkerId("delivery"),
          position: LatLng(double.parse(deliverylocation[0]),
              double.parse(deliverylocation[1])),
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
      print("asd");
      _mapController.animateCamera(cameraUpdate);
      _mapController2.animateCamera(cameraUpdate);
      print("asd");
      // notifyListeners();
    }
  }

  void getBounds(List<Marker> markers) {
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
      var cameraUpdate = CameraUpdate.newLatLngBounds(_bounds, 50.0);
      _mapController.animateCamera(cameraUpdate);
      _mapController2.animateCamera(cameraUpdate);
    } catch (e) {
      print(e.toString());
    }
    print("333333");
    // notifyListeners();
  }

  setIsThereRout(bool value) {
    _isThereARoute = value;
    notifyListeners();
  }

  setIsThereRoutError(bool value) {
    _isThereARouteError = value;
    notifyListeners();
  }

  setThereRout(bool value) {
    _thereARoute = value;
    notifyListeners();
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PolylineWayPoint> waypoints = [];
    for (var element in _stoppoints_location) {
      waypoints.add(PolylineWayPoint(location: element, stopOver: true));
    }
    var pickuplocation = _pickup_location.split(",");
    var deliverylocation = _delivery_location.split(",");

    await polylinePoints
        .getRouteBetweenCoordinates(
            "AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w",
            PointLatLng(
              double.parse(pickuplocation[0]),
              double.parse(pickuplocation[1]),
            ),
            PointLatLng(
              double.parse(deliverylocation[0]),
              double.parse(deliverylocation[1]),
            ),
            wayPoints: waypoints)
        .then(
      (result) {
        _polylineCoordinates = [];
        _isThereARoute = true;

        if (result.points.isNotEmpty) {
          _isThereARoute = true;
          _isThereARouteError = false;
          _thereARoute = true;
          result.points.forEach((element) {
            _polylineCoordinates.add(
              LatLng(
                element.latitude,
                element.longitude,
              ),
            );
          });
        }
        initMapbounds();
      },
    ).onError(
      (error, stackTrace) {
        _isThereARoute = false;
        _thereARoute = false;
        notifyListeners();
      },
    );

    notifyListeners();
  }

  printError() {
    // _isThereARoute = false;
    // notifyListeners();
    // print("error");
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

  setPickupLoading(bool value) {
    _pickupLoading = value;
    notifyListeners();
  }

  setPickupPositionClick(bool value) {
    _pickupPosition = value;
    notifyListeners();
  }

  setDeliveryLoading(bool value) {
    _deliveryLoading = value;
    notifyListeners();
  }

  setDeliveryPositionClick(bool value) {
    _deliveryPosition = value;
    notifyListeners();
  }

  setStopPointLoading(bool value, int index2) {
    _stoppointsLoading[index2] = value;
    notifyListeners();
  }

  setStopPointPositionClick(bool value, int index2) {
    _stoppointsPosition[index2] = value;
    notifyListeners();
  }

  setPickupInfo(dynamic suggestion) async {
    var sLocation = await PlaceService.getPlace(suggestion.placeId);
    _pickup_place = sLocation;
    _pickup_latlng = LatLng(
        sLocation.geometry.location.lat, sLocation.geometry.location.lng);
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?language=ar&latlng=${sLocation.geometry.location.lat},${sLocation.geometry.location.lng}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      _pickup_controller.text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""} , ${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
    }
    _pickup_location =
        "${sLocation.geometry.location.lat},${sLocation.geometry.location.lng}";
    if (_delivery_location.isNotEmpty) {
      getPolyPoints();
    }
    notifyListeners();
  }

  setDeliveryInfo(dynamic suggestion) async {
    var sLocation = await PlaceService.getPlace(suggestion.placeId);
    _delivery_place = sLocation;
    _delivery_latlng = LatLng(
        sLocation.geometry.location.lat, sLocation.geometry.location.lng);
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?language=ar&latlng=${sLocation.geometry.location.lat},${sLocation.geometry.location.lng}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      _delivery_controller.text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""} , ${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
    }
    _delivery_location =
        "${sLocation.geometry.location.lat},${sLocation.geometry.location.lng}";
    if (_delivery_location.isNotEmpty && _pickup_location.isNotEmpty) {
      getPolyPoints();
    }

    notifyListeners();
  }

  setStopPointInfo(dynamic suggestion, int index2) async {
    var sLocation = await PlaceService.getPlace(suggestion.placeId);
    _stoppoints_place[index2] = sLocation;
    _stoppoints_latlng[index2] = LatLng(
        sLocation.geometry.location.lat, sLocation.geometry.location.lng);
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?language=ar&latlng=${sLocation.geometry.location.lat},${sLocation.geometry.location.lng}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      _stoppoints_controller[index2].text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""} , ${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
    }
    _stoppoints_location[index2] =
        "${sLocation.geometry.location.lat},${sLocation.geometry.location.lng}";
    if (_delivery_location.isNotEmpty && _pickup_location.isNotEmpty) {
      getPolyPoints();
    }
    notifyListeners();
  }

  Future<void> getAddressForPickupFromMapPicker(LatLng position) async {
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?language=ar&latlng=${position.latitude},${position.longitude}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      _pickup_latlng = position;
      _pickup_controller.text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""} , ${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
      _pickup_location = "${position.latitude},${position.longitude}";
    }
    _pickupLoading = false;
    if (_delivery_location.isNotEmpty) {
      getPolyPoints();
    }
    notifyListeners();
  }

  Future<void> getAddressForDeliveryFromMapPicker(LatLng position) async {
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?language=ar&latlng=${position.latitude},${position.longitude}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      _delivery_latlng = position;
      _delivery_controller.text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""} , ${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
      _delivery_location = "${position.latitude},${position.longitude}";
    }
    _deliveryLoading = false;
    if (_delivery_location.isNotEmpty) {
      getPolyPoints();
    }
    notifyListeners();
  }

  Future<void> getAddressForStopPointFromMapPicker(
      LatLng position, int index) async {
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?language=ar&latlng=${position.latitude},${position.longitude}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      _stoppoints_latlng[index] = position;
      _stoppoints_controller[index].text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""} , ${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
      _stoppoints_location[index] =
          "${position.latitude},${position.longitude}";
    }
    _stoppointsLoading[index] = false;
    if (_delivery_location.isNotEmpty) {
      getPolyPoints();
    }
    notifyListeners();
  }

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 150,
              left: 10,
              right: 10),
          content: const Text(
            'Location services are disabled. Please enable the services',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      );
      // setState(() {
      //   pickupLoading = false;
      // });
      // return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange,
            dismissDirection: DismissDirection.up,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 150,
                left: 10,
                right: 10),
            content: const Text(
              'Location permissions are denied',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        );
        _pickupLoading = false;

        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 150,
              left: 10,
              right: 10),
          content: const Text(
            'Location permissions are permanently denied, we cannot request permissions.',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      );
      _pickupLoading = false;

      return false;
    }
    return true;
  }

  Future<void> getCurrentPositionForPickup(BuildContext context) async {
    final hasPermission = await _handleLocationPermission(context);

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      print(position);
      _pickup_latlng = LatLng(position.latitude, position.longitude);
      _pickup_position = position;
      _pickup_location = "${position.latitude},${position.longitude}";
      getAddressForPickupFromLatLng(position);
    }).catchError((e) {
      _pickupLoading = false;

      debugPrint(e);
    });
    if (_delivery_location.isNotEmpty) {
      getPolyPoints();
    }
    // _pickupLoading[index] = false;

    notifyListeners();
  }

  Future<void> getAddressForPickupFromLatLng(Position position) async {
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?language=ar&latlng=${position.latitude},${position.longitude}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      _pickup_controller.text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""} , ${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
    }
    _pickupLoading = false;

    // if (addShippmentProvider!.delivery_location_name.isNotEmpty) {
    //   calculateCo2Report();
    // }
    notifyListeners();
  }

  Future<void> getCurrentPositionForStop(
      BuildContext context, int index2) async {
    final hasPermission = await _handleLocationPermission(context);

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      print(position);
      _stoppoints_latlng[index2] =
          LatLng(position.latitude, position.longitude);
      _stoppoints_position[index2] = position;
      _stoppoints_location[index2] =
          "${position.latitude},${position.longitude}";
      getAddressForStopPointFromLatLng(position, index2);
    }).catchError((e) {
      _pickupLoading = false;

      debugPrint(e);
    });
    if (_delivery_location.isNotEmpty && _pickup_location.isNotEmpty) {
      getPolyPoints();
    }
    notifyListeners();
  }

  Future<void> getAddressForStopPointFromLatLng(
      Position position, int index2) async {
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?language=ar&latlng=${position.latitude},${position.longitude}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      _stoppoints_controller[index2].text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""} , ${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
    }
    _pickupLoading = false;

    // if (addShippmentProvider!.delivery_location_name.isNotEmpty) {
    //   calculateCo2Report();
    // }
    notifyListeners();
  }

  Future<void> getCurrentPositionForDelivery(BuildContext context) async {
    final hasPermission = await _handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _delivery_latlng = LatLng(position.latitude, position.longitude);
      _delivery_position = position;
      _delivery_location = "${position.latitude},${position.longitude}";
      getAddressForDeliveryFromLatLng(position);
    }).catchError((e) {
      _deliveryLoading = false;

      debugPrint(e);
    });
    if (_delivery_location.isNotEmpty && _pickup_location.isNotEmpty) {
      getPolyPoints();
    }
    // _deliveryLoading[index] = false;

    notifyListeners();
  }

  Future<void> getAddressForDeliveryFromLatLng(Position position) async {
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?language=ar&latlng=${position.latitude},${position.longitude}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      _delivery_controller.text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""} , ${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
    }
    _deliveryLoading = false;
    notifyListeners();
  }

  void addstoppoint() {
    TextEditingController stoppoint_controller = TextEditingController();
    _stoppoints_controller.add(stoppoint_controller);
    _stoppoints_location.add("");
    _stoppoints_latlng.add(null);
    _stoppoints_position.add(null);
    _stoppoints_place.add(null);
    _stoppointsLoading.add(false);
    _stoppointsPosition.add(false);
    _stop_marker.add(Marker(markerId: MarkerId("stop${_stop_marker.length}")));
    notifyListeners();
  }

  void removestoppoint(int index2) {
    _stoppoints_controller.removeAt(index2);
    _stoppoints_location.removeAt(index2);
    _stoppoints_latlng.removeAt(index2);
    _stoppoints_position.removeAt(index2);
    _stoppoints_place.removeAt(index2);
    _stoppointsLoading.removeAt(index2);
    _stoppointsPosition.removeAt(index2);
    _stop_marker.removeAt(index2);
    notifyListeners();
  }

  void additem() {
    TextEditingController commodityWeightController = TextEditingController();
    TextEditingController commodityCatController = TextEditingController();
    _commodityWeight_controllers.add(commodityWeightController);
    _commodityCategory_controller.add(commodityCatController);
    _commodityCategories.add(0);
    _commodityCategoriesObjects.add(null);
    print(_commodityWeight_controllers.length);
    print(_commodityCategoriesObjects.length);
    print(_commodityCategory_controller.length);
    _count++;
    notifyListeners();
  }

  void removeitem(int index2) {
    _commodityWeight_controllers.removeAt(index2);
    _commodityCategories.removeAt(index2);
    _commodityCategoriesObjects.removeAt(index2);
    _commodityCategory_controller.removeAt(index2);
    _count--;
    notifyListeners();
  }

  Future<void> updateMap(LatLng position) async {
    await _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 14.47),
      ),
    );
    await _mapController2.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 14.47),
      ),
    );
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
