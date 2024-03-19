class CommodityCategory {
  int? id;
  String? name;
  String? nameAr;
  String? image;

  CommodityCategory({
    this.id,
    this.name,
    this.nameAr,
    this.image,
  });

  CommodityCategory.fromJson(Map<String, dynamic> json) {
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

class KCommodityCategory {
  int? id;
  String? name;
  String? nameAr;
  int? price;
  int? weight;
  String? image;
  String? unit_type;
  int? category;

  KCommodityCategory({
    this.id,
    this.name,
    this.nameAr,
    this.price,
    this.weight,
    this.image,
    this.unit_type,
    this.category,
  });

  KCommodityCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['name_ar'];
    price = json['price'];
    weight = json['weight'];
    image = json['image'];
    unit_type = json['unit_type'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['name_ar'] = nameAr;
    data['price'] = price;
    data['weight'] = weight;
    data['image'] = image;
    data['unit_type'] = unit_type;
    data['category'] = category;
    return data;
  }
}

class KCategory {
  int? id;
  List<KCommodityCategory>? subCategories;
  String? name;
  String? nameAr;
  String? image;

  KCategory({this.id, this.subCategories, this.name, this.nameAr, this.image});

  KCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['sub_categories'] != null) {
      subCategories = <KCommodityCategory>[];
      json['sub_categories'].forEach((v) {
        subCategories!.add(KCommodityCategory.fromJson(v));
      });
    }
    name = json['name'];
    nameAr = json['name_ar'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    if (subCategories != null) {
      data['sub_categories'] = subCategories!.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    data['name_ar'] = nameAr;
    data['image'] = image;
    return data;
  }
}

class SimpleCategory {
  int? id;
  String? name;
  String? nameAr;
  String? image;

  SimpleCategory({this.id, this.name, this.nameAr, this.image});

  SimpleCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['name_ar'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['name_ar'] = nameAr;
    data['image'] = image;
    return data;
  }
}
