import 'dart:convert';

import 'package:camion/data/models/check_point_model.dart';
import 'package:camion/helpers/http_helper.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckPointRepository {
  late SharedPreferences prefs;
  List<Permission> permissions = [];
  List<PassCharges> charges = [];
  List<CheckPathPoint> pathpoints = [];
  List<ChargeType> chargeTypes = [];

  Future<List<ChargeType>> getChargeTypes() async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get(CHARGETYPE_ENDPOINT, apiToken: jwt);
    chargeTypes = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      print(myDataString);
      for (var element in result) {
        chargeTypes.add(ChargeType.fromJson(element));
      }
    }
    return chargeTypes;
  }

  Future<List<CheckPathPoint>> getCheckPathPoints() async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get(PATHPOINTS_ENDPOINT, apiToken: jwt);
    pathpoints = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      for (var element in result) {
        pathpoints.add(CheckPathPoint.fromJson(element));
      }
    }
    return pathpoints;
  }

  Future<bool> createPermission(Permission permission) async {
    prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    Response response = await HttpHelper.post(
        PERMISSIONS_ENDPOINT,
        {
          "passdate": permission.passdate!.toIso8601String(),
          "pass_duration": permission.passDuration,
          "check_point": permission.checkPoint,
          "shipment": permission.shipment
        },
        apiToken: token);
    print(response.body);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Permission>> getPermissions() async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get(PERMISSIONS_ENDPOINT, apiToken: jwt);
    permissions = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      for (var element in result) {
        permissions.add(Permission.fromJson(element));
      }
    }
    return permissions;
  }

  Future<PermissionDetail?> getPermissionDetail(int id) async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get("$PERMISSIONS_ENDPOINT$id/get_details/",
        apiToken: jwt);
    permissions = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      return PermissionDetail.fromJson(result);
    }
    return null;
  }

  Future<bool> createCharges(PassCharges charge) async {
    prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    Response response = await HttpHelper.post(
        CHARGES_ENDPOINT,
        {
          "shipment": charge.shipment,
          "note": charge.note,
          "charges_type": charge.charges_type,
          "check_point": charge.checkPoint
        },
        apiToken: token);
    print(response.body);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<PassCharges>> getPassCharges() async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get(CHARGES_ENDPOINT, apiToken: jwt);
    charges = [];
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      for (var element in result) {
        charges.add(PassCharges.fromJson(element));
      }
    }
    return charges;
  }

  Future<PassChargesDetail?> getPassChargesDetail(int id) async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get("$CHARGES_ENDPOINT$id/get_details/",
        apiToken: jwt);
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      return PassChargesDetail.fromJson(result);
    }
    return null;
  }
}
