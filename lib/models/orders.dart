import 'addOns.dart';

class Orders {
  List<OrdersData> result;

  Orders({this.result});

  Orders.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = new List<OrdersData>();
      json['result'].forEach((v) {
        result.add(new OrdersData.fromJson(v));
      });
    } else
      result = <OrdersData>[];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrdersData {
  String sId;
  String orderType;
  String paymentType;
  String createdBy;
  Branch branch;
  num itemTotal;
  num totalAmount;
  CustomerDetails customerDetails;
  List<Items> items;
  String orderCode;
  String status;
  List<StatusList> statusList;
  String createdDate;
  String modifiedDate;
  String updatedBy;
  PromoDetails promoDetails;
  num discount;

  OrdersData(
      {this.sId,
      this.orderType,
      this.paymentType,
      this.createdBy,
      this.branch,
      this.itemTotal,
      this.totalAmount,
      this.customerDetails,
      this.items,
      this.orderCode,
      this.status,
      this.statusList,
      this.createdDate,
      this.modifiedDate,
      this.updatedBy,
      this.promoDetails,
      this.discount});

  OrdersData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    orderType = json['orderType'];
    paymentType = json['paymentType'];
    createdBy = json['createdBy'];
    branch = json['branch'] != null ? new Branch.fromJson(json['branch']) : null;
    itemTotal = json['itemTotal'];
    totalAmount = json['totalAmount'];
    customerDetails = json['customerDetails'] != null ? new CustomerDetails.fromJson(json['customerDetails']) : null;
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    orderCode = json['orderCode'];
    status = json['status'];
    if (json['statusList'] != null) {
      statusList = new List<StatusList>();
      json['statusList'].forEach((v) {
        statusList.add(new StatusList.fromJson(v));
      });
    }
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    updatedBy = json['updatedBy'];
    promoDetails = json['promoDetails'] != null ? new PromoDetails.fromJson(json['promoDetails']) : null;
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['orderType'] = this.orderType;
    data['paymentType'] = this.paymentType;
    data['createdBy'] = this.createdBy;
    if (this.branch != null) {
      data['branch'] = this.branch.toJson();
    }
    data['itemTotal'] = this.itemTotal;
    data['totalAmount'] = this.totalAmount;
    if (this.customerDetails != null) {
      data['customerDetails'] = this.customerDetails.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['orderCode'] = this.orderCode;
    data['status'] = this.status;
    if (this.statusList != null) {
      data['statusList'] = this.statusList.map((v) => v.toJson()).toList();
    }
    data['createdDate'] = this.createdDate;
    data['modifiedDate'] = this.modifiedDate;
    data['updatedBy'] = this.updatedBy;
    if (this.promoDetails != null) {
      data['promoDetails'] = this.promoDetails.toJson();
    }
    data['discount'] = this.discount;
    return data;
  }
}

class Branch {
  String branchCode;
  String name;
  String address;
  String pincode;

  Branch({this.branchCode, this.name, this.address, this.pincode});

  Branch.fromJson(Map<String, dynamic> json) {
    branchCode = json['branchCode'];
    name = json['name'];
    address = json['address'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branchCode'] = this.branchCode;
    data['name'] = this.name;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    return data;
  }
}

class CustomerDetails {
  String sId;
  String name;
  List<PhoneNumbers> phoneNumbers;
  String address;
  String pincode;
  num noOfOrder;
  bool isActive;
  String createdDate;
  String createdBy;
  String customerCode;
  String modifiedDate;
  String updatedBy;

  CustomerDetails(
      {this.sId,
      this.name,
      this.phoneNumbers,
      this.address,
      this.pincode,
      this.noOfOrder,
      this.isActive,
      this.createdDate,
      this.createdBy,
      this.customerCode,
      this.modifiedDate,
      this.updatedBy});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    if (json['phoneNumbers'] != null) {
      phoneNumbers = new List<PhoneNumbers>();
      json['phoneNumbers'].forEach((v) {
        phoneNumbers.add(new PhoneNumbers.fromJson(v));
      });
    }
    address = json['address'];
    pincode = json['pincode'];
    noOfOrder = json['noOfOrder'];
    isActive = json['isActive'];
    createdDate = json['createdDate'];
    createdBy = json['createdBy'];
    customerCode = json['customerCode'];
    modifiedDate = json['modifiedDate'];
    updatedBy = json['updatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    if (this.phoneNumbers != null) {
      data['phoneNumbers'] = this.phoneNumbers.map((v) => v.toJson()).toList();
    }
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['noOfOrder'] = this.noOfOrder;
    data['isActive'] = this.isActive;
    data['createdDate'] = this.createdDate;
    data['createdBy'] = this.createdBy;
    data['customerCode'] = this.customerCode;
    data['modifiedDate'] = this.modifiedDate;
    data['updatedBy'] = this.updatedBy;
    return data;
  }
}

