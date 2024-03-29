class TruckType {
  int? id;
  String? name;
  String? nameAr;
  String? image;

  TruckType({
    this.id,
    this.name,
    this.nameAr,
    this.image,
  });

  TruckType.fromJson(Map<String, dynamic> json) {
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
