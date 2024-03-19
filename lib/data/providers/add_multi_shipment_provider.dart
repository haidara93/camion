// ignore_for_file: prefer_final_fields, non_constant_identifier_names

import 'dart:convert';

import 'package:camion/data/models/commodity_category_model.dart';
import 'package:camion/data/models/place_model.dart';
import 'package:camion/data/models/shipmentv2_model.dart';
import 'package:camion/data/services/places_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class AddMultiShipmentProvider extends ChangeNotifier {
  Shipmentv2? _shipment;

  Shipmentv2? get shipment => _shipment;

  List<ScrollController?> _scrollController = [ScrollController()];
  List<ScrollController?> get scrollController => _scrollController;

  List<List<TextEditingController>> _commodityWeight_controllers = [];
  List<List<TextEditingController>> get commodityWeight_controllers =>
      _commodityWeight_controllers;

  List<List<CommodityCategory?>> _commodityCategory_controller = [];
  List<List<CommodityCategory?>> get commodityCategory_controller =>
      _commodityCategory_controller;

  List<List<int>> _commodityCategories = [];
  List<List<int>> get commodityCategories => _commodityCategories;

  List<GlobalKey<FormState>> _addShipmentformKey = [GlobalKey<FormState>()];
  List<GlobalKey<FormState>> get addShipmentformKey => _addShipmentformKey;

  List<TextEditingController> _pickup_controller = [TextEditingController()];
  List<TextEditingController> get pickup_controller => _pickup_controller;

  List<List<TextEditingController>> _stoppoints_controller = [[]];
  List<List<TextEditingController>> get stoppoints_controller =>
      _stoppoints_controller;

  List<TextEditingController> _delivery_controller = [TextEditingController()];
  List<TextEditingController> get delivery_controller => _delivery_controller;

  List<String> _pickup_location = [""];
  List<String> get pickup_location => _pickup_location;

  List<String> _delivery_location = [""];
  List<String> get delivery_location => _delivery_location;

  List<List<String>> _stoppoints_location = [[]];
  List<List<String>> get stoppoints_location => _stoppoints_location;

  List<LatLng?> _pickup_latlng = [null];
  List<LatLng?> get pickup_latlng => _pickup_latlng;

  List<List<LatLng?>> _stoppoints_latlng = [[]];
  List<List<LatLng?>> get stoppoints_latlng => _stoppoints_latlng;

  List<LatLng?> _delivery_latlng = [null];
  List<LatLng?> get delivery_latlng => _delivery_latlng;

  List<Marker?> _pickup_marker = [Marker(markerId: MarkerId("pickup"))];
  List<Marker?> get pickup_marker => _pickup_marker;

  List<List<Marker?>> _stop_marker = [[]];
  List<List<Marker?>> get stop_marker => _stop_marker;

  List<Marker?> _delivery_marker = [Marker(markerId: MarkerId("delivery"))];
  List<Marker?> get delivery_marker => _delivery_marker;

  List<Position?> _pickup_position = [null];
  List<Position?> get pickup_position => _pickup_position;

  List<List<Position?>> _stoppoints_position = [[]];
  List<List<Position?>> get stoppoints_position => _stoppoints_position;

  List<Position?> _delivery_position = [null];
  List<Position?> get delivery_position => _delivery_position;

  List<Place?> _pickup_place = [null];
  List<Place?> get pickup_place => _pickup_place;

  List<List<Place?>> _stoppoints_place = [[]];
  List<List<Place?>> get stoppoints_place => _stoppoints_place;

  List<Place?> _delivery_place = [null];
  List<Place?> get delivery_place => _delivery_place;

  int _countpath = 0;
  int get countpath => _countpath;

  List<int> _count = [0];
  List<int> get count => _count;

  List<bool> _truckError = [false];
  List<bool> get truckError => _truckError;

  List<bool> _pathError = [false];
  List<bool> get pathError => _pathError;

  List<bool> _dateError = [false];
  List<bool> get dateError => _dateError;

  List<bool> _pickupLoading = [false];
  List<bool> get pickupLoading => _pickupLoading;

  List<bool> _deliveryLoading = [false];
  List<bool> get deliveryLoading => _deliveryLoading;

  List<List<bool>> _stoppointsLoading = [[]];
  List<List<bool>> get stoppointsLoading => _stoppointsLoading;

  List<bool> _pickupPosition = [false];
  List<bool> get pickupPosition => _pickupPosition;

  List<bool> _deliveryPosition = [false];
  List<bool> get deliveryPosition => _deliveryPosition;

  List<List<bool>> _stoppointsPosition = [[]];
  List<List<bool>> get stoppointsPosition => _stoppointsPosition;

  List<List<int>> _selectedTruckType = [[]];
  List<List<int>> get selectedTruckType => _selectedTruckType;

  List<List<int>> _truckNum = [[]];
  List<List<int>> get truckNum => _truckNum;

  List<List<TextEditingController>> _truckNumController = [[]];
  List<List<TextEditingController>> get truckNumController =>
      _truckNumController;

  List<DateTime> _loadDate = [];
  List<DateTime> get loadDate => _loadDate;

  List<DateTime> _loadTime = [];
  List<DateTime> get loadTime => _loadTime;
  List<TextEditingController> _time_controller = [];
  List<TextEditingController> get time_controller => _time_controller;

  List<TextEditingController> _date_controller = [];
  List<TextEditingController> get date_controller => _date_controller;

  // Initialization method
  void initShipment() {
    if (_shipment == null) {
      _shipment = Shipmentv2(subshipments: []);

      TextEditingController commodityWeightController = TextEditingController();
      _commodityWeight_controllers.add([commodityWeightController]);
      commodityCategories.add([0]);

      commodityCategory_controller.add([null]);
      _date_controller.add(TextEditingController());
      _time_controller.add(TextEditingController());
      _loadDate.add(DateTime.now());
      _loadTime.add(DateTime.now());
      _countpath++;
      _count[0]++;

      notifyListeners();
    }
  }

  setLoadTime(DateTime time, int index) {
    String am = time.hour > 12 ? 'pm' : 'am';
    _time_controller[index].text = '${time.hour}:${time.minute} $am';
    _loadTime[index] = time;
    notifyListeners();
  }

  setLoadDate(DateTime date, int index) {
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
    _date_controller[index].text = '${date.year}-$month-${date.day}';
    _loadDate[index] = date;
    notifyListeners();
  }

  addTruckType(int id, int index) {
    _selectedTruckType[index].add(id);
    _truckNum[index].add(1);
    _truckNumController[index].add(TextEditingController(text: "1"));
    notifyListeners();
  }

  removeTruckType(int id, int index) {
    if (_selectedTruckType[index].indexWhere((item) => item == id) != -1) {
      var removeIndex =
          _selectedTruckType[index].indexWhere((item) => item == id);
      _truckNum[index].removeAt(removeIndex);
      _truckNumController[index][removeIndex].text = "";
      notifyListeners();
      _truckNumController[index].removeAt(removeIndex);
      _selectedTruckType[index].removeAt(removeIndex);
    }
    notifyListeners();
  }

  increaseTruckType(int id, int index) {
    if (_selectedTruckType[index].indexWhere((item) => item == id) != -1) {
      _truckNum[index]
          [_selectedTruckType[index].indexWhere((item) => item == id)]++;
      _truckNumController[index]
              [_selectedTruckType[index].indexWhere((item) => item == id)]
          .text = _truckNum[index]
              [_selectedTruckType[index].indexWhere((item) => item == id)]
          .toString();
    }
    notifyListeners();
  }

  decreaseTruckType(int id, int index) {
    if (_selectedTruckType[index].indexWhere((item) => item == id) != -1) {
      if (_truckNum[index]
              [_selectedTruckType[index].indexWhere((item) => item == id)] >
          1) {
        _truckNum[index]
            [_selectedTruckType[index].indexWhere((item) => item == id)]--;

        _truckNumController[index]
                [_selectedTruckType[index].indexWhere((item) => item == id)]
            .text = _truckNum[index]
                [_selectedTruckType[index].indexWhere((item) => item == id)]
            .toString();
      }
    }
    notifyListeners();
  }

  setPickupLoading(bool value, int index) {
    _pickupLoading[index] = value;
    notifyListeners();
  }

  setPickupPositionClick(bool value, int index) {
    _pickupPosition[index] = value;
    notifyListeners();
  }

  setDeliveryLoading(bool value, int index) {
    _deliveryLoading[index] = value;
    notifyListeners();
  }

  setDeliveryPositionClick(bool value, int index) {
    _deliveryPosition[index] = value;
    notifyListeners();
  }

  setStopPointLoading(bool value, int index, int index2) {
    _stoppointsLoading[index][index2] = value;
    notifyListeners();
  }

  setStopPointPositionClick(bool value, int index, int index2) {
    _stoppointsPosition[index][index2] = value;
    notifyListeners();
  }

  setPickupInfo(dynamic suggestion, int index) async {
    var sLocation = await PlaceService.getPlace(suggestion.placeId);
    _pickup_place[index] = sLocation;
    _pickup_latlng[index] = LatLng(
        sLocation.geometry.location.lat, sLocation.geometry.location.lng);
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${sLocation.geometry.location.lat},${sLocation.geometry.location.lng}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      _pickup_controller[index].text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""},${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
    }
    _pickup_location[index] =
        "${sLocation.geometry.location.lat},${sLocation.geometry.location.lng}";
    notifyListeners();
  }

  Future<void> getAddressForPickupFromMapPicker(
      LatLng position, int index) async {
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      _pickup_latlng[index] = position;
      _pickup_controller[index].text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""},${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
    }
    _pickupLoading[index] = false;
  }

  Future<void> getAddressForDeliveryFromMapPicker(
      LatLng position, int index) async {
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      _delivery_latlng[index] = position;
      _delivery_controller[index].text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""},${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
    }
    _deliveryLoading[index] = false;
  }

  setDeliveryInfo(dynamic suggestion, int index) async {
    var sLocation = await PlaceService.getPlace(suggestion.placeId);
    _delivery_place[index] = sLocation;
    _delivery_latlng[index] = LatLng(
        sLocation.geometry.location.lat, sLocation.geometry.location.lng);
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${sLocation.geometry.location.lat},${sLocation.geometry.location.lng}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      _delivery_controller[index].text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""},${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
    }
    _delivery_location[index] =
        "${sLocation.geometry.location.lat},${sLocation.geometry.location.lng}";
    notifyListeners();
  }

  setStopPointInfo(dynamic suggestion, int index, int index2) async {
    var sLocation = await PlaceService.getPlace(suggestion.placeId);
    _stoppoints_place[index][index2] = sLocation;
    _stoppoints_latlng[index][index2] = LatLng(
        sLocation.geometry.location.lat, sLocation.geometry.location.lng);
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${sLocation.geometry.location.lat},${sLocation.geometry.location.lng}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      _stoppoints_controller[index][index2].text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""},${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
    }
    _stoppoints_location[index][index2] =
        "${sLocation.geometry.location.lat},${sLocation.geometry.location.lng}";
    notifyListeners();
  }

  Future<bool> _handleLocationPermission(
      BuildContext context, int index) async {
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
        _pickupLoading[index] = false;

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
      _pickupLoading[index] = false;

      return false;
    }
    return true;
  }

  Future<void> getCurrentPositionForPickup(
      BuildContext context, int index) async {
    final hasPermission = await _handleLocationPermission(context, index);

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      print(position);
      _pickup_latlng[index] = LatLng(position.latitude, position.longitude);
      _pickup_position[index] = position;
      getAddressForPickupFromLatLng(position, index);
    }).catchError((e) {
      _pickupLoading[index] = false;

      debugPrint(e);
    });
    // _pickupLoading[index] = false;

    notifyListeners();
  }

  Future<void> getAddressForPickupFromLatLng(
      Position position, int index) async {
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      _pickup_controller[index].text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""},${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
    }
    _pickupLoading[index] = false;

    // if (addShippmentProvider!.delivery_location_name.isNotEmpty) {
    //   calculateCo2Report();
    // }
    notifyListeners();
  }

  Future<void> getCurrentPositionForStop(
      BuildContext context, int index, int index2) async {
    final hasPermission = await _handleLocationPermission(context, index);

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      print(position);
      _stoppoints_latlng[index][index2] =
          LatLng(position.latitude, position.longitude);
      _stoppoints_position[index][index2] = position;
      getAddressForStopPointFromLatLng(position, index, index2);
    }).catchError((e) {
      pickupLoading[index] = false;

      debugPrint(e);
    });
    notifyListeners();
  }

  Future<void> getAddressForStopPointFromLatLng(
      Position position, int index, int index2) async {
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      _stoppoints_controller[index][index2].text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""},${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
    }
    _pickupLoading[index] = false;

    // if (addShippmentProvider!.delivery_location_name.isNotEmpty) {
    //   calculateCo2Report();
    // }
    notifyListeners();
  }

  Future<void> getCurrentPositionForDelivery(
      BuildContext context, int index) async {
    final hasPermission = await _handleLocationPermission(context, index);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _delivery_latlng[index] = LatLng(position.latitude, position.longitude);
      _delivery_position[index] = position;
      getAddressForDeliveryFromLatLng(position, index);
    }).catchError((e) {
      _deliveryLoading[index] = false;

      debugPrint(e);
    });
    // _deliveryLoading[index] = false;

    notifyListeners();
  }

  Future<void> getAddressForDeliveryFromLatLng(
      Position position, int index) async {
    var response = await http.get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyADOoc8dgS4K4_qk9Hyp441jWtDSumfU7w"),
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      _delivery_controller[index].text =
          '${(result["results"][0]["address_components"][3]["long_name"]) ?? ""},${(result["results"][0]["address_components"][1]["long_name"]) ?? ""}';
    }
    _deliveryLoading[index] = false;
    notifyListeners();

    // calculateCo2Report();
    // if (evaluateCo2()) {
    //   calculateCo2Report();
    // }
  }

  void addstoppoint(int index) {
    TextEditingController stoppoint_controller = TextEditingController();
    _stoppoints_controller[index].add(stoppoint_controller);
    _stoppoints_location[index].add("");
    _stoppoints_latlng[index].add(null);
    _stoppoints_position[index].add(null);
    _stoppoints_place[index].add(null);
    _stoppointsLoading[index].add(false);
    _stoppointsPosition[index].add(false);
    _stop_marker[index]
        .add(Marker(markerId: MarkerId("stop${_stop_marker[index].length}")));
    notifyListeners();
  }

  void removestoppoint(int index, int index2) {
    _stoppoints_controller[index].removeAt(index2);
    _stoppoints_location[index].removeAt(index2);
    _stoppoints_latlng[index].removeAt(index2);
    _stoppoints_position[index].removeAt(index2);
    _stoppoints_place[index].removeAt(index2);
    _stoppointsLoading[index].removeAt(index2);
    _stoppointsPosition[index].removeAt(index2);
    _stop_marker[index].removeAt(index2);
    notifyListeners();
  }

  void addpath() {
    TextEditingController commodityWeight_controller = TextEditingController();
    _scrollController.add(ScrollController());
    _commodityWeight_controllers.add([commodityWeight_controller]);
    _commodityCategories.add([0]);

    _pathError.add(false);
    _truckError.add(false);
    _dateError.add(false);
    _commodityCategory_controller.add([null]);

    _addShipmentformKey.add(GlobalKey<FormState>());

    _pickup_controller.add(TextEditingController());
    _delivery_controller.add(TextEditingController());
    _stoppoints_controller.add([TextEditingController()]);

    _pickup_location.add("");
    _delivery_location.add("");
    _stoppoints_location.add([""]);

    _pickup_latlng.add(null);
    _delivery_latlng.add(null);
    _stoppoints_latlng.add([null]);

    _pickup_position.add(null);
    _delivery_position.add(null);
    _stoppoints_position.add([null]);

    _pickup_place.add(null);
    _delivery_place.add(null);
    _stoppoints_place.add([null]);

    _pickupLoading.add(false);
    _deliveryLoading.add(false);
    _stoppointsLoading.add([false]);

    _pickupPosition.add(false);
    _deliveryPosition.add(false);
    _stoppointsPosition.add([false]);

    _pickup_marker.add(null);
    _delivery_marker.add(null);
    _stop_marker.add([null]);

    _selectedTruckType.add([]);
    _truckNum.add([]);
    _truckNumController.add([]);

    _date_controller.add(TextEditingController());
    _time_controller.add(TextEditingController());
    _loadDate.add(DateTime.now());
    _loadTime.add(DateTime.now());

    _count.add(0);
    _countpath++;
    _count[_countpath - 1]++;
    notifyListeners();
  }

  void removePath(int index) {
    _scrollController.removeAt(index);
    _commodityWeight_controllers.removeAt(index);
    _commodityCategories.removeAt(index);
    _commodityCategory_controller.removeAt(index);
    _addShipmentformKey.removeAt(index);
    _date_controller.removeAt(index);
    _time_controller.removeAt(index);
    _loadDate.removeAt(index);
    _loadTime.removeAt(index);

    _pathError.removeAt(index);
    _truckError.removeAt(index);
    _dateError.removeAt(index);

    _countpath--;
    _count.removeAt(index);
    notifyListeners();
  }

  void additem(int index) {
    TextEditingController commodityWeight_controller = TextEditingController();

    _commodityWeight_controllers[index].add(commodityWeight_controller);
    _commodityCategories[index].add(0);
    _commodityCategory_controller[index].add(null);

    _count[index]++;
    notifyListeners();
  }

  void removeitem(int index, int index2) {
    _commodityWeight_controllers[index].removeAt(index2);
    _commodityCategories[index].removeAt(index2);
    _commodityCategory_controller[index].removeAt(index2);
    _count[index]--;
    notifyListeners();
  }

  // Add a shipment
  void addShipment(Shipmentv2 shipment) {
    _shipment = shipment;
    notifyListeners();
  }

  // Remove the shipment
  void removeShipment() {
    _shipment = null;
    notifyListeners();
  }

  // Add a sub-shipment
  void addSubShipment(SubShipment subShipment) {
    if (_shipment != null) {
      _shipment!.subshipments ??= [];
      _shipment!.subshipments!.add(subShipment);
      notifyListeners();
    }
  }

  // Remove a sub-shipment
  void removeSubShipment(int index) {
    if (_shipment != null &&
        index >= 0 &&
        index < _shipment!.subshipments!.length) {
      _shipment!.subshipments!.removeAt(index);
      notifyListeners();
    }
  }

  // Add a shipment item to a sub-shipment
  void addShipmentItem(int subShipmentIndex, ShipmentItems shipmentItem) {
    if (_shipment != null &&
        subShipmentIndex >= 0 &&
        subShipmentIndex < _shipment!.subshipments!.length) {
      _shipment!.subshipments![subShipmentIndex].shipmentItems ??= [];
      _shipment!.subshipments![subShipmentIndex].shipmentItems!
          .add(shipmentItem);
      notifyListeners();
    }
  }

  // Remove a shipment item from a sub-shipment
  void removeShipmentItem(int subShipmentIndex, int itemIndex) {
    if (_shipment != null &&
        subShipmentIndex >= 0 &&
        subShipmentIndex < _shipment!.subshipments!.length &&
        itemIndex >= 0 &&
        itemIndex <
            _shipment!.subshipments![subShipmentIndex].shipmentItems!.length) {
      _shipment!.subshipments![subShipmentIndex].shipmentItems!
          .removeAt(itemIndex);
      notifyListeners();
    }
  }

  // Add a path point to a sub-shipment
  void addPathPoint(int subShipmentIndex, PathPoint pathPoint) {
    if (_shipment != null &&
        subShipmentIndex >= 0 &&
        subShipmentIndex < _shipment!.subshipments!.length) {
      _shipment!.subshipments![subShipmentIndex].pathpoints ??= [];
      _shipment!.subshipments![subShipmentIndex].pathpoints!.add(pathPoint);
      notifyListeners();
    }
  }

  // Remove a path point from a sub-shipment
  void removePathPoint(int subShipmentIndex, int pointIndex) {
    if (_shipment != null &&
        subShipmentIndex >= 0 &&
        subShipmentIndex < _shipment!.subshipments!.length &&
        pointIndex >= 0 &&
        pointIndex <
            _shipment!.subshipments![subShipmentIndex].pathpoints!.length) {
      _shipment!.subshipments![subShipmentIndex].pathpoints!
          .removeAt(pointIndex);
      notifyListeners();
    }
  }

  // // Add a truck type to a sub-shipment
  // void addTruckType(int subShipmentIndex, SelectedTruckType truckType) {
  //   if (_shipment != null &&
  //       subShipmentIndex >= 0 &&
  //       subShipmentIndex < _shipment!.subshipments!.length) {
  //     _shipment!.subshipments![subShipmentIndex].truckTypes ??= [];
  //     _shipment!.subshipments![subShipmentIndex].truckTypes!.add(truckType);
  //     notifyListeners();
  //   }
  // }

  // // Remove a truck type from a sub-shipment
  // void removeTruckType(int subShipmentIndex, int truckIndex) {
  //   if (_shipment != null &&
  //       subShipmentIndex >= 0 &&
  //       subShipmentIndex < _shipment!.subshipments!.length &&
  //       truckIndex >= 0 &&
  //       truckIndex <
  //           _shipment!.subshipments![subShipmentIndex].truckTypes!.length) {
  //     _shipment!.subshipments![subShipmentIndex].truckTypes!
  //         .removeAt(truckIndex);
  //     notifyListeners();
  //   }
  // }
}