class PhoneNumbers {
  String code;
  String phoneNumber;
  bool isPrimary;

  PhoneNumbers({this.code, this.phoneNumber, this.isPrimary});

  PhoneNumbers.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    phoneNumber = json['phoneNumber'];
    isPrimary = json['isPrimary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['phoneNumber'] = this.phoneNumber;
    data['isPrimary'] = this.isPrimary;
    return data;
  }
}

class Items {
  ProductDetails productDetails;
  String cookingInstraction;
  num quantity;
  num total;
  String cookingInstructions;
  List<AddOns> addOns;

  Items(
      {this.productDetails, this.cookingInstraction, this.quantity, this.total, this.cookingInstructions, this.addOns});

  Items.fromJson(Map<String, dynamic> json) {
    productDetails = json['productDetails'] != null ? new ProductDetails.fromJson(json['productDetails']) : null;
    cookingInstraction = json['cookingInstraction'];
    quantity = json['quantity'];
    total = json['total'];
    cookingInstructions = json['cookingInstructions'];
    if (json['addOns'] != null) {
      addOns = new List<AddOns>();
      json['addOns'].forEach((v) {
        addOns.add(new AddOns.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productDetails != null) {
      data['productDetails'] = this.productDetails.toJson();
    }
    data['cookingInstraction'] = this.cookingInstraction;
    data['quantity'] = this.quantity;
    data['total'] = this.total;
    data['cookingInstructions'] = this.cookingInstructions;
    if (this.addOns != null) {
      data['addOns'] = this.addOns.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductDetails {
  String productCode;
  String name;
  num price;
  String categoryCode;
  String branchCode;
  String shortDescription;
  String fullDescription;
  num weight;
  num energy;
  num protein;
  num fat;
  List images;
  bool isActive;
  num totalQuantity;
  Category category;
  Branch branch;

  ProductDetails(
      {this.productCode,
      this.name,
      this.price,
      this.categoryCode,
      this.branchCode,
      this.shortDescription,
      this.fullDescription,
      this.weight,
      this.energy,
      this.protein,
      this.fat,
      this.images,
      this.isActive,
      this.totalQuantity,
      this.category,
      this.branch});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    productCode = json['productCode'];
    name = json['name'];
    price = json['price'];
    categoryCode = json['categoryCode'];
    branchCode = json['branchCode'];
    shortDescription = json['shortDescription'];
    fullDescription = json['fullDescription'];
    weight = json['weight'];
    energy = json['energy'];
    protein = json['protein'];
    fat = json['fat'];
    images = json['images'];
    isActive = json['isActive'];
    totalQuantity = json['totalQuantity'];
    category = json['category'] != null ? new Category.fromJson(json['category']) : null;
    branch = json['branch'] != null ? new Branch.fromJson(json['branch']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productCode'] = this.productCode;
    data['name'] = this.name;
    data['price'] = this.price;
    data['categoryCode'] = this.categoryCode;
    data['branchCode'] = this.branchCode;
    data['shortDescription'] = this.shortDescription;
    data['fullDescription'] = this.fullDescription;
    data['weight'] = this.weight;
    data['energy'] = this.energy;
    data['protein'] = this.protein;
    data['fat'] = this.fat;
    data['images'] = this.images;
    data['isActive'] = this.isActive;
    data['totalQuantity'] = this.totalQuantity;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    if (this.branch != null) {
      data['branch'] = this.branch.toJson();
    }
    return data;
  }
}

class Category {
  String categoryCode;
  String name;
  String description;
  String imgUrl;

  Category({this.categoryCode, this.name, this.description, this.imgUrl});

  Category.fromJson(Map<String, dynamic> json) {
    categoryCode = json['categoryCode'];
    name = json['name'];
    description = json['description'];
    imgUrl = json['imgUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryCode'] = this.categoryCode;
    data['name'] = this.name;
    data['description'] = this.description;
    data['imgUrl'] = this.imgUrl;
    return data;
  }
}

class StatusList {
  String status;
  String createdBy;
  String createdDate;

  StatusList({this.status, this.createdBy, this.createdDate});

  StatusList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    return data;
  }
}

class PromoDetails {
  String code;
  num orderCount;
  num percentage;

  PromoDetails({this.code, this.orderCount, this.percentage});

  PromoDetails.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    orderCount = json['orderCount'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['orderCount'] = this.orderCount;
    data['percentage'] = this.percentage;
    return data;
  }
}
