import 'dart:convert';
import 'dart:io';

import 'package:camion/data/models/commodity_category_model.dart';
import 'package:camion/data/models/instruction_model.dart';
import 'package:camion/data/models/kshipment_model.dart';
import 'package:camion/data/models/shipment_model.dart';
import 'package:camion/data/models/shipmentv2_model.dart';
import 'package:camion/data/models/user_model.dart';
import 'package:camion/helpers/http_helper.dart';
import 'package:camion/data/models/truck_type_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ShippmentRerository {
  late SharedPreferences prefs;
  List<TruckType> truckTypes = [];
  List<PackageType> packageTypes = [];
  List<CommodityCategory> commodityCategories = [];
  List<KCommodityCategory> kcommodityCategories = [];
  List<KCategory> kCategories = [];
  List<Shipment> shipments = [];
  List<KShipment> kshipments = [];
  List<ManagmentShipment> mshipments = [];

  Future<bool> updateKShipmentStatus(String state, int shipmentId) async {
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    var response = await HttpHelper.patch(
      "$KSHIPPMENTS_ENDPOINT$shipmentId/",
      {"shipment_status": state},
      apiToken: jwt,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<CommodityCategory>> getCommodityCategories() async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get(COMMODITY_CATEGORIES_ENDPOINT, apiToken: jwt);
    commodityCategories = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      for (var element in result) {
        commodityCategories.add(CommodityCategory.fromJson(element));
      }
    }
    return commodityCategories;
  }

  Future<List<KCategory>> getKCommodityCategories() async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get(K_CATEGORIES_ENDPOINT, apiToken: jwt);
    kCategories = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      for (var element in result) {
        kCategories.add(KCategory.fromJson(element));
      }
    }
    return kCategories;
  }

  Future<List<KCommodityCategory>> searchKCommodityCategories(
      String query) async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get(
        "$KCOMMODITY_CATEGORIES_ENDPOINT?search=$query",
        apiToken: jwt);
    kcommodityCategories = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      for (var element in result) {
        kcommodityCategories.add(KCommodityCategory.fromJson(element));
      }
    }
    return kcommodityCategories;
  }

  Future<List<Shipment>> getShipmentList(String status) async {
    shipments = [];
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    var merchant = prefs.getInt("merchant") ?? 0;

    var response = await HttpHelper.get(
      "$SHIPPMENTS_ENDPOINT?shipment_status=$status&merchant=$merchant&driver=",
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

  Future<List<KShipment>> getKShipmentList(String status) async {
    kshipments = [];
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    var merchant = prefs.getInt("merchant") ?? 0;

    var response = await HttpHelper.get(
      "$KSHIPPMENTS_ENDPOINT?shipment_status=$status&merchant=$merchant",
      apiToken: jwt,
    );
    var myDataString = utf8.decode(response.bodyBytes);
    var json = jsonDecode(myDataString);
    if (response.statusCode == 200) {
      for (var element in json) {
        kshipments.add(KShipment.fromJson(element));
        print(response.statusCode);
      }

      return kshipments.reversed.toList();
    } else {
      return kshipments;
    }
  }

  Future<List<ManagmentShipment>> getManagmentKShipmentList(
      String status) async {
    mshipments = [];
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var response = await HttpHelper.get(
      "${KSHIPPMENTS_ENDPOINT}filter_by_status/?shipment_status=$status",
      apiToken: jwt,
    );
    var myDataString = utf8.decode(response.bodyBytes);
    var json = jsonDecode(myDataString);
    if (response.statusCode == 200) {
      for (var element in json) {
        mshipments.add(ManagmentShipment.fromJson(element));
        print(response.statusCode);
      }

      return mshipments.reversed.toList();
    } else {
      return mshipments;
    }
  }

  Future<List<Shipment>> getDriverShipmentList(String status) async {
    shipments = [];
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    var driver = prefs.getInt("truckuser") ?? 0;
    print(driver.toString());

    var response = await HttpHelper.get(
      "$SHIPPMENTS_ENDPOINT?shipment_status=$status&merchant=&driver=$driver",
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

  Future<List<Shipment>> getActiveDriverShipmentForOwner(
      String status, int driverId) async {
    shipments = [];
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var response = await HttpHelper.get(
      "$SHIPPMENTS_ENDPOINT?shipment_status=$status&merchant=&driver=$driverId",
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

  Future<List<Shipment>> getDriverShipmentListForOwner(
      String status, int driverId) async {
    shipments = [];
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    var response = await HttpHelper.get(
      "$SHIPPMENTS_ENDPOINT?shipment_status=$status&merchant=&driver=$driverId",
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

  Future<List<Shipment>> getOwnerShipmentList(String status) async {
    shipments = [];
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    // var driver = prefs.getInt("truckowner") ?? 0;

    var response = await HttpHelper.get(
      "${SHIPPMENTS_ENDPOINT}pending_shipments_for_owner/?shipment_status=$status",
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

  Future<List<KShipment>> getOwnerKShipmentList(String status) async {
    kshipments = [];
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    // var driver = prefs.getInt("truckowner") ?? 0;

    var response = await HttpHelper.get(
      "${KSHIPPMENTS_ENDPOINT}pending_shipments_for_owner/?shipment_status=$status",
      apiToken: jwt,
    );
    var myDataString = utf8.decode(response.bodyBytes);
    var json = jsonDecode(myDataString);
    if (response.statusCode == 200) {
      for (var element in json) {
        kshipments.add(KShipment.fromJson(element));
      }

      return kshipments.reversed.toList();
    } else {
      return kshipments;
    }
  }

  Future<List<Shipment>> getUnAssignedShipmentList() async {
    shipments = [];
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    var response = await HttpHelper.get(
      "${SHIPPMENTS_ENDPOINT}no_driver_shipments/",
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

  Future<int?> createShipmentv2(
    Shipmentv2 shipment,
  ) async {
    prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var request =
        http.MultipartRequest('POST', Uri.parse(SHIPPMENTSV2_ENDPOINT));
    request.headers.addAll({
      HttpHeaders.authorizationHeader: "JWT $token",
      HttpHeaders.contentTypeHeader: "multipart/form-data"
    });

    List<Map<String, dynamic>> sub_shipments = [];
    for (var element in shipment.subshipments!) {
      var item = element.toJson();
      sub_shipments.add(item);
    }
    var dataString = prefs.getString("userProfile");
    UserModel userModel = UserModel.fromJson(jsonDecode(dataString!));

    request.fields['merchant'] = userModel.merchant!.toString();
    request.fields['subshipments'] = jsonEncode(sub_shipments);
    // print(jsonEncode(sub_shipments));
    print(userModel.merchant!.toString());

    // print(jsonEncode(request.fields));
    var response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 201) {
      final respStr = await response.stream.bytesToString();
      var res = jsonDecode(respStr);
      return res['id'];
    } else {
      final respStr = await response.stream.bytesToString();
      print(respStr);
      return null;
    }
  }

  Future<int?> createShipment(Shipment shipment, int driver) async {
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
    print("asdad");

    var dataString = prefs.getString("userProfile");
    UserModel userModel = UserModel.fromJson(jsonDecode(dataString!));

    request.fields['merchant'] = userModel.merchant!.toString();
    request.fields['driver'] = driver.toString();
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
    print(jsonEncode(request.fields));
    var response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 201) {
      final respStr = await response.stream.bytesToString();
      var res = jsonDecode(respStr);
      return res['truck_type'];
    } else {
      final respStr = await response.stream.bytesToString();
      print(respStr);
      return null;
    }
  }

  Future<int?> createKShipment(KShipment shipment) async {
    prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var request =
        http.MultipartRequest('POST', Uri.parse(KSHIPPMENTS_ENDPOINT));
    request.headers.addAll({
      HttpHeaders.authorizationHeader: "JWT $token",
      HttpHeaders.contentTypeHeader: "multipart/form-data"
    });

    List<Map<String, dynamic>> shipment_items = [];
    for (var element in shipment.shipmentItems!) {
      var item = element.toJson();
      shipment_items.add(item);
    }

    List<Map<String, dynamic>> path_points = [];
    for (var element in shipment.pathPoints!) {
      var item = element.toJson();
      path_points.add(item);
    }

    var dataString = prefs.getString("userProfile");
    UserModel userModel = UserModel.fromJson(jsonDecode(dataString!));

    request.fields['merchant'] = userModel.merchant!.toString();
    request.fields['truck'] = shipment.truck!.id!.toString();
    request.fields['shipment_type'] = shipment.shipmentType!;
    request.fields['total_weight'] = shipment.totalWeight.toString();
    request.fields['truck_type'] = shipment.truckType!.id!.toString();
    request.fields['shipment_items'] = jsonEncode(shipment_items);
    request.fields['path_points'] = jsonEncode(path_points);
    print(jsonEncode(shipment_items));
    print(jsonEncode(path_points));
    var response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 201) {
      final respStr = await response.stream.bytesToString();
      var res = jsonDecode(respStr);
      return res['truck_type'];
    } else {
      final respStr = await response.stream.bytesToString();
      print(respStr);
      return null;
    }
  }

  Future<int?> createShipmentInstruction(Shipmentinstruction shipment) async {
    prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var request = http.MultipartRequest(
        'POST', Uri.parse(SHIPPMENTS_INSTRUCTION_ENDPOINT));
    request.headers.addAll({
      HttpHeaders.authorizationHeader: "JWT $token",
      HttpHeaders.contentTypeHeader: "multipart/form-data"
    });

    List<Map<String, dynamic>> commodity_items = [];
    for (var element in shipment.commodityItems!) {
      var item = element.toJson();
      commodity_items.add(item);
    }

    request.fields['shipment'] = shipment.shipment!.toString();
    request.fields['user_type'] = shipment.userType!;
    request.fields['charger_name'] = shipment.chargerName!;
    request.fields['charger_address'] = shipment.chargerAddress!;
    request.fields['charger_phone'] = shipment.chargerPhone!;
    request.fields['reciever_name'] = shipment.recieverName!;
    request.fields['reciever_address'] = shipment.recieverAddress!;
    request.fields['reciever_phone'] = shipment.recieverPhone!;
    request.fields['total_weight'] = shipment.totalWeight.toString();
    request.fields['net_weight'] = shipment.netWeight.toString();
    request.fields['truck_weight'] = shipment.truckWeight.toString();
    request.fields['final_weight'] = shipment.finalWeight.toString();
    request.fields['commodity_items'] = jsonEncode(commodity_items);
    var response = await request.send();
    print(jsonEncode(commodity_items));
    print(response.statusCode);
    if (response.statusCode == 201) {
      final respStr = await response.stream.bytesToString();
      return 1;
    } else {
      final respStr = await response.stream.bytesToString();
      return 0;
    }
  }

  Future<int?> createShipmentPayment(ShipmentPayment shipment) async {
    prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var request =
        http.MultipartRequest('POST', Uri.parse(SHIPPMENTS_PAYMENT_ENDPOINT));
    request.headers.addAll({
      HttpHeaders.authorizationHeader: "JWT $token",
      HttpHeaders.contentTypeHeader: "multipart/form-data"
    });
    request.fields['shipment'] = shipment.shipment!.toString();

    request.fields['amount'] = shipment.amount!.toString();
    request.fields['fees'] = shipment.fees!.toString();
    request.fields['extra_fees'] = shipment.extraFees!.toString();
    request.fields['payment_method'] = shipment.paymentMethod!.toString();

    var response = await request.send();
    if (response.statusCode == 201) {
      final respStr = await response.stream.bytesToString();
      return 1;
    } else {
      final respStr = await response.stream.bytesToString();
      return 0;
    }
  }

  Future<bool> assignShipment(int shipmentId, int driver) async {
    prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var response = await HttpHelper.patch(
      "$SHIPPMENTS_ENDPOINT$shipmentId/assign_shipment/",
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

  Future<bool> updateShipmentStatus(int id, String status) async {
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    var response = await HttpHelper.patch(
      "$SHIPPMENTS_ENDPOINT$id/",
      {"shipment_status": status},
      apiToken: jwt,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Shipment?> getShipment(int id) async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get('$SHIPPMENTS_ENDPOINT$id/', apiToken: jwt);

    print(rs.statusCode);
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      return Shipment.fromJson(result);
    }
    return null;
  }
}
