import 'dart:convert';
import 'dart:io';

import 'package:camion/data/models/shipment_model.dart';
import 'package:camion/data/models/user_model.dart';
import 'package:camion/helpers/http_helper.dart';
import 'package:camion/data/models/truck_type_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ShippmentRerository {
  late SharedPreferences prefs;
  List<TruckType> truckTypes = [];
  List<PackageType> packageTypes = [];
  List<Shipment> shipments = [];

  Future<List<Shipment>> getShipmentList(String status) async {
    shipments = [];
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    var response = await HttpHelper.get(
      "$SHIPPMENTS_ENDPOINT?shipment_status=$status",
      apiToken: jwt,
    );
    var myDataString = utf8.decode(response.bodyBytes);
    var json = jsonDecode(myDataString);
    if (response.statusCode == 200) {
      for (var element in json) {
        shipments.add(Shipment.fromJson(element));
      }

      return shipments.reversed.toList();
    } else {
      return shipments;
    }
  }

  Future<List<TruckType>> getTruckTypes() async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get(TRUCK_TYPES_ENDPOINT, apiToken: jwt);
    truckTypes = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      for (var element in result) {
        truckTypes.add(TruckType.fromJson(element));
      }
    }
    return truckTypes;
  }

  Future<List<PackageType>> getPackageTypes() async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get(PACKAGE_TYPES_ENDPOINT, apiToken: jwt);
    packageTypes = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      for (var element in result) {
        packageTypes.add(PackageType.fromJson(element));
      }
    }
    return packageTypes;
  }

  Future<int?> createShipment(Shipment shipment) async {
    prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var request = http.MultipartRequest('POST', Uri.parse(SHIPPMENTS_ENDPOINT));
    request.headers.addAll({
      HttpHeaders.authorizationHeader: "JWT $token",
      HttpHeaders.contentTypeHeader: "multipart/form-data"
    });

    List<Map<String, dynamic>> shipment_items = [];
    for (var element in shipment.shipmentItems!) {
      var item = element.toJson();
      shipment_items.add(item);
    }

    var dataString = prefs.getString("userProfile");
    print(dataString);
    UserModel userModel = UserModel.fromJson(jsonDecode(dataString!));

    request.fields['merchant'] = userModel.merchant!.toString();
    request.fields['total_weight'] = shipment.totalWeight.toString();
    request.fields['truck_type'] = shipment.truckType!.id!.toString();
    request.fields['pickup_city_location'] =
        shipment.pickupCityLocation.toString();
    request.fields['pickup_city_lat'] = shipment.pickupCityLat.toString();
    request.fields['pickup_city_lang'] = shipment.pickupCityLang.toString();
    request.fields['delivery_city_location'] =
        shipment.deliveryCityLocation.toString();
    request.fields['delivery_city_lat'] = shipment.deliveryCityLat.toString();
    request.fields['delivery_city_lang'] = shipment.deliveryCityLang.toString();
    request.fields['pickup_date'] = shipment.pickupDate.toString();
    request.fields['shipment_items'] = jsonEncode(shipment_items);
    print(jsonEncode(shipment_items));
    var response = await request.send();
    if (response.statusCode == 201) {
      final respStr = await response.stream.bytesToString();
      print(respStr);
      var res = jsonDecode(respStr);
      return res['truck_type'];
    } else {
      final respStr = await response.stream.bytesToString();
      return null;
    }
  }

  Future<bool> assignDriver(int driver) async {
    prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var response = await HttpHelper.patch(
      "$SHIPPMENTS_ENDPOINT$driver/assign_driver/",
      {"driver": driver},
      apiToken: token,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}