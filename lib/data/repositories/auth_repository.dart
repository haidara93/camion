import 'dart:convert';
import 'dart:io';

import 'package:camion/data/models/user_model.dart';
import 'package:camion/helpers/http_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  late SharedPreferences prefs;

  Future<dynamic> login(
      {required String username, required String password}) async {
    try {
      String? firebaseToken = "";
      FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      firebaseToken = await messaging.getToken();
      // if (Platform.isIOS) {
      //   firebaseToken = await messaging.getAPNSToken();
      // } else if (Platform.isAndroid) {
      // }

      // firebaseToken = await messaging.getToken();
      // print(firebaseToken);
      Response response = await HttpHelper.post(
          LOGIN_ENDPOINT, {"username": username, "password": password});
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = response.statusCode;
      var jsonObject = jsonDecode(response.body);
      print(response.statusCode);

      if (response.statusCode == 401 || response.statusCode == 400) {
        data["details"] = jsonObject["detail"];
      } else {
        presisteToken(jsonObject);
        print(jsonObject["access"]);
        Response userresponse = await HttpHelper.get(PROFILE_ENDPOINT,
            apiToken: jsonObject["access"]);
        if (userresponse.statusCode == 200) {
          var prefs = await SharedPreferences.getInstance();
          var userType = prefs.getString("userType") ?? "";
          if (userType.isNotEmpty) {
            var myDataString = utf8.decode(userresponse.bodyBytes);
            print(myDataString);
            prefs.setString("userProfile", myDataString);
            var result = jsonDecode(myDataString);
            var userProfile = UserModel.fromJson(result);
            if (userProfile.merchant != null) {
              prefs.setInt("merchant", userProfile.merchant!);
            }
            if (userProfile.truckowner != null) {
              prefs.setInt("truckowner", userProfile.truckowner!);
            }
            if (userProfile.truckuser != null) {
              prefs.setInt("truckuser", userProfile.truckuser!);
            }
          }
        }
        data["token"] = jsonObject["access"];
      }
      return data;
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<String> get jwtOrEmpty async {
    var prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");
    if (jwt == null) return "";
    return jwt;
  }

  Future<bool> isAuthenticated() async {
    var token = await jwtOrEmpty;

    if (token != "") {
      var str = token;
      var jwt = str.split(".");

      if (jwt.length != 3) {
        return false;
      } else {
        var payload =
            json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
        if (DateTime.fromMillisecondsSinceEpoch(
                (payload["exp"].toInt()) * 100000)
            .isAfter(DateTime.now())) {
          return true;
        } else {
          return false;
        }
      }
    } else {
      return false;
    }
  }

  Future<void> presisteToken(dynamic data) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("token", data["access"]);
    prefs.setString("refresh", data["refresh"]);
  }

  Future<void> deleteToken() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.remove("refresh");
    prefs.remove("userType");
    // prefs.clear();
  }
}
