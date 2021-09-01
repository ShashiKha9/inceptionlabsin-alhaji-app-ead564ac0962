import 'dart:convert';

import 'package:alhaji_user_app/models/cart.dart';
import 'package:alhaji_user_app/models/combo.dart';
import 'package:alhaji_user_app/models/products.dart';
import 'package:alhaji_user_app/models/promocode.dart';
import 'package:alhaji_user_app/utils/dio-request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartProducts = [];
  num _totalCartAmount;
  num _totalCartQuantity;
  num _taxAndFees = 0;
  bool _isLoading = false;
  PromoCodes _promoCodes;
  bool _isPromoCodesLoading = false;
  PromoCode _selectedPromoCode;

  // OrderDetail _orderDetail;
  // OrderDetail get orderDetail => _orderDetail;

  //getters
  List<CartItem> get cartProducts => _cartProducts;
  num get totalCartAmount => _totalCartAmount;
  num get totalCartQuantity => _totalCartQuantity;
  num get taxAndFees => _taxAndFees;
  bool get isLoading => _isLoading;
  PromoCodes get promoCodes => _promoCodes;
  bool get isPromoCodesLoading => _isPromoCodesLoading;
  PromoCode get selectedPromoCode => _selectedPromoCode;

  clearCart() {
    _cartProducts = [];
    _totalCartAmount = null;
    _totalCartQuantity = null;
    _selectedPromoCode = null;
    notifyListeners();
  }

  clearPromoCode() {
    _selectedPromoCode = null;
    notifyListeners();
  }

  // clearOrderDetails() {
  //   _orderDetail = null;
  //   notifyListeners();
  // }

  Future<void> getPromoCodes(String bearer, String customerCode) async {
    print(bearer);
    List sample = [];
    _isPromoCodesLoading = true;
    notifyListeners();
    try {
      dioRequest.options.headers.addAll({'Authorization': 'Bearer $bearer'});
      var response = await dioRequest.get('customer/promoCodes?customerCode=$customerCode');
      if (response.data.runtimeType != sample.runtimeType) _promoCodes = PromoCodes.fromJson(response.data);
      _isPromoCodesLoading = false;
      print(response);
      notifyListeners();
    } on DioError catch (e) {
      print(e.response);
      _isPromoCodesLoading = false;
      notifyListeners();
    }
  }

  updateCartItem(bool taxInclusive, {Product product, int count, Combo combo, num price}) {
    PRODUCTTYPE _productType;
    if (product != null) _productType = PRODUCTTYPE.PRODUCT;
    if (combo != null) _productType = PRODUCTTYPE.COMBO;
    if (count == 0) {
      if (_productType == PRODUCTTYPE.PRODUCT)
        _cartProducts.removeAt(getProductIndex(product.productCode, _productType));
      if (_productType == PRODUCTTYPE.COMBO) _cartProducts.removeAt(getProductIndex(combo.comboCode, _productType));
      getTotal();
      notifyListeners();
    } else {
      if (_cartProducts.isNotEmpty) {
        if (_productType == PRODUCTTYPE.PRODUCT) {
          if (isProductFound(product.productCode, _productType)) {
            _cartProducts[getProductIndex(product.productCode, _productType)].quantity = count;
            _cartProducts[getProductIndex(product.productCode, _productType)].price = price * count;
            _cartProducts[getProductIndex(product.productCode, _productType)].tax =
            taxInclusive ? num.parse(((price * count) / 6).toStringAsFixed(2)) : 0;
          } else {
            _cartProducts.add(CartItem(
              _productType,
              product: product,
              combo: combo,
              tax: taxInclusive ? ((price / 6) * count) : 0,
              quantity: count,
              price: price * count,
              addOns: [],
            ));
          }
        }
        if (_productType == PRODUCTTYPE.COMBO) {
          if (isProductFound(combo.comboCode, _productType)) {
            _cartProducts[getProductIndex(combo.comboCode, _productType)].quantity = count;
            _cartProducts[getProductIndex(combo.comboCode, _productType)].price = price * count;
            _cartProducts[getProductIndex(combo.comboCode, _productType)].tax =
            taxInclusive ? num.parse(((price * count) / 6).toStringAsFixed(2)) : 0;
          } else {
            _cartProducts.add(CartItem(
              _productType,
              product: product,
              combo: combo,
              tax: taxInclusive ? num.parse(((price * count) / 6).toStringAsFixed(2)) : 0,
              quantity: count,
              price: price * count,
              addOns: [],
            ));
          }
        }
        getTotal();
        notifyListeners();
      } else {
        _cartProducts.add(CartItem(
          _productType,
          product: product,
          combo: combo,
          quantity: count,
          tax: taxInclusive ? ((price / 6) * count) : 0,
          price: price,
          addOns: [],
        ));
        getTotal();
        notifyListeners();
      }
    }
  }

  updateAddOns(String productId, Product addOn, count, PRODUCTTYPE producttype) {
    int index = getProductIndex(productId, producttype);
    if (count == 0) {
      _cartProducts[index].addOns.removeAt(getAddOnIndex(productId, addOn, producttype));
      getTotal();
      notifyListeners();
    } else {
      if (_cartProducts[index].addOns.isNotEmpty) {
        if (isAddOnFound(productId, addOn, producttype)) {
          _cartProducts[index].addOns[getAddOnIndex(productId, addOn, producttype)].count = count;
          _cartProducts[index].addOns[getAddOnIndex(productId, addOn, producttype)].price = addOn.price * count;
          _cartProducts[index].addOns[getAddOnIndex(productId, addOn, producttype)].tax =
          addOn.isTaxInclusive ? (addOn.price * count) / 6 : 0;
        } else {
          _cartProducts[index].addOns.add(CartAddOns(
              addOn: addOn,
              count: count,
              price: addOn.price * count,
              tax: addOn.isTaxInclusive ? (addOn.price * count) / 6 : 0));
        }
        notifyListeners();
      } else {
        _cartProducts[index].addOns.add(CartAddOns(
            addOn: addOn,
            count: count,
            price: addOn.price * count,
            tax: addOn.isTaxInclusive ? (addOn.price * count) / 6 : 0));
        notifyListeners();
      }
      getTotal();
    }
  }

  bool isAddOnFound(String productId, Product addOn, PRODUCTTYPE producttype) {
    int index = getProductIndex(productId, producttype);
    bool value = false;
    for (int i = 0; i < _cartProducts[index].addOns.length; i++) {
      if (_cartProducts[index].addOns[i].addOn.sId == addOn.sId) {
        value = true;
        break;
      }
    }
    return value;
  }

  int getAddOnIndex(String productId, Product addOn, PRODUCTTYPE producttype) {
    int index = getProductIndex(productId, producttype);
    int value;
    for (int i = 0; i < _cartProducts[index].addOns.length; i++) {
      if (_cartProducts[index].addOns[i].addOn.sId == addOn.sId) {
        value = i;
        break;
      }
    }
    return value;
  }

  getTotal() {
    num amount = 0;
    num tax = 0;
    int qty = 0;
    for (int i = 0; i < _cartProducts.length; i++) {
      amount += _cartProducts[i].price;
      qty += _cartProducts[i].quantity;
      tax += _cartProducts[i].tax ?? 0;
      if (_cartProducts[i].addOns.isNotEmpty) {
        for (int j = 0; j < _cartProducts[i].addOns.length; j++) {
          amount += _cartProducts[i].addOns[j].price;
          tax += _cartProducts[i].addOns[j].tax ?? 0;
        }
      }
    }
    _totalCartAmount = amount;
    _taxAndFees = tax;
    _totalCartQuantity = qty;
    notifyListeners();
  }

  bool isProductFound(String id, PRODUCTTYPE producttype) {
    bool found = false;
    for (int i = 0; i < _cartProducts.length; i++) {
      if (producttype == PRODUCTTYPE.PRODUCT) {
        if (_cartProducts[i].product?.productCode == id) {
          found = true;
          break;
        }
      } else if (producttype == PRODUCTTYPE.COMBO) {
        if (_cartProducts[i].combo?.comboCode == id) {
          found = true;
          break;
        }
      }
    }
    return found;
  }

  int getProductIndex(String id, PRODUCTTYPE producttype) {
    int index;
    for (int i = 0; i < _cartProducts.length; i++) {
      if (producttype == PRODUCTTYPE.PRODUCT) {
        if (_cartProducts[i].product?.productCode == id) {
          index = i;
          break;
        }
      }
      if (producttype == PRODUCTTYPE.COMBO) {
        if (_cartProducts[i].combo?.comboCode == id) {
          index = i;
          break;
        }
      }
    }
    return index;
  }

  Future<bool> checkout(Map<String, dynamic> customerDetails, Map<String, dynamic> branchDetails, String accessToken,
      GlobalKey<ScaffoldState> scaffoldkey) async {
    print('tap 3');
    _isLoading = true;
    notifyListeners();
    try {
      dioRequest.options.headers.addAll({'Authorization': 'Bearer $accessToken'});
      List<Map<String, dynamic>> list = [];
      for (int i = 0; i < _cartProducts.length; i++) {
        Map<String, dynamic> _map = {};
        if (_cartProducts[i].productType == PRODUCTTYPE.PRODUCT) {
          _map['productDetails'] = _cartProducts[i].product.toJson(totalQuantity: _cartProducts[i].quantity);
        }
        if (_cartProducts[i].productType == PRODUCTTYPE.COMBO) {
          _map['productDetails'] = _cartProducts[i].combo.toJson(totalQuantity: _cartProducts[i].quantity);
        }
        num sum = 0;
        if (_cartProducts[i].addOns != null) {
          List<Map<String, dynamic>> list = [];
          for (int j = 0; j < _cartProducts[i].addOns.length; j++) {
            sum = sum + (_cartProducts[i].addOns[j].count * _cartProducts[i].addOns[j].addOn.price);
            Map<String, dynamic> _addOn =
            _cartProducts[i].addOns[j].addOn.toJson(totalQuantity: _cartProducts[i].addOns[j].count);
            list.add(_addOn);
          }
          _map['addOns'] = list;
          print(list);
        }
        _map['total'] = _cartProducts[i].price + (sum ?? 0);
        print('price ::: ${_cartProducts[i].price + (sum ?? 0)}');
        list.add(_map);
      }
      Map<String, dynamic> promoDetails = selectedPromoCode != null ? selectedPromoCode.toJson() : null;
      num discount =
      selectedPromoCode != null ? ((totalCartAmount / 100) * selectedPromoCode.promoCodeDetails.percentage) : 0;
      Map<String, dynamic> map = {
        'items': list,
        'itemTotal': totalCartAmount,
        "taxAndFees": taxAndFees,
        'promoDetails': promoDetails,
        'discount': discount,
        "totalAmount": totalCartAmount,
        "customerDetails": customerDetails,
        "paymentType": "CASH",
        "paymentMethod": "cash",
        // "paymentType": "STRIPE",
        "branch": branchDetails,
        "orderType": "TAKEAWAY",
        "createdBy": "EMP002",
        "source": "APP"
      };

      var response = await dioRequest.post('order', data: map);
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      String prettyprint = encoder.convert(response.data);
      debugPrint(prettyprint);
      print('Success');
      // _orderDetail = OrderDetail.fromJson(response.data);
      _isLoading = false;
      notifyListeners();
      scaffoldkey.currentState
          .showSnackBar(SnackBar(content: Text('Order Placed'), duration: Duration(milliseconds: 4000)));
      return true;
    } catch (e) {
      print(e);
      print(e.response);
      scaffoldkey.currentState.showSnackBar(SnackBar(
          content: Text('We are facing some issue, Order is Not Placed'), duration: Duration(milliseconds: 4000)));
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  changeCookingInstruction(int index, String instruction) {
    _cartProducts[index].cookingInstruction = instruction;
    notifyListeners();
  }

  changePromoCode(PromoCode promoCode) {
    if (promoCode == null) {
      _selectedPromoCode = null;
    }
    if (_selectedPromoCode != null) {
      if (promoCode.sId == _selectedPromoCode.sId)
        _selectedPromoCode = null;
      else
        _selectedPromoCode = promoCode;
    } else
      _selectedPromoCode = promoCode;
    notifyListeners();
  }
}

// class OrderDetail {
//   String secret;
//   String id;
//   String url;
//   num price;
//
//   OrderDetail(this.secret, this.id, this.url, this.price);
//
//   OrderDetail.fromJson(Map<String, dynamic> json) {
//     secret = json["paymentDetails"]["clientSecret"];
//     id = json["paymentDetails"]["paymentIntentId"];
//     url = json["paymentDetails"]["url"];
//     price = json["itemTotal"];
//   }
// }
