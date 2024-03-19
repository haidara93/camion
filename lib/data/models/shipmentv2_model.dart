import 'package:camion/data/models/instruction_model.dart';

class Shipmentv2 {
  int? id;
  int? merchant;
  String? shipmentStatus;
  List<SubShipment>? subshipments;

  Shipmentv2({
    this.id,
    this.merchant,
    this.shipmentStatus,
    this.subshipments,
  });

  Shipmentv2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchant = json['merchant'];
    shipmentStatus = json['shipment_status'];
    if (json['subshipments'] != null) {
      subshipments = <SubShipment>[];
      json['subshipments'].forEach((v) {
        subshipments!.add(SubShipment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['merchant'] = merchant;
    data['shipment_status'] = shipmentStatus;
    if (subshipments != null) {
      data['subshipments'] = subshipments!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class SubShipment {
  int? id;
  String? shipmentStatus;
  Shipmentinstruction? shipmentinstruction;
  ShipmentPayment? shipmentpayment;
  int? totalWeight;
  DateTime? pickupDate;
  DateTime? deliveryDate;
  List<ShipmentItems>? shipmentItems;
  List<PathPoint>? pathpoints;
  List<SelectedTruckType>? truckTypes;

  SubShipment({
    this.id,
    this.shipmentStatus,
    this.shipmentinstruction,
    this.shipmentpayment,
    this.totalWeight,
    this.pickupDate,
    this.deliveryDate,
    this.shipmentItems,
    this.pathpoints,
    this.truckTypes,
  });

  SubShipment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shipmentStatus = json['shipment_status'];
    shipmentinstruction = json['shipmentinstruction'] != null
        ? Shipmentinstruction.fromJson(json['shipmentinstruction'])
        : null;
    shipmentpayment = json['shipmentpayment'] != null
        ? ShipmentPayment.fromJson(json['shipmentpayment'])
        : null;
    totalWeight = json['total_weight'];
    pickupDate = DateTime.parse(json['pickup_date']);
    deliveryDate = DateTime.parse(json['delivery_date']);
    if (json['shipment_items'] != null) {
      shipmentItems = <ShipmentItems>[];
      json['shipment_items'].forEach((v) {
        shipmentItems!.add(ShipmentItems.fromJson(v));
      });
    }
    if (json['selected_truck_types'] != null) {
      truckTypes = <SelectedTruckType>[];
      json['selected_truck_types'].forEach((v) {
        truckTypes!.add(SelectedTruckType.fromJson(v));
      });
    }
    if (json['path_points'] != null) {
      pathpoints = <PathPoint>[];
      json['path_points'].forEach((v) {
        pathpoints!.add(PathPoint.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['id'] = id;
    data['shipment_status'] = shipmentStatus;
    data['total_weight'] = totalWeight;
    data['pickup_date'] = pickupDate?.toIso8601String();
    data['delivery_date'] = deliveryDate?.toIso8601String();
    data['shipmentinstruction'] = this.shipmentinstruction;
    data['shipmentpayment'] = this.shipmentpayment;
    // shipmentinstruction = json['shipmentinstruction'] != null
    //     ? Shipmentinstruction.fromJson(json['shipmentinstruction'])
    //     : null;
    // shipmentpayment = json['shipmentpayment'] != null
    //     ? ShipmentPayment.fromJson(json['shipmentpayment'])
    //     : null;
    if (shipmentItems != null) {
      data['shipment_items'] = shipmentItems!.map((v) => v.toJson()).toList();
    }

    if (truckTypes != null) {
      data['selected_truck_types'] =
          truckTypes!.map((v) => v.toJson()).toList();
    }

    if (pathpoints != null) {
      data['path_points'] = pathpoints!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class ShipmentItems {
  int? id;
  int? commodityCategory;
  int? commodityWeight;

  ShipmentItems({
    this.id,
    this.commodityCategory,
    this.commodityWeight,
  });

  ShipmentItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commodityCategory = json['commodity_category'];
    commodityWeight = json['commodity_weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commodity_category'] = commodityCategory;
    data['commodity_weight'] = commodityWeight;

    return data;
  }
}

class SelectedTruckType {
  int? id;
  int? truckType;
  bool? is_assigned;

  SelectedTruckType({
    this.id,
    this.truckType,
    this.is_assigned,
  });

  SelectedTruckType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    truckType = json['truck_type'];
    is_assigned = json['is_assigned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['truck_type'] = truckType;
    data['is_assigned'] = is_assigned;

    return data;
  }
}

class PathPoint {
  int? id;
  String? name;
  int? city;
  int? number;
  String? pointType;
  String? location;

  PathPoint({
    this.id,
    this.name,
    this.city,
    this.number,
    this.pointType,
    this.location,
  });

  PathPoint.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    city = json['city'];
    number = json['number'];
    pointType = json['point_type'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['city'] = city;
    data['number'] = number;
    data['point_type'] = pointType;
    data['location'] = location;

    return data;
  }
}
