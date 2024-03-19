import 'package:camion/data/models/truck_model.dart';

class PriceRequestDetails {
  int? id;
  String? categoryName;
  String? requestStatus;
  KMerchant? merchant;
  PriceRequestDetails({
    this.id,
    this.merchant,
    this.categoryName,
    this.requestStatus,
  });

  PriceRequestDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchant =
        json['merchant'] != null ? KMerchant.fromJson(json['merchant']) : null;
    categoryName = json['category_name'];
    requestStatus = json['request_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (merchant != null) {
      data['merchant'] = merchant!.toJson();
    }
    data['category_name'] = categoryName;
    data['request_status'] = requestStatus;
    return data;
  }
}

class PriceRequest {
  int? id;
  String? categoryName;
  String? requestStatus;
  int? merchant;
  PriceRequest({
    this.id,
    this.merchant,
    this.categoryName,
    this.requestStatus,
  });

  PriceRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchant = json['merchant'];
    categoryName = json['category_name'];
    requestStatus = json['request_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['merchant'] = merchant!;
    data['category_name'] = categoryName;
    data['request_status'] = requestStatus;
    return data;
  }
}

class KMerchant {
  int? id;
  Usertruck? user;

  KMerchant({this.id, this.user});

  KMerchant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? Usertruck.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
