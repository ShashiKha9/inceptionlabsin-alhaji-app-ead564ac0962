import 'package:alhaji_user_app/models/combo.dart';
import 'package:alhaji_user_app/models/products.dart';
import 'package:alhaji_user_app/utils/dio-request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class WishListProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<CommonProduct> _wishListProducts = [];
  //getters
  List<CommonProduct> get wishListProducts => _wishListProducts;
  bool get isLoading => _isLoading;

  Future<void> updateWishList(String bearer, String customerCode, String branchCode,
      {Product product, Combo combo}) async {
    print(bearer);
    List sample = [];
    _isLoading = true;
    notifyListeners();
    try {
      dioRequest.options.headers.addAll({'Authorization': 'Bearer $bearer'});
      var response;
      if (!isProductAvailable(product: product, combo: combo)) {
        Map<String, dynamic> data = {
          'customerCode': customerCode,
          'productCode': product != null ? product.productCode : combo.comboCode,
          'productDetails': product != null ? product.toJson() : combo.toJson()
        };
        response = await dioRequest.post('wishlist', data: data);
      } else {
        String productCode = product != null ? product.productCode : combo.comboCode;
        response = await dioRequest.delete('wishlist/$customerCode/$productCode');
      }
      _isLoading = false;
      getWishList(bearer, customerCode, branchCode);

      print(customerCode);
      notifyListeners();
    } on DioError catch (e) {
      print(e.response);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getWishList(String bearer, String customerCode, String branchCode) async {
    if (!_isLoading) {
      List sample = [];
      _isLoading = true;
      notifyListeners();
      _wishListProducts = [];
      try {
        dioRequest.options.headers.addAll({'Authorization': 'Bearer $bearer'});
        var response = await dioRequest.get('wishlists?customerCode=$customerCode&branchCode=$branchCode');
        if (response.data.runtimeType != sample.runtimeType) {
          response.data['result'].forEach((v) {
            _wishListProducts.add(new CommonProduct.fromJson(v));
          });
        }
        _isLoading = false;
        notifyListeners();
      } on DioError catch (e) {
        print(e.response);
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  bool isProductAvailable({Product product, Combo combo}) {
    bool found = false;
    for (int i = 0; i < _wishListProducts.length; i++) {
      if (_wishListProducts[i].product.productCode == (product != null ? product.productCode : combo.comboCode)) {
        found = true;
        break;
      }
    }
    return found;
  }
}

class CommonProduct {
  Product product;
  Combo combo;
  CommonProduct.fromJson(Map<String, dynamic> json) {
    if (json['comboCode'] != null) {
      combo = Combo.fromJson(json);
    } else {
      product = Product.fromJson(json);
    }
  }
}
