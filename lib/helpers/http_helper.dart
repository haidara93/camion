// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const DOMAIN = 'https://matjari.app/';

const LOGIN_ENDPOINT = '${DOMAIN}camionauth/jwt/create/';
const USERS_ENDPOINT = '${DOMAIN}auth/users/';
const PROFILE_ENDPOINT = '${DOMAIN}auth/users/me';
const POSTS_ENDPOINT = '${DOMAIN}camion/posts/';
const SAVED_POSTS_ENDPOINT = '${DOMAIN}camion/savedposts/';
const GROUPS_ENDPOINT = '${DOMAIN}camion/groups/';
const STATE_CUSTOMES_ENDPOINT = '${DOMAIN}camion/statecustomes/';
const TRUCK_TYPES_ENDPOINT = '${DOMAIN}camion/trucktypes/';
const COMMODITY_CATEGORIES_ENDPOINT = '${DOMAIN}camion/commoditycategories/';
const KCOMMODITY_CATEGORIES_ENDPOINT = '${DOMAIN}camion/kcommoditycategories/';
const K_CATEGORIES_ENDPOINT = '${DOMAIN}camion/kcategories/';
const PERMISSIONS_ENDPOINT = '${DOMAIN}camion/permessions/';
const PATHPOINTS_ENDPOINT = '${DOMAIN}camion/checkpathpoints/';
const CHARGES_ENDPOINT = '${DOMAIN}camion/passcharges/';
const CHARGETYPE_ENDPOINT = '${DOMAIN}camion/chargestypes/';
const TRUCKS_ENDPOINT = '${DOMAIN}camion/trucks/';
const KTRUCKS_ENDPOINT = '${DOMAIN}camion/ktrucks/';
const TRUCK_PAPERS_ENDPOINT = '${DOMAIN}camion/truckpapers/';
const TRUCK_EXPENSES_ENDPOINT = '${DOMAIN}camion/truckfixes/';
const PACKAGE_TYPES_ENDPOINT = '${DOMAIN}camion/packagestypes/';
const SHIPPMENTS_ENDPOINT = '${DOMAIN}camion/shippments/';
const PRICEREQUEST_ENDPOINT = '${DOMAIN}camion/pricerequests/';
const KSHIPPMENTS_ENDPOINT = '${DOMAIN}camion/shipments/';
const SHIPPMENTSV2_ENDPOINT = '${DOMAIN}camion/shipmentV2s/';
const SHIPPMENTS_PAYMENT_ENDPOINT = '${DOMAIN}camion/shipmentpayment/';
const SHIPPMENTS_INSTRUCTION_ENDPOINT =
    '${DOMAIN}camion/shippmentinstructions/';
const NOTIFICATIONS_ENDPOINT = '${DOMAIN}camion/notifecations/';
const KNOTIFICATIONS_ENDPOINT = '${DOMAIN}camion/knotifecations/';

class HttpHelper {
  static Future<http.Response> post(String url, Map<String, dynamic> body,
      {String? apiToken}) async {
    return (await http.post(Uri.parse(url), body: jsonEncode(body), headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'JWT $apiToken'
    }));
  }

  static Future<http.Response> put(String url, Map<String, dynamic> body,
      {String? apiToken}) async {
    return (await http.put(Uri.parse(url), body: jsonEncode(body), headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'JWT $apiToken'
    }));
  }

  static Future<http.Response> patch(String url, Map<String, dynamic> body,
      {String? apiToken}) async {
    return (await http.patch(Uri.parse(url), body: jsonEncode(body), headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'JWT $apiToken'
    }));
  }

  static Future<http.Response> get(String url, {String? apiToken}) async {
    return await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'JWT $apiToken'});
  }

  static Future<http.Response> delete(String url, {String? apiToken}) async {
    return await http.delete(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'JWT $apiToken'});
  }

  static Future<http.Response> getAuth(String url, {String? apiToken}) async {
    return await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'JWT $apiToken'});
  }
}
