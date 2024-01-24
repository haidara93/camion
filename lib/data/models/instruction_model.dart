import 'package:camion/data/models/truck_type_model.dart';

class ShipmentInstruction {
  int? id;
  int? shipment;
  String? userType;
  String? chargerName;
  String? chargerAddress;
  String? chargerPhone;
  String? recieverName;
  String? recieverAddress;
  String? recieverPhone;
  int? totalWeight;
  int? netWeight;
  int? truckWeight;
  int? finalWeight;
  List<CommodityItems>? commodityItems;

  ShipmentInstruction(
      {this.id,
      this.shipment,
      this.userType,
      this.chargerName,
      this.chargerAddress,
      this.chargerPhone,
      this.recieverName,
      this.recieverAddress,
      this.recieverPhone,
      this.totalWeight,
      this.netWeight,
      this.truckWeight,
      this.finalWeight,
      this.commodityItems});

  ShipmentInstruction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shipment = json['shipment'];
    userType = json['user_type'];
    chargerName = json['charger_name'];
    chargerAddress = json['charger_address'];
    recieverPhone = json['charger_phone'];
    recieverName = json['reciever_name'];
    recieverAddress = json['reciever_address'];
    recieverPhone = json['reciever_phone'];
    totalWeight = json['total_weight'];
    netWeight = json['net_weight'];
    truckWeight = json['truck_weight'];
    finalWeight = json['final_weight'];
    if (json['shipment_items'] != null) {
      commodityItems = <CommodityItems>[];
      json['shipment_items'].forEach((v) {
        commodityItems!.add(CommodityItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['total_weight'] = totalWeight;

    if (commodityItems != null) {
      data['shipment_items'] = commodityItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommodityItems {
  int? id;
  String? commodityName;
  int? commodityWeight;
  int? commodityQuantity;
  int? packageType;

  CommodityItems({
    this.id,
    this.commodityName,
    this.commodityWeight,
    this.commodityQuantity,
    this.packageType,
  });

  CommodityItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commodityName = json['commodity_name'];
    commodityWeight = json['commodity_weight'];
    commodityQuantity = json['commodity_quantity'];
    packageType = json['package_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['commodity_name'] = commodityName;
    data['commodity_weight'] = commodityWeight;
    data['commodity_quantity'] = commodityQuantity;
    data['package_type'] = packageType;
    return data;
  }
}

class ShipmentPayment {
  int? id;
  int? amount;
  int? fees;
  int? extraFees;

  ShipmentPayment({
    this.id,
    this.amount,
    this.fees,
    this.extraFees,
  });

  ShipmentPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    fees = json['fees'];
    extraFees = json['extra_fees'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['amount'] = amount;
    data['fees'] = fees;
    data['extra_fees'] = extraFees;
    return data;
  }
}
