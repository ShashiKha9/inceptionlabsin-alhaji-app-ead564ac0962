import 'package:alhaji_user_app/models/combo.dart';
import 'package:alhaji_user_app/models/products.dart';
import 'package:flutter/cupertino.dart';

enum PRODUCTTYPE { PRODUCT, COMBO }

class CartItem {
  PRODUCTTYPE productType;
  Product product;
  Combo combo;
  int quantity;
  num price;
  num tax;
  String cookingInstruction;
  List<CartAddOns> addOns;
  CartItem(this.productType,
      {this.product,
      this.combo,
      @required this.quantity,
      @required this.price,
      this.addOns,
      this.cookingInstruction,
      @required this.tax});
}

class CartAddOns {
  Product addOn;
  int count;
  num price;
  num tax;
  CartAddOns({this.addOn, this.count, this.price, @required this.tax});
}

class Cart {
  List<CartItem> items;
  num totalPrice;
  num totalTax;
  Cart({this.items, this.totalPrice, @required this.totalTax});
}
