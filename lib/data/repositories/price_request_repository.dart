import 'dart:convert';

import 'package:camion/data/models/price_request_model.dart';
import 'package:camion/data/models/user_model.dart';
import 'package:camion/helpers/http_helper.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PriceRequestRepository {
  List<PriceRequestDetails> pricerequests = [];
  late SharedPreferences prefs;

  Future<List<PriceRequestDetails>> getPriceRequests() async {
    prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("token");

    var rs = await HttpHelper.get(PRICEREQUEST_ENDPOINT, apiToken: jwt);
    pricerequests = [];
    print(rs.statusCode);
    if (rs.statusCode == 200) {
      var myDataString = utf8.decode(rs.bodyBytes);

      var result = jsonDecode(myDataString);
      for (var element in result) {
        pricerequests.add(PriceRequestDetails.fromJson(element));
      }
    }
    return pricerequests;
  }

  Future<bool> createPriceRequest(String categoryName) async {
    prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var dataString = prefs.getString("userProfile");
    UserModel userModel = UserModel.fromJson(jsonDecode(dataString!));

    Response response = await HttpHelper.post(
        PRICEREQUEST_ENDPOINT,
        {
          "merchant": userModel.merchant,
          "category_name": categoryName,
          "request_status": "P"
        },
        apiToken: token);
    print(response.body);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
