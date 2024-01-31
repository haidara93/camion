class Truck {
  int? id;
  Truckuser? truckuser;
  int? truckType;
  String? location;
  double? locationLat;
  double? locationLang;
  int? height;
  int? width;
  int? long;
  int? numberOfAxels;
  int? emptyWeight;
  int? rating;
  int? price;
  int? fees;
  int? extraFees;
  bool? isOn;
  int? currentShipmentId;
  List<TruckImages>? images;

  Truck(
      {this.id,
      this.truckuser,
      this.truckType,
      this.location,
      this.locationLat,
      this.locationLang,
      this.height,
      this.width,
      this.long,
      this.numberOfAxels,
      this.emptyWeight,
      this.rating,
      this.price,
      this.fees,
      this.extraFees,
      this.isOn,
      this.currentShipmentId,
      this.images});

  Truck.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    truckuser = json['truckuser'] != null
        ? new Truckuser.fromJson(json['truckuser'])
        : null;
    truckType = json['truck_type'];
    location = json['location'];
    locationLat = json['location_lat'];
    locationLang = json['location_lang'];
    height = json['height'];
    width = json['width'];
    long = json['long'];
    numberOfAxels = json['number_of_axels'];
    emptyWeight = json['empty_weight'];
    rating = json['rating'];
    price = json['price'];
    fees = json['fees'];
    extraFees = json['extra_fees'];
    isOn = json['isOn'];
    currentShipmentId = json['currentShipmentId'] ?? 0;
    if (json['images'] != null) {
      images = <TruckImages>[];
      json['images'].forEach((v) {
        images!.add(TruckImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    if (this.truckuser != null) {
      data['truckuser'] = this.truckuser!.toJson();
    }
    data['truck_type'] = this.truckType;
    data['location'] = this.location;
    data['location_lat'] = this.locationLat;
    data['location_lang'] = this.locationLang;
    data['height'] = this.height;
    data['width'] = this.width;
    data['long'] = this.long;
    data['number_of_axels'] = this.numberOfAxels;
    data['empty_weight'] = this.emptyWeight;
    data['rating'] = this.rating;
    data['price'] = this.price;
    data['fees'] = this.fees;
    data['extra_fees'] = this.extraFees;
    data['isOn'] = this.isOn;
    data['currentShipmentId'] = this.currentShipmentId;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Truckuser {
  int? id;
  bool? isTruckowner;
  int? user;

  Truckuser({
    this.id,
    this.isTruckowner,
    this.user,
  });

  Truckuser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isTruckowner = json['is_truckowner'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_truckowner'] = this.isTruckowner;
    return data;
  }
}

class TruckImages {
  int? id;
  String? image;

  TruckImages({this.id, this.image});

  TruckImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}

class TruckPaper {
  int? id;
  String? paperType;
  String? image;
  DateTime? startDate;
  DateTime? expireDate;
  int? truck;

  TruckPaper(
      {this.id,
      this.paperType,
      this.image,
      this.startDate,
      this.expireDate,
      this.truck});

  TruckPaper.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paperType = json['paper_type'];
    image = json['image'];
    startDate = DateTime.parse(json['start_date']);
    expireDate = DateTime.parse(json['expire_date']);
    truck = json['truck'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['paper_type'] = this.paperType;
    data['image'] = this.image;
    data['start_date'] = this.startDate.toString();
    data['expire_date'] = this.expireDate.toString();
    data['truck'] = this.truck;
    return data;
  }
}

class TruckExpense {
  int? id;
  String? fixType;
  int? amount;
  DateTime? dob;
  bool? isFixes;
  int? truck;
  int? expenseType;

  TruckExpense(
      {this.id,
      this.fixType,
      this.amount,
      this.dob,
      this.isFixes,
      this.truck,
      this.expenseType});

  TruckExpense.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fixType = json['fix_type'];
    amount = json['amount'];
    dob = DateTime.parse(json['dob']);
    isFixes = json['is_fixes'];
    truck = json['truck'];
    expenseType = json['expense_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fix_type'] = this.fixType;
    data['amount'] = this.amount;
    data['dob'] = this.dob;
    data['is_fixes'] = this.isFixes;
    data['truck'] = this.truck;
    data['expense_type'] = this.expenseType;
    return data;
  }
}
