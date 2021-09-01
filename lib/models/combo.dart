import 'products.dart';

class CombosList {
  List<Combo> combosList;

  CombosList({this.combosList});

  CombosList.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      combosList = new List<Combo>();
      json['result'].forEach((v) {
        combosList.add(new Combo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.combosList != null) {
      data['result'] = this.combosList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Combo {
  String sId;
  String name;
  List productCodes;
  bool isActive;
  String createdBy;
  String comboCode;
  String createdDate;
  String modifiedDate;
  String updatedBy;
  String fullDescription;
  String shortDescription;
  List<Product> items;
  bool isAvailable;
  List images;
  num price;
  bool isTaxInclusive;

  Combo(
      {this.sId,
      this.name,
      this.productCodes,
      this.isActive,
      this.createdBy,
      this.comboCode,
      this.createdDate,
      this.modifiedDate,
      this.updatedBy,
      this.fullDescription,
      this.shortDescription,
      this.items,
      this.isAvailable,
      this.images,
      this.price,
      this.isTaxInclusive});

  Combo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    name = json['name'] ?? '';
    productCodes = json['productCodes'] ?? [];
    isActive = json['isActive'] ?? false;
    createdBy = json['createdBy'];
    comboCode = json['comboCode'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    updatedBy = json['updatedBy'];
    fullDescription = json['fullDescription'] ?? '';
    shortDescription = json['shortDescription'] ?? '';
    if (json['items'] != null) {
      items = new List<Product>();
      json['items'].forEach((v) {
        items.add(new Product.fromJson(v));
      });
    }
    isAvailable = json['isAvailable'] ?? false;
    images = json['images'] ?? [];
    price = json['price'] ?? 0;
    isTaxInclusive = json['isTaxInclusive'] ?? false;
  }

  Map<String, dynamic> toJson({num totalQuantity}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['productCodes'] = this.productCodes;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['comboCode'] = this.comboCode;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    data['updatedBy'] = this.updatedBy;
    data['fullDescription'] = this.fullDescription;
    data['shortDescription'] = this.shortDescription;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson(totalQuantity: totalQuantity)).toList();
    }
    data["totalQuantity"] = totalQuantity;
    data['isAvailable'] = this.isAvailable;
    data['images'] = this.images;
    data['price'] = this.price;
    data['isTaxInclusive'] = this.isTaxInclusive;
    return data;
  }
}
