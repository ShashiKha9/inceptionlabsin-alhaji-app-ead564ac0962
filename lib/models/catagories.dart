class CategoriesList {
  List<Categories> result;

  CategoriesList({this.result});

  CategoriesList.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = new List<Categories>();
      json['result'].forEach((v) {
        result.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String sId;
  String name;
  bool isActive;
  String description;
  String imgUrl;
  String createdBy;
  String updatedBy;
  String categoryCode;
  String createdDate;
  String modifiedDate;

  Categories(
      {this.sId,
      this.name,
      this.isActive,
      this.description,
      this.imgUrl,
      this.createdBy,
      this.updatedBy,
      this.categoryCode,
      this.createdDate,
      this.modifiedDate});

  Categories.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    isActive = json['isActive'];
    description = json['description'];
    imgUrl = json['imgUrl'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    categoryCode = json['categoryCode'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['description'] = this.description;
    data['imgUrl'] = this.imgUrl;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['categoryCode'] = this.categoryCode;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    return data;
  }
}
