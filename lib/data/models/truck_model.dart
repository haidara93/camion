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
        ? Truckuser.fromJson(json['truckuser'])
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (truckuser != null) {
      data['truckuser'] = truckuser!.toJson();
    }
    data['truck_type'] = truckType;
    data['location'] = location;
    data['location_lat'] = locationLat;
    data['location_lang'] = locationLang;
    data['height'] = height;
    data['width'] = width;
    data['long'] = long;
    data['number_of_axels'] = numberOfAxels;
    data['empty_weight'] = emptyWeight;
    data['rating'] = rating;
    data['price'] = price;
    data['fees'] = fees;
    data['extra_fees'] = extraFees;
    data['isOn'] = isOn;
    data['currentShipmentId'] = currentShipmentId;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserInfo {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? phone;
  String? image;
  int? merchant;
  int? truckowner;
  int? truckuser;

  UserInfo(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.phone,
      this.image,
      this.merchant,
      this.truckowner,
      this.truckuser});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'] ?? "";
    image = json['image'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['image'] = image;

    return data;
  }
}

class Truckuser {
  int? id;
  bool? isTruckowner;
  UserInfo? user;

  Truckuser({
    this.id,
    this.isTruckowner,
    this.user,
  });

  Truckuser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isTruckowner = json['is_truckowner'];
    user = json['user'] != null ? UserInfo.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_truckowner'] = isTruckowner;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['paper_type'] = paperType;
    data['image'] = image;
    data['start_date'] = startDate.toString();
    data['expire_date'] = expireDate.toString();
    data['truck'] = truck;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fix_type'] = fixType;
    data['amount'] = amount;
    data['dob'] = dob;
    data['is_fixes'] = isFixes;
    data['truck'] = truck;
    data['expense_type'] = expenseType;
    return data;
  }
}

class KTruck {
  int? id;
  KTuckUser? truckuser;
  int? owner;
  KTuckType? truckType;
  int? location;
  String? locationLat;
  int? height;
  int? width;
  int? long;
  int? numberOfAxels;
  int? truckNumber;
  int? emptyWeight;
  int? grossWeight;
  int? rating;
  int? traffic;
  int? price;
  int? fees;
  int? extraFees;
  bool? isOn;
  List<TruckImages>? images;

  KTruck({
    this.id,
    this.truckuser,
    this.owner,
    this.truckType,
    this.location,
    this.locationLat,
    this.height,
    this.width,
    this.long,
    this.numberOfAxels,
    this.truckNumber,
    this.emptyWeight,
    this.grossWeight,
    this.traffic,
    this.rating,
    this.price,
    this.fees,
    this.extraFees,
    this.isOn,
    this.images,
  });

  KTruck.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    truckuser = json['truckuser'] != null
        ? KTuckUser.fromJson(json['truckuser'])
        : null;
    owner = json['owner'];
    truckType = json['truck_type'] != null
        ? KTuckType.fromJson(json['truck_type'])
        : null;
    location = json['location'];
    locationLat = json['location_lat'];
    height = json['height'];
    width = json['width'];
    long = json['long'];
    numberOfAxels = json['number_of_axels'];
    truckNumber = json['truck_number'];
    emptyWeight = json['empty_weight'];
    grossWeight = json['gross_weight'];
    traffic = json['traffic'];
    rating = json['rating'];
    price = json['price'];
    fees = json['fees'];
    extraFees = json['extra_fees'];
    isOn = json['isOn'];
    if (json['images'] != null) {
      images = <TruckImages>[];
      json['images'].forEach((v) {
        images!.add(TruckImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;

    data['owner'] = owner!;
    data['truckuser'] = truckuser!;
    data['truck_type'] = truckType;
    data['location'] = location;
    data['location_lat'] = locationLat;
    data['height'] = height;
    data['width'] = width;
    data['long'] = long;
    data['number_of_axels'] = numberOfAxels;
    data['empty_weight'] = emptyWeight;
    data['rating'] = rating;
    data['price'] = price;
    data['fees'] = fees;
    data['extra_fees'] = extraFees;
    data['isOn'] = isOn;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class KTuckUser {
  int? id;
  Usertruck? usertruck;

  KTuckUser({this.id, this.usertruck});

  KTuckUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usertruck = json['user'] != null ? Usertruck.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (usertruck != null) {
      data['user'] = usertruck!.toJson();
    }
    return data;
  }
}

class Usertruck {
  int? id;
  String? firstName;
  String? lastName;
  String? id_number;
  String? phone;

  Usertruck(
      {this.id, this.firstName, this.lastName, this.id_number, this.phone});

  Usertruck.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    id_number = json['id_number'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['id_number'] = id_number;
    data['phone'] = phone;
    return data;
  }
}

class KTuckType {
  int? id;
  String? name;
  String? nameAr;
  String? image;

  KTuckType({this.id, this.name, this.nameAr});

  KTuckType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['name_ar'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['name_ar'] = nameAr;
    data['image'] = image;
    return data;
  }
}
