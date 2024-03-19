import 'package:camion/data/models/kshipment_model.dart';

class ChargeType {
  int? id;
  String? name;

  ChargeType({
    this.id,
    this.name,
  });

  ChargeType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class PassCharges {
  int? id;
  String? note;
  List<int>? charges_type;
  int? check_point;
  int? checkPoint;
  int? shipment;

  PassCharges(
      {this.id,
      this.note,
      this.check_point,
      this.charges_type,
      this.checkPoint,
      this.shipment});

  PassCharges.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    check_point = json['check_point'];
    charges_type = json['charges_type'].cast<int>();
    note = json['note'];
    checkPoint = json['check_point'];
    shipment = json['shipment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['check_point'] = check_point;
    data['charges_type'] = charges_type;
    data['note'] = note;
    data['check_point'] = checkPoint;
    data['shipment'] = shipment;
    return data;
  }
}

class PassChargesDetail {
  int? id;
  String? note;
  int? charges_type;
  CheckPathPoint? check_point;
  ManagmentShipment? shipment;

  PassChargesDetail(
      {this.id, this.note, this.check_point, this.charges_type, this.shipment});

  PassChargesDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    check_point = json['check_point'] != null
        ? CheckPathPoint.fromJson(json['check_point'])
        : null;
    charges_type = json['charges_type'];
    note = json['note'];
    shipment = json['shipment'] != null
        ? ManagmentShipment.fromJson(json['shipment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['charges_type'] = charges_type;
    data['note'] = note;
    if (shipment != null) {
      data['shipment'] = shipment!.toJson();
    }
    if (check_point != null) {
      data['check_point'] = check_point!.toJson();
    }
    return data;
  }
}

class Permission {
  int? id;
  DateTime? passdate;
  int? passDuration;
  int? checkPoint;
  int? shipment;

  Permission(
      {this.id,
      this.passdate,
      this.passDuration,
      this.checkPoint,
      this.shipment});

  Permission.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    passdate =
        json['passdate'] != null ? DateTime.parse(json['passdate']) : null;
    passDuration = json['pass_duration'];
    checkPoint = json['check_point'];
    shipment = json['shipment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['passdate'] = passdate;
    data['pass_duration'] = passDuration;
    data['check_point'] = checkPoint;
    data['shipment'] = shipment;
    return data;
  }
}

class PermissionDetail {
  int? id;
  String? passdate;
  int? passDuration;
  int? checkPoint;
  ManagmentShipment? shipment;

  PermissionDetail(
      {this.id,
      this.passdate,
      this.passDuration,
      this.checkPoint,
      this.shipment});

  PermissionDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    passdate = json['passdate'];
    passDuration = json['pass_duration'];
    checkPoint = json['check_point'];
    shipment = json['shipment'] != null
        ? ManagmentShipment.fromJson(json['shipment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['passdate'] = passdate;
    data['pass_duration'] = passDuration;
    data['check_point'] = checkPoint;
    if (shipment != null) {
      data['shipment'] = shipment!.toJson();
    }
    return data;
  }
}

class CheckPathPoint {
  int? id;
  String? name;
  String? pointType;
  int? number;
  String? location;
  int? city;

  CheckPathPoint(
      {this.id,
      this.name,
      this.pointType,
      this.number,
      this.location,
      this.city});
  CheckPathPoint.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pointType = json['point_type'];
    number = json['number'];
    location = json['location'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['point_type'] = pointType;
    data['number'] = number;
    data['location'] = location;
    data['city'] = city;
    return data;
  }
}
