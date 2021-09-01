class RestaurantBranches {
  num totalPages;
  int totalElements;
  int numberOfElements;
  num pageNumber;
  num size;
  List<RestaurantBranch> restaurantBranches;

  RestaurantBranches(
      {this.totalPages,
      this.totalElements,
      this.numberOfElements,
      this.pageNumber,
      this.size,
      this.restaurantBranches});

  RestaurantBranches.fromJson(Map<String, dynamic> json) {
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    numberOfElements = json['numberOfElements'];
    pageNumber = json['pageNumber'];
    size = json['size'];
    if (json['result'] != null) {
      restaurantBranches = new List<RestaurantBranch>();
      json['result'].forEach((v) {
        restaurantBranches.add(new RestaurantBranch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    data['numberOfElements'] = this.numberOfElements;
    data['pageNumber'] = this.pageNumber;
    data['size'] = this.size;
    if (this.restaurantBranches != null) {
      data['result'] = this.restaurantBranches.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RestaurantBranch {
  String sId;
  String name;
  String address;
  String pincode;
  bool isActive;
  String createdBy;
  String updatedBy;
  String branchCode;
  String createdDate;
  String modifiedDate;

  RestaurantBranch(
      {this.sId,
      this.name,
      this.address,
      this.pincode,
      this.isActive,
      this.createdBy,
      this.updatedBy,
      this.branchCode,
      this.createdDate,
      this.modifiedDate});

  RestaurantBranch.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    address = json['address'];
    pincode = json['pincode'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    branchCode = json['branchCode'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['updatedBy'] = this.updatedBy;
    data['branchCode'] = this.branchCode;
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    return data;
  }
}
