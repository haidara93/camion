class UserModel {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? phone;
  String? image;
  int? merchant;
  int? truckowner;
  int? truckuser;

  UserModel(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.phone,
      this.image,
      this.merchant,
      this.truckowner,
      this.truckuser});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'] ?? "";
    image = json['image'] ?? "";
    merchant = json['merchant'] ?? 0;
    truckowner = json['truckowner'] ?? 0;
    truckuser = json['truckuser'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['image'] = image;
    // if (merchant != null) {
    //   data['merchant'] = merchant!.toJson();
    // }
    // if (truckowner != null) {
    //   data['truckowner'] = truckowner!.toJson();
    // }
    // if (truckuser != null) {
    //   data['truckuser'] = truckuser!.toJson();
    // }
    return data;
  }
}

class Merchant {
  int? id;

  Merchant({this.id});

  Merchant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class TruckOwner {
  int? id;

  TruckOwner({this.id});

  TruckOwner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class Truckuser {
  int? id;
  bool? isTruckowner;

  Truckuser({this.id, this.isTruckowner});

  Truckuser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isTruckowner = json['is_truckowner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_truckowner'] = isTruckowner;
    return data;
  }
}

class Driver {
  int? id;
  User? user;
  int? truck;

  Driver({
    this.id,
    this.user,
    this.truck,
  });

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    truck = json['truck'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['truck'] = this.truck;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? phone;
  String? image;

  User(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.phone,
      this.image});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'] ?? "";
    image = json['image'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['image'] = this.image;
    return data;
  }
}
