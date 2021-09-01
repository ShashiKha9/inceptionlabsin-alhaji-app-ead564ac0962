class PromoCodes {
  List<PromoCode> promoCodes;

  PromoCodes({this.promoCodes});

  PromoCodes.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      promoCodes = new List<PromoCode>();
      json['result'].forEach((v) {
        if (v['isUsed'] != true) promoCodes.add(new PromoCode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.promoCodes != null) {
      data['result'] = this.promoCodes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PromoCode {
  String sId;
  String code;
  String customerCode;
  bool isActive;
  bool isUsed;
  String createdDate;
  String modifiedDate;
  String createdBy;
  String updatedBy;
  PromoCodeDetails promoCodeDetails;
  String type;

  PromoCode(
      {this.sId,
      this.code,
      this.customerCode,
      this.isActive,
      this.isUsed,
      this.createdDate,
      this.modifiedDate,
      this.createdBy,
      this.updatedBy,
      this.promoCodeDetails,
      this.type});

  PromoCode.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    code = json['code'];
    customerCode = json['customerCode'];
    isActive = json['isActive'];
    isUsed = json['isUsed'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    promoCodeDetails =
        json['promoCodeDetails'] != null ? new PromoCodeDetails.fromJson(json['promoCodeDetails']) : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['code'] = this.code;
    data['customerCode'] = this.customerCode;
    data['isActive'] = this.isActive;
    data['isUsed'] = this.isUsed;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    if (this.promoCodeDetails != null) {
      data['promoCodeDetails'] = this.promoCodeDetails.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class PromoCodeDetails {
  String sId;
  String remarks;
  String code;
  num orderCount;
  num percentage;
  bool isActive;
  String createdDate;
  String modifiedDate;
  String createdBy;
  String updatedBy;

  PromoCodeDetails(
      {this.sId,
      this.remarks,
      this.code,
      this.orderCount,
      this.percentage,
      this.isActive,
      this.createdDate,
      this.modifiedDate,
      this.createdBy,
      this.updatedBy});

  PromoCodeDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    remarks = json['remarks'];
    code = json['code'];
    orderCount = json['orderCount'];
    percentage = json['percentage'];
    isActive = json['isActive'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['remarks'] = this.remarks;
    data['code'] = this.code;
    data['orderCount'] = this.orderCount;
    data['percentage'] = this.percentage;
    data['isActive'] = this.isActive;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    return data;
  }
}
